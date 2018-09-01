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
  @IBOutlet weak var joinGroupButton: UIButton!
  private var id: Int!
  private var isMember: Bool!
  
  private let queue: OperationQueue = {
    let queue = OperationQueue()
    queue.qualityOfService = .userInteractive
    return queue
  }()
  
  func configure(_ group: Group, cell: AddGroupCell, indexPath: IndexPath, tableView: UITableView) {
    groupNameLabel.text = group.name
    numberOfSubscribersLabel.text = "Участников: \(group.membersCount)"
    id = cell.id
    isMember = cell.isMember
    if isMember {
      joinGroupButton.setImage(#imageLiteral(resourceName: "groupWasJoined"), for: .normal)
    } else {
      joinGroupButton.setImage(#imageLiteral(resourceName: "addGroupButton"), for: .normal)
    }
    
    let getCachedImage = GetCachedImage(url: group.imageUrl)
    let setGroupsProfileImageToRow = SetAddGroupsProfileImageToRow(cell: cell, indexPath: indexPath, tableView: tableView)
    setGroupsProfileImageToRow.addDependency(getCachedImage)
    queue.addOperation(getCachedImage)
    OperationQueue.main.addOperation(setGroupsProfileImageToRow)
  }
  
  @IBAction func joinGroupButtonWasPressed(_ sender: Any) {
    if !isMember {
      APIService.instance.joinGroup(id: id)
      isMember = true
      joinGroupButton.setImage(#imageLiteral(resourceName: "groupWasJoined"), for: .normal)
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    groupProfileImage.image = UIImage(named: "groupProfilePhotoPlaceholder")
    joinGroupButton.setImage(#imageLiteral(resourceName: "addGroupButton"), for: .normal)
  }
  
}
