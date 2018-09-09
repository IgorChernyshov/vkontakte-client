//
//  NewsFeedViewController.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 12.07.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit
import RealmSwift

class NewsFeedViewController: UITableViewController {
  
  private var news: Results<News>!
  private var token: NotificationToken?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.estimatedRowHeight = 300; // Fixes bug when table view jumps up on tableView.reloadData() call
    NewsFeedService.instance.requestUsersNewsFeed()
    pairTableAndRealm()
  }
  
  private func pairTableAndRealm() {
    guard let realm = try? Realm() else {
      return
    }
    news = realm.objects(News.self)
    token = news?.observe({ [weak self] (changes: RealmCollectionChange) in
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
    if news.count == 0 {
      tableView.separatorStyle = .none
    } else {
      tableView.separatorStyle = .singleLine
    }
    return news.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if news[indexPath.row].imageURL.isEmpty {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsFeedTextCell") as? NewsFeedTextCell else { return UITableViewCell() }
      cell.configure(news[indexPath.row], cell: cell, indexPath: indexPath, tableView: tableView)
      return cell
    } else {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsFeedTextAndPhotoCell") as? NewsFeedTextAndPhotoCell else { return UITableViewCell() }
      cell.configure(news[indexPath.row], cell: cell, indexPath: indexPath, tableView: tableView)
      return cell
    }
  }
  
}
