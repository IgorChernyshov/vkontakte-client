//
//  SetFriendsProfileImageToRow.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 25.07.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class SetImageToRow<T>: Operation {
  
  private let indexPath: IndexPath
  private weak var tableView: UITableView?
  private var cell: T?
  
  init(cell: T, indexPath: IndexPath, tableView: UITableView) {
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
    switch T.self {
    case is MyFriendsCell.Type:
      guard let cell = cell as? MyFriendsCell else { return }
      setFriendsProfile(image: image, cell: cell, tableView: tableView)
    default:
      return
    }
  }
  
  private func setFriendsProfile(image: UIImage, cell: MyFriendsCell, tableView: UITableView) {
    if let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath {
      cell.profilePhotoImage.image = image
    }
  }
  
}
