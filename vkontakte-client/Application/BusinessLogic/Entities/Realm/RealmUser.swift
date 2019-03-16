//
//  RealmUser.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 26.06.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class RealmUser: Object {
  
  @objc dynamic var id = 0
  @objc dynamic var firstName = ""
  @objc dynamic var lastName = ""
  @objc dynamic var imageUrl = ""
  let photos = List<RealmPhoto>()
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  convenience init(json: JSON) {
    self.init()
    DispatchQueue.global().async {
      self.id = json["id"].intValue
      self.firstName = json["first_name"].stringValue
      self.lastName = json["last_name"].stringValue
      self.imageUrl = json["photo_50"].stringValue
    }
  }
  
}
