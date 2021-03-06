//
//  NewsFeedService.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 16.07.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NewsFeedService {
  
  static let instance = NewsFeedService()
  
  private init() {}
  
  private var news = [RealmNews]()
  private var users = [RealmUser]()
  private var groups = [RealmGroup]()
  
  // Get news feed containing posts and photos, but with only 1 attachment and not more than 20 posts
  func requestUsersNewsFeed() {
    let url = "https://api.vk.com/method/newsfeed.get?access_token=\(APIService.instance.authToken)&v=\(APIService.instance.apiVersion)"
    let parameters: Parameters = [
      "filters": "post,photo",
      "max_photos": "1",
      "count": "50"
    ]
    
    Alamofire.request(url, parameters: parameters).responseData(queue: .global()) { [weak self] (response) in
      guard let data = response.result.value else {
        return
      }
      do {
        guard let strongSelf = self else {
          return
        }
        let json = try JSON(data: data)
        self?.news = json["response"]["items"].compactMap { RealmNews(json: $0.1) }
        self?.users = json["response"]["profiles"].compactMap { RealmUser(json: $0.1) }
        self?.groups = json["response"]["groups"].compactMap { RealmGroup(json: $0.1) }
        self?.news = (self?.news.filter { $0.text != "" || $0.imageURL != "" })!
        self?.identifyNewsSource()
        DataService.instance.saveUsersNewsList(strongSelf.news)
      }
      catch {
        print(error.localizedDescription)
      }
      }.resume()
  }
  
  // Get news owners information
  func identifyNewsSource() {
    for post in self.news {
      if post.sourceId > 0 {
        let index = users.index(where: { (item) -> Bool in
          item.id == post.sourceId
        })
        post.ownerName = "\(users[index!].firstName) \(users[index!].lastName)"
        post.ownerPhoto = users[index!].imageUrl
      } else {
        let index = groups.index(where: { (item) -> Bool in
          item.id == post.sourceId * -1
        })
        post.ownerName = groups[index!].name
        post.ownerPhoto = groups[index!].imageUrl
      }
    }
  }
  
  func changeNumberOfLikes(_ id: Int, ownerId: Int, action: String) {
    let url = "https://api.vk.com/method/likes.\(action)?access_token=\(APIService.instance.authToken)&v=\(APIService.instance.apiVersion)"
    let parameters: Parameters = [
      "type": "post",
      "item_id": id,
      "owner_id": ownerId
    ]
    
    Alamofire.request(url, parameters: parameters).responseData(queue: .global()) { (response) in
      guard let data = response.result.value else {
        return
      }
      do {
        let json = try JSON(data: data)
        let numberOfLikes = json["response"]["likes"].intValue
        DataService.instance.saveNumberOfLikes(for: id, newLikesCount: numberOfLikes, action: action)
      }
      catch {
        print(error.localizedDescription)
      }
      }.resume()
  }
  
}
