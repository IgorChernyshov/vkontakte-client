//
//  SetFriendsProfileImageToRow.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 25.07.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class SetFriendsProfileImageToRow: Operation {
  
  private let indexPath: IndexPath
  private weak var tableView: UITableView?
  private var cell: MyFriendsCell?
  
  init(cell: MyFriendsCell, indexPath: IndexPath, tableView: UITableView) {
    self.indexPath = indexPath
    self.tableView = tableView
    self.cell = cell
  }
  
  override func main() {
    guard let tableView = tableView,
      let cell = cell,
      let getCachedImage = dependencies[0] as? GetCachedImage,
      let image = getCachedImage.outputImage else {
        return
    }
    if let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath {
      cell.profilePhotoImage.image = image
    } else if tableView.indexPath(for: cell) == nil {
      cell.profilePhotoImage.image = image
    }
  }
  
}
