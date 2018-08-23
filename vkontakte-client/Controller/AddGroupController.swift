//
//  AddGroupController.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 19.06.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class AddGroupController: UITableViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  
  private var groupsList = [Group]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if groupsList.count == 0 {
      self.tableView.separatorStyle = .none
    } else {
      self.tableView.separatorStyle = .singleLine
    }
    return groupsList.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "addGroupCell", for: indexPath) as? AddGroupCell else {
      return UITableViewCell()
    }
    cell.configure(groupsList[indexPath.row], cell: cell, indexPath: indexPath, tableView: tableView)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    DataService.instance.subscribeUserToGroup(groupsList[indexPath.row])
  }
  
}

extension AddGroupController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    // If text did change but there is still something to search for - execute search
    if searchText != "" {
      APIService.instance.searchGroupsByName(searchName: searchText) { [weak self] groupsList in
        self?.groupsList = groupsList
        DispatchQueue.main.async {
          self?.tableView.reloadData()
        }
      }
    } else {
      self.groupsList.removeAll()
      self.tableView.reloadData()
    }
  }
  
}
