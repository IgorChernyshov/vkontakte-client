//
//  File.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 24.06.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Group: Object {
  
  @objc dynamic var id = 0
  @objc dynamic var name = ""
  @objc dynamic var imageUrl = ""
  @objc dynamic var membersCount = 0
  @objc dynamic var isMember = false
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  convenience init(json: JSON) {
    self.init()
    DispatchQueue.global().async {
      self.id = json["id"].intValue
      self.name = json["name"].stringValue
      self.imageUrl = json["photo_50"].stringValue
      self.membersCount = json["members_count"].intValue
      self.isMember = json["is_member"].boolValue
    }
  }
  
}
