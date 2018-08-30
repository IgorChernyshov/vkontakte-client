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
    pairTableAndRealm()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    APIService.instance.requestUsersGroups()
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

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      let group = groups[indexPath.row]
      do {
        guard let realm = try? Realm() else {
          return
        }
        try realm.write {
          realm.delete(group)
        }
        tableView.deleteRows(at: [indexPath], with: .fade)
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  @IBAction func unwindSegue(unwindSegue: UIStoryboardSegue) {
    tableView.reloadData()
  }

}
