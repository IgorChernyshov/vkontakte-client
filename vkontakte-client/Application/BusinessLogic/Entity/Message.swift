//
//  Message.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 19.08.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Message: Object {
  
  @objc dynamic var conversationMessageId = 0
  @objc dynamic var peerID = 0
  @objc dynamic var fromID = 0
  @objc dynamic var text = ""
  
  override static func primaryKey() -> String? {
    return "conversationMessageId"
  }
  
  convenience init(json: JSON) {
    self.init()
    DispatchQueue.global().async {
      self.conversationMessageId = json["conversation_message_id"].intValue
      self.peerID = json["peer_id"].intValue
      self.fromID = json["from_id"].intValue
      self.text = json["text"].stringValue
    }
  }
  
}
