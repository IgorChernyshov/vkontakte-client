//
//  MessagesViewController.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 19.08.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit
import RealmSwift

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var messageToSendText: UITextField!
  
  var conversationWithUserID: Int = 0
  private var messages: Results<RealmMessage>!
  private var token: NotificationToken?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    MessagesService.instance.requestMessages(withUser: conversationWithUserID)
    pairTableAndRealm()
    scrollToBottom()
  }
  
  private func pairTableAndRealm() {
    guard let realm = try? Realm() else {
      return
    }
    messages = realm.objects(RealmMessage.self)
    token = messages?.observe({ [weak self] (changes: RealmCollectionChange) in
      guard let tableView = self?.tableView else {
        return
      }
      switch changes {
      case .initial:
        tableView.reloadData()
        self?.scrollToBottom()
      case let .update(results,_ ,_ ,_ ):
        self?.messages = results.sorted(byKeyPath: "conversationMessageId", ascending: true)
        tableView.reloadData()
        self?.scrollToBottom()
      case .error(let error):
        fatalError("\(error)")
      }
    })
  }
  
  func scrollToBottom(){
    DispatchQueue.main.async { [weak self] in
      guard let strongSelf = self else { return }
      guard self?.messages.count != 0 else { return }
      let indexPath = IndexPath(row: strongSelf.messages.count-1, section: 0)
      self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
  }
  
  @IBAction func sendButtonWasPressed(_ sender: Any) {
    guard self.messageToSendText.text != "" else { return }
    MessagesService.instance.sendMessage(text: self.messageToSendText.text!, toConversationID: self.conversationWithUserID)
    self.messageToSendText.text = ""
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if messages[indexPath.row].fromID == messages[indexPath.row].peerID {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "incomingMessage", for: indexPath) as? IncomingMessageCell else {
        return UITableViewCell()
      }
      cell.configure(messages[indexPath.row])
      return cell
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "outgoingMessage", for: indexPath) as? OutgoingMessageCell else {
        return UITableViewCell()
      }
      cell.configure(messages[indexPath.row])
      return cell
    }
  }
  
}
