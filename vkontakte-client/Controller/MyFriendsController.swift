//
//  MyFriendsController.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 19.06.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit
import RealmSwift

class MyFriendsController: UITableViewController {
  
  private var users: Results<User>!
  private var token: NotificationToken?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    pairTableAndRealm()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    APIService.instance.requestUsersFriendsList()
  }
  
  private func pairTableAndRealm() {
    guard let realm = try? Realm() else {
      return
    }
    users = realm.objects(User.self)
    token = users?.observe({ [weak self] (changes: RealmCollectionChange) in
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
    if users.count == 0 {
      tableView.separatorStyle = .none
    } else {
      tableView.separatorStyle = .singleLine
    }
    return users.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "myFriendsCell", for: indexPath) as? MyFriendsCell else {
      return UITableViewCell()
    }
    cell.configure(users[indexPath.row], cell: cell, indexPath: indexPath, tableView: tableView)
    return cell
  }
  
  // Send selected user's id to the next controller
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toFriendsPhotos" {
      let myFriendsPhotosController = segue.destination as! MyFriendsPhotosController
      let indexPath = tableView.indexPathForSelectedRow!
      myFriendsPhotosController.usersId = "\(users[indexPath.row].id)"
    }
  }
  
}
