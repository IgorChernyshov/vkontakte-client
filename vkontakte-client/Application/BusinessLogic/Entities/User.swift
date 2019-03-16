//
//  User.swift
//  vkontakte-client
//
//  Created by Igor Chernyshov on 16/03/2019.
//  Copyright © 2019 Igor Chernyshov. All rights reserved.
//

import Foundation

struct User {
  
  let id: Int
  let firstName: String
  let lastName: String
  let imageURL: String
  let photos: [Photo]
  
}
