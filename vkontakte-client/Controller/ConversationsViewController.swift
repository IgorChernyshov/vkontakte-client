//
//  ConversationsViewController.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 04.08.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit
import RealmSwift

class ConversationsViewController: UITableViewController {
  
  private var conversations: Results<Conversation>!
  private var token: NotificationToken?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    pairTableAndRealm()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    ConversationsService.instance.requestUsersConversations()
  }
  
  private func pairTableAndRealm() {
    guard let realm = try? Realm() else {
      return
    }
    conversations = realm.objects(Conversation.self)
    token = conversations?.observe({ [weak self] (changes: RealmCollectionChange) in
      guard let tableView = self?.tableView else {
        return
      }
      switch changes {
      case .initial:
        tableView.reloadData()
      case .update:
        tableView.reloadData()
      case .error(let error):
        fatalError("\(error)")
      }
    })
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if conversations.count == 0 {
      self.tableView.separatorStyle = .none
    } else {
      self.tableView.separatorStyle = .singleLine
    }
    return conversations.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as? ConversationCell else {
      return UITableViewCell()
    }
    cell.configure(conversations[indexPath.row], cell: cell, indexPath: indexPath, tableView: tableView)
    return cell
  }
  
  // Send selected user's id to the next controller
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toMessages" {
      let messagesViewController = segue.destination as! MessagesViewController
      let indexPath = tableView.indexPathForSelectedRow!
      messagesViewController.conversationWithUserID = conversations[indexPath.row].withUserId
    }
  }
  
}
