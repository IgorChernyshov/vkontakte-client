//
//  DataService.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 05.07.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import Foundation
import RealmSwift

class DataService {
  
  static let instance = DataService()
  
  private init() {}
  
  func saveUsersFriendsList(_ users: [RealmUser]) {
    do {
      let realm = try Realm()
      // Clean all cached friends and their photos
      let oldUsersFriendsList = realm.objects(RealmUser.self)
      let oldUsersPhotos = realm.objects(RealmPhoto.self)
      try realm.write {
        realm.delete(oldUsersPhotos)
        realm.delete(oldUsersFriendsList)
        realm.add(users)
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func saveFriendsPhotos(_ photos: [RealmPhoto], forUser: String) {
    do {
      let realm = try Realm()
      guard let user = realm.object(ofType: RealmUser.self, forPrimaryKey: Int(forUser)) else {
        return
      }
      let oldPhotos = user.photos
      try realm.write {
        realm.delete(oldPhotos)
        user.photos.append(objectsIn: photos)
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func saveUsersGroups(_ groups: [RealmGroup]) {
    do {
      let realm = try Realm()
      let oldUsersGroups = realm.objects(RealmGroup.self)
      try realm.write {
        realm.delete(oldUsersGroups)
        realm.add(groups)
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func saveUsersNewsList(_ news: [RealmNews]) {
    do {
      let realm = try Realm()
      let oldUsersNewsList = realm.objects(RealmNews.self)
      try realm.write {
        realm.delete(oldUsersNewsList)
        realm.add(news)
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func saveUsersConversations(_ conversations: [RealmConversation]) {
    do {
      let realm = try Realm()
      let oldUsersConversations = realm.objects(RealmConversation.self)
      try realm.write {
        realm.delete(oldUsersConversations)
        realm.add(conversations)
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func saveMessages(_ messages: [RealmMessage]) {
    do {
      let realm = try Realm()
      let oldMessages = realm.objects(RealmMessage.self)
      try realm.write {
        realm.delete(oldMessages)
        realm.add(messages)
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func saveNumberOfLikes(for newsPost: Int, newLikesCount: Int, action: String) {
    do {
      let realm = try Realm()
      let postToLike = realm.objects(RealmNews.self).filter("postId = %@", newsPost)
      guard let post = postToLike.first else {
        return
      }
      try realm.write {
        post.likesCount = newLikesCount
        if action == "add" {
          post.userLikes = 1
        } else {
          post.userLikes = 0
        }
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
}
