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
  
  // Send selected user's id to the next controller
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toMessages" {
      let messagesViewController = segue.destination as! MessagesViewController
      let indexPath = tableView.indexPathForSelectedRow!
      messagesViewController.conversationWithUserID = conversations[indexPath.row].withUserId
    }
  }
  
  private func showDeleteConfirmationForm(id: String) {
    let alertController = UIAlertController(title: "Удалить беседу?", message: "История переписки будет удалена навсегда", preferredStyle: .alert)
    let confirmAction = UIAlertAction(title: "Удалить", style: .destructive) { action in
      ConversationsService.instance.deleteConversation(withUser: id)
      ConversationsService.instance.requestUsersConversations()
    }
    alertController.addAction(confirmAction)
    let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    present(alertController, animated: true, completion: nil)
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
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
    return UITableViewCellEditingStyle.none // This turns off default editing style because we have a custom setup
  }
  
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    var action = [UITableViewRowAction]()
    let deleteAction = UITableViewRowAction(style: .destructive, title: "УДАЛИТЬ") { [weak self] (rowAction, indexPath) in
      guard let strongSelf = self else { return }
      let id = String(strongSelf.conversations[indexPath.row].withUserId)
      self?.showDeleteConfirmationForm(id: id)
    }
    deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    action = [deleteAction]
    
    return action
  }
  
}
