//
//  MyFriendsPhotosAdapter.swift
//  vkontakte-client
//
//  Created by Igor Chernyshov on 16/03/2019.
//  Copyright © 2019 Igor Chernyshov. All rights reserved.
//

import Foundation
import RealmSwift

final class MyFriendsPhotosAdapter {
  
  private var realmNotificationToken: NotificationToken?
  
  func getPhotos(of userID: String, then completion: @escaping ([Photo]) -> Void) {
    guard let realm = try? Realm(),
      let realmUser = realm.object(ofType: RealmUser.self, forPrimaryKey: Int(userID)) else { return }
    let realmPhotos = realmUser.photos
    realmNotificationToken?.invalidate()
    
    let token = realmPhotos.observe({ [weak self] (changes: RealmCollectionChange) in
      guard let self = self else { return }
      
      switch changes {
      case .initial:
        break
      case .update(let realmPhotos, _, _, _):
        var photos: [Photo] = []
        for realmPhoto in realmPhotos {
          photos.append(self.photo(from: realmPhoto))
        }
        self.realmNotificationToken?.invalidate()
        completion(photos)
      case .error(let error):
        fatalError("\(error)")
      }
    })
    realmNotificationToken = token
    
    APIService.instance.requestUsersProfilePhotos(userId: userID)
  }
  
  func photo(from realmPhoto: RealmPhoto) -> Photo {
    return Photo(ownerID: realmPhoto.ownerId,
                 id: realmPhoto.id,
                 imageURL: realmPhoto.imageUrl)
  }
  
}
