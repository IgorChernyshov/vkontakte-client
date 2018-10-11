//
//  MessagesService.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 19.08.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessagesService {
  
  static let instance = MessagesService()
  
  private init() {}
  
  private var messages = [Message]()
  
  // Get 50 last messages
  func requestMessages(withUser: Int) {
    let url = "https://api.vk.com/method/messages.getHistory?access_token=\(APIService.instance.authToken)&v=\(APIService.instance.apiVersion)"
    let parameters: Parameters = [
      "user_id": String(withUser),
      "count": "50"
    ]
    
    Alamofire.request(url, parameters: parameters).responseData(queue: .global()) { [weak self] (response) in
      guard let data = response.result.value else { return }
      do {
        guard let strongSelf = self else { return }
        let json = try JSON(data: data)
        self?.messages = json["response"]["items"].compactMap { Message(json: $0.1) }
        // Filter out empty messages
        // TODO: replace this with an attachments handler.
        self?.messages = (self?.messages.filter { $0.text != "" })!
        DataService.instance.saveMessages(strongSelf.messages)
        self?.markMessagesAsRead(withUser)
      }
      catch {
        print(error.localizedDescription)
      }
      }.resume()
  }
  
  func markMessagesAsRead(_ fromUser: Int) {
    let url = "https://api.vk.com/method/messages.markAsRead?access_token=\(APIService.instance.authToken)&v=\(APIService.instance.apiVersion)"
    let parameters: Parameters = [
      "peer_id": String(fromUser)
    ]
    
    Alamofire.request(url, parameters: parameters).response(queue: .global(), completionHandler: {_ in }).resume()
  }
  
  func sendMessage(text: String, toConversationID: Int) {
    let url = "https://api.vk.com/method/messages.send?access_token=\(APIService.instance.authToken)&v=\(APIService.instance.apiVersion)"
    let parameters: Parameters = [
      "user_id": String(toConversationID),
      "message": text
    ]
    
    Alamofire.request(url, parameters: parameters).responseData(queue: .global()) { [weak self] (response) in
      self?.requestMessages(withUser: toConversationID)
      }.resume()
  }
}
