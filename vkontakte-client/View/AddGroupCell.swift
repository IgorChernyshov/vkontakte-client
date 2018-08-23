//
//  AddGroupCell.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 12.06.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class AddGroupCell: UITableViewCell {

  @IBOutlet weak var groupProfileImage: UIImageView!
  @IBOutlet weak var groupNameLabel: UILabel!
  @IBOutlet weak var numberOfSubscribersLabel: UILabel!
  
  private let queue: OperationQueue = {
    let queue = OperationQueue()
    queue.qualityOfService = .userInteractive
    return queue
  }()
  
  func configure(_ group: Group, cell: AddGroupCell, indexPath: IndexPath, tableView: UITableView) {
    groupNameLabel.text = group.name
    numberOfSubscribersLabel.text = "Участников: \(group.membersCount)"
    let getCachedImage = GetCachedImage(url: group.imageUrl)
    let setGroupsProfileImageToRow = SetAddGroupsProfileImageToRow(cell: cell, indexPath: indexPath, tableView: tableView)
    setGroupsProfileImageToRow.addDependency(getCachedImage)
    queue.addOperation(getCachedImage)
    OperationQueue.main.addOperation(setGroupsProfileImageToRow)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    groupProfileImage.image = UIImage(named: "groupProfilePhotoPlaceholder")
  }
  
}
