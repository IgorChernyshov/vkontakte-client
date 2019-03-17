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
  private var isClosed: Bool!
  
  private let queue: OperationQueue = {
    let queue = OperationQueue()
    queue.qualityOfService = .userInteractive
    return queue
  }()
  
  func configure(_ group: RealmGroup, cell: AddGroupCell, indexPath: IndexPath, tableView: UITableView) {
    groupNameLabel.text = group.name
    numberOfSubscribersLabel.text = "Участников: \(group.membersCount)"
    id = group.id
    isMember = group.isMember
    isClosed = group.isClosed
    if isClosed {
      joinGroupButton.isHidden = true
    }
    
    let getCachedImage = GetCachedImage(url: group.imageUrl)
    let setGroupsProfileImageToRow = SetImageToRow(cell: cell, contentType: "AddGroupCell", indexPath: indexPath, tableView: tableView)
    setGroupsProfileImageToRow.addDependency(getCachedImage)
    queue.addOperation(getCachedImage)
    OperationQueue.main.addOperation(setGroupsProfileImageToRow)
  }
  
  @IBAction func joinGroupButtonWasPressed(_ sender: Any) {
    if !isMember {
      APIService.instance.joinGroup(id: id)
      NotificationCenter.default.post(name: NSNotification.Name("userHasJoinedGroup"), object: nil)
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    groupProfileImage.image = UIImage(named: "groupProfilePhotoPlaceholder")
    joinGroupButton.isHidden = false
  }
  
}
