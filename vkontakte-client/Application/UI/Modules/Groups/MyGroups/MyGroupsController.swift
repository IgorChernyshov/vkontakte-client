//
//  MyGroupsController.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 19.06.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit
import RealmSwift

class MyGroupsController: UITableViewController {
  
  private var groups: Results<Group>!
  private var token: NotificationToken?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addRefreshControl()
    APIService.instance.requestUsersGroups()
    pairTableAndRealm()
  }
  
  private func addRefreshControl() {
    refreshControl = UIRefreshControl()
    tableView.addSubview(refreshControl!)
    refreshControl?.tintColor = UIColor.activityIndicatorColor
    refreshControl?.addTarget(self, action: #selector(refreshGroupsList(_:)), for: .valueChanged)
  }
  
  @objc private func refreshGroupsList(_ sender: Any) {
    APIService.instance.requestUsersGroups()
    self.refreshControl?.endRefreshing()
  }
  
  private func pairTableAndRealm() {
    guard let realm = try? Realm() else {
      return
    }
    groups = realm.objects(Group.self)
    token = groups?.observe({ [weak self] (changes: RealmCollectionChange) in
      guard let tableView = self?.tableView else {
        return
      }
      switch changes {
      case .initial:
        tableView.reloadData()
      case let .update(results,_ ,_ ,_ ):
        self?.groups = results.sorted(byKeyPath: "membersCount", ascending: false)
        tableView.reloadData()
      case .error(let error):
        fatalError("\(error)")
      }
    })
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if groups.count == 0 {
      tableView.separatorStyle = .none
    } else {
      tableView.separatorStyle = .singleLine
    }
    return groups.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "myGroupsCell", for: indexPath) as? MyGroupsCell else {
      return UITableViewCell()
    }
    cell.configure(groups[indexPath.row], cell: cell, indexPath: indexPath, tableView: tableView)
    return cell
  }

  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
  }
  
  override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    var action = [UITableViewRowAction]()
    let deleteAction = UITableViewRowAction(style: .destructive, title: "Отписаться") { [weak self] (rowAction, indexPath) in
      guard let strongSelf = self else { return }
      let group = strongSelf.groups[indexPath.row]
      self?.showUnsubscribeConfirmationForm(id: group.id, indexPath: indexPath)
    }
    deleteAction.backgroundColor = UIColor.red
    action = [deleteAction]
    
    return action
  }
  
  private func showUnsubscribeConfirmationForm(id: Int, indexPath: IndexPath) {
    let alertController = UIAlertController(title: "Выйти от группы?", message: nil, preferredStyle: .alert)
    let confirmAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] action in
      APIService.instance.leaveGroup(id: id)
      let group = self?.groups[indexPath.row]
      do {
        guard let realm = try? Realm() else {
          return
        }
        try realm.write {
          realm.delete(group!)
        }
        self?.tableView.deleteRows(at: [indexPath], with: .fade)
      } catch {
        print(error.localizedDescription)
      }
    }
    alertController.addAction(confirmAction)
    let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    present(alertController, animated: true, completion: nil)
  }
  
  @IBAction func unwindSegue(unwindSegue: UIStoryboardSegue) {
    tableView.reloadData()
  }

}
