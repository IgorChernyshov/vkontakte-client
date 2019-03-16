//
//  MyFriendsController.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 19.06.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class MyFriendsController: UITableViewController {
  
  private let myFriendsService = MyFriendsAdapter()
  private var users: [User] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addRefreshControl()
    myFriendsService.getFriends() { [weak self] users in
      self?.users = users
      self?.tableView.reloadData()
    }
  }
  
  private func addRefreshControl() {
    refreshControl = UIRefreshControl()
    tableView.addSubview(refreshControl!)
    refreshControl?.tintColor = UIColor.activityIndicatorColor
    refreshControl?.addTarget(self, action: #selector(refreshFriendsList(_:)), for: .valueChanged)
  }
  
  @objc private func refreshFriendsList(_ sender: Any) {
    APIService.instance.requestUsersFriendsList()
    self.refreshControl?.endRefreshing()
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
      myFriendsPhotosController.userId = "\(users[indexPath.row].id)"
    }
  }
  
}
