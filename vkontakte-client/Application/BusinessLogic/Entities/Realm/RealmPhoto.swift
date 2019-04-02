//
//  RealmPhoto.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 26.06.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class RealmPhoto: Object {
  
  @objc dynamic var ownerId = 0
  @objc dynamic var id = 0
  @objc dynamic var imageUrl = ""
  
  convenience init(json: JSON) {
    self.init()
    DispatchQueue.global().async {
      self.ownerId = json["owner_id"].intValue
      self.id = json["id"].intValue
      self.imageUrl = json["sizes"][2]["url"].stringValue
    }
  }
  
}
