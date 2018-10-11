//
//  ConversationsService.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 04.08.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ConversationsService {
  
  static let instance = ConversationsService()
  
  private init() {}
  
  private var conversations = [Conversation]()
  private var users = [User]()
  
  // Get 50 last conversations
  func requestUsersConversations() {
    let url = "https://api.vk.com/method/messages.getConversations?access_token=\(APIService.instance.authToken)&v=\(APIService.instance.apiVersion)"
    let parameters: Parameters = [
      "extended": "1",
      "count": "50"
    ]
    
    Alamofire.request(url, parameters: parameters).responseData(queue: .global()) { [weak self] (response) in
      guard let data = response.result.value else {
        return
      }
      do {
        guard let strongSelf = self else {
          return
        }
        let json = try JSON(data: data)
        self?.conversations = json["response"]["items"].compactMap { Conversation(json: $0.1) }
        self?.users = json["response"]["profiles"].compactMap { User(json: $0.1) }
        // Remove conversations of type "chat"
        self?.conversations = strongSelf.conversations.filter { $0.chatType != "chat" }
        self?.conversations = strongSelf.conversations.filter { $0.chatType != "group" }
        self?.identifyConversationSource()
        DataService.instance.saveUsersConversations(strongSelf.conversations)
      }
      catch {
        print(error.localizedDescription)
      }
      }.resume()
  }
  
  // Get conversations owners information
  func identifyConversationSource() {
    for post in self.conversations {
      let index = users.index(where: { (item) -> Bool in
        item.id == post.withUserId
      })
      post.ownerName = "\(users[index!].firstName) \(users[index!].lastName)"
      post.ownerPhoto = users[index!].imageUrl
    }
  }
  
  func deleteConversation(withUser: String) {
    let url = "https://api.vk.com/method/messages.deleteConversation?access_token=\(APIService.instance.authToken)&v=\(APIService.instance.apiVersion)"
    let parameters: Parameters = [
      "peer_id": withUser
    ]
    
    Alamofire.request(url, parameters: parameters).response(queue: .global(), completionHandler: {_ in }).resume()
  }
}
