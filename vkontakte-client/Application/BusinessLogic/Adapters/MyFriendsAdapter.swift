//
//  MyFriendsAdapter.swift
//  vkontakte-client
//
//  Created by Igor Chernyshov on 16/03/2019.
//  Copyright © 2019 Igor Chernyshov. All rights reserved.
//

import Foundation
import RealmSwift

final class MyFriendsAdapter {
  
  private var realmNotificationToken: NotificationToken?
  
  func getFriends(then completion: @escaping ([User]) -> Void) {
    guard let realm = try? Realm() else { return }
    let realmUsers = realm.objects(RealmUser.self)
    realmNotificationToken?.invalidate()
    
    let token = realmUsers.observe({ [weak self] (changes: RealmCollectionChange) in
      guard let self = self else { return }
      
      switch changes {
      case .initial:
        break
      case .update(let realmUsers, _, _, _):
        var users: [User] = []
        for realmUser in realmUsers {
          users.append(self.user(from: realmUser))
        }
        self.realmNotificationToken?.invalidate()
        completion(users)
      case .error(let error):
        fatalError("\(error)")
      }
    })
    realmNotificationToken = token
    
    APIService.instance.requestUsersFriendsList()
  }
  
  func user(from realmUser: RealmUser) -> User {
    return User(id: realmUser.id,
                firstName: realmUser.firstName,
                lastName: realmUser.lastName,
                imageURL: realmUser.imageUrl,
                photos: photos(from: realmUser.photos))
  }
  
  func photos(from realmPhotos: List<RealmPhoto>) -> [Photo] {
    var photos: [Photo] = []
    for realmPhoto in realmPhotos {
      let photo = Photo(ownerID: realmPhoto.ownerId,
                        id: realmPhoto.id,
                        imageURL: realmPhoto.imageUrl)
      photos.append(photo)
    }
    return photos
  }
  
}
