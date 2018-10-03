//
//  MyGroupsCell.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 12.06.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class MyGroupsCell: UITableViewCell {
  
  @IBOutlet weak var groupProfileImage: RoundedImage!
  @IBOutlet weak var groupNameLabel: UILabel!
  
  private let queue: OperationQueue = {
    let queue = OperationQueue()
    queue.qualityOfService = .userInteractive
    return queue
  }()
  
  func configure(_ group: Group, cell: MyGroupsCell, indexPath: IndexPath, tableView: UITableView) {
    groupNameLabel.text = group.name
    let getCachedImage = GetCachedImage(url: group.imageUrl)
    let setGroupsProfileImageToRow = SetImageToRow(cell: cell, indexPath: indexPath, tableView: tableView)
    setGroupsProfileImageToRow.addDependency(getCachedImage)
    queue.addOperation(getCachedImage)
    OperationQueue.main.addOperation(setGroupsProfileImageToRow)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    groupProfileImage.image = UIImage(named: "groupProfilePhotoPlaceholder")
    groupNameLabel.text = ""
  }
  
}
