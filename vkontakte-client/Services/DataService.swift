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
  
  func saveUsersFriendsList(_ users: [User]) {
    do {
      let realm = try Realm()
      // Clean all cached friends and their photos
      let oldUsersFriendsList = realm.objects(User.self)
      let oldUsersPhotos = realm.objects(Photo.self)
      try realm.write {
        realm.delete(oldUsersPhotos)
        realm.delete(oldUsersFriendsList)
        realm.add(users)
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func saveFriendsPhotos(_ photos: [Photo], forUser: String) {
    do {
      let realm = try Realm()
      guard let user = realm.object(ofType: User.self, forPrimaryKey: Int(forUser)) else {
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
  
  func saveUsersGroups(_ groups: [Group]) {
    do {
      let realm = try Realm()
      let oldUsersGroups = realm.objects(Group.self)
      try realm.write {
        realm.delete(oldUsersGroups)
        realm.add(groups)
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func subscribeUserToGroup(_ group: Group) {
    do {
      let realm = try Realm()
      let currentGroups = realm.objects(Group.self)
      try realm.write {
        realm.add(currentGroups, update: true)
        realm.add(group)
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func saveUsersNewsList(_ news: [News]) {
    do {
      let realm = try Realm()
      let oldUsersNewsList = realm.objects(News.self)
      try realm.write {
        realm.delete(oldUsersNewsList)
        realm.add(news)
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func saveUsersConversations(_ conversations: [Conversation]) {
    do {
      let realm = try Realm()
      let oldUsersConversations = realm.objects(Conversation.self)
      try realm.write {
        realm.delete(oldUsersConversations)
        realm.add(conversations)
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func saveMessages(_ messages: [Message]) {
    do {
      let realm = try Realm()
      let oldMessages = realm.objects(Message.self)
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
      let postToLike = realm.objects(News.self).filter("postId = %@", newsPost)
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
