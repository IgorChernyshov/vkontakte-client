//
//  Conversation.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 04.08.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Conversation: Object {
  
  @objc dynamic var withUserId = 0
  @objc dynamic var chatType = ""
  @objc dynamic var text = ""
  @objc dynamic var unreadCount = 0
  @objc dynamic var ownerName = ""
  @objc dynamic var ownerPhoto = ""
  
  override static func primaryKey() -> String? {
    return "withUserId"
  }
  
  convenience init(json: JSON) {
    self.init()
    DispatchQueue.global().async {
      self.withUserId = json["conversation"]["peer"]["id"].intValue
      self.chatType = json["conversation"]["peer"]["type"].stringValue
      self.text = json["last_message"]["text"].stringValue
      self.unreadCount = json["conversation"]["unread_count"].intValue
    }
  }
  
}
