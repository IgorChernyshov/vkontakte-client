//
//  News.swift
//  vkontakte-client
//
//  Created by Igor Chernyshov on 16/03/2019.
//  Copyright © 2019 Igor Chernyshov. All rights reserved.
//

import Foundation

struct News {
  
  let sourceId: Int
  let postId: Int
  let ownerName: String
  let ownerPhoto: String
  let text: String
  let imageURL: String
  let imageWidth: Int
  let imageHeight: Int
  let likesCount: Int
  let userLikes: Int
  let commentsCount: Int
  let repostsCount: Int
  let userReposted: Int
  let views: Int
  
}
