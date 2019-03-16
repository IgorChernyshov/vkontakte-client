//
//  APIService.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 23.06.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIService {
  
  static let instance = APIService()
  
  private init() {}
  
  // Constants
  let appid = "6612678"
  let apiVersion = "5.80"
  
  // Authentication token for API calls
  var authToken = ""
  
  // API calls
  // Get user's friends list including name, id, online status
  func requestUsersFriendsList() {
    let url = "https://api.vk.com/method/friends.get?access_token=\(authToken)&v=\(apiVersion)"
    let parameters: Parameters = [
      "fields": "photo_50"
    ]
    
    Alamofire.request(url, parameters: parameters).responseData(queue: .global()) { (response) in
      guard let data = response.result.value else {
        return
      }
      do {
        let json = try JSON(data: data)
        let user = json["response"]["items"].compactMap { RealmUser(json: $0.1) }
        DataService.instance.saveUsersFriendsList(user)
      }
      catch {
        print(error.localizedDescription)
      }
    }.resume()
  }
  
  // Get user's profile photos
  func requestUsersProfilePhotos(userId: String) {
    let url = "https://api.vk.com/method/photos.get?access_token=\(authToken)&v=\(apiVersion)"
    let parameters: Parameters = [
      "album_id": "profile",
      "rev": 1,
      "owner_id": userId
    ]
    
    Alamofire.request(url, parameters: parameters).responseData(queue: .global()) { (response) in
      guard let data = response.result.value else {
        return
      }
      do {
        let json = try JSON(data: data)
        let photos = json["response"]["items"].compactMap { RealmPhoto(json: $0.1) }
        DataService.instance.saveFriendsPhotos(photos, forUser: userId)
      }
      catch {
        print(error.localizedDescription)
      }
    }.resume()
  }
  
  // Get current user's groups list
  func requestUsersGroups() {
    let url = "https://api.vk.com/method/groups.get?access_token=\(authToken)&v=\(apiVersion)"
    let parameters: Parameters = [
      "extended": "1",
      "fields": "members_count"
    ]
    
    Alamofire.request(url, parameters: parameters).responseData(queue: .global()) { (response) in
      guard let data = response.result.value else {
        return
      }
      do {
        let json = try JSON(data: data)
        let groups = json["response"]["items"].compactMap { RealmGroup(json: $0.1) }
        DataService.instance.saveUsersGroups(groups)
      }
      catch {
        print(error.localizedDescription)
      }
    }.resume()
  }
  
  // Get first 50 groups by keywords. Hide a group if user is already subscribed
  func searchGroupsByName(searchName: String, completion: @escaping ([RealmGroup]) -> Void) {
    let url = "https://api.vk.com/method/groups.search?access_token=\(authToken)&v=\(apiVersion)"
    let parameters: Parameters = [
      "q": searchName,
      "fields": "members_count",
      "count": "50"
    ]
    
    Alamofire.request(url, parameters: parameters).responseData(queue: .global()) { (response) in
      guard let data = response.result.value else {
        return
      }
      do {
        let json = try JSON(data: data)
        var group = json["response"]["items"].compactMap { RealmGroup(json: $0.1) }
        for (index, checkedGroup) in group.enumerated() {
          if checkedGroup.isMember {
            group.remove(at: index)
          }
        }
        completion(group)
      } catch {
        print(error.localizedDescription)
      }
    }.resume()
  }
  
  func joinGroup(id: Int) {
    let url = "https://api.vk.com/method/groups.join?access_token=\(authToken)&v=\(apiVersion)"
    let groupIDAsString = String(id)
    let parameters: Parameters = [
      "group_id": groupIDAsString
    ]
    
    Alamofire.request(url, parameters: parameters).response(queue: .global(), completionHandler: {_ in }).resume()
  }
  
  func leaveGroup(id: Int) {
    let url = "https://api.vk.com/method/groups.leave?access_token=\(authToken)&v=\(apiVersion)"
    let groupIDAsString = String(id)
    let parameters: Parameters = [
      "group_id": groupIDAsString
    ]
    
    Alamofire.request(url, parameters: parameters).response(queue: .global(), completionHandler: {_ in }).resume()
  }
  
}
