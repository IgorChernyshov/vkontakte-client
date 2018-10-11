//
//  ConversationCell.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 04.08.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {

  @IBOutlet weak var profilePhotoImage: RoundedImage!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var lastMessageLabel: UILabel!
  @IBOutlet weak var unreadBadgeView: UIView!
  @IBOutlet weak var unreadBadgeLabel: UILabel!
  
  private let queue: OperationQueue = {
    let queue = OperationQueue()
    queue.qualityOfService = .userInteractive
    return queue
  }()
  
  func configure(_ conversation: Conversation, cell: ConversationCell, indexPath: IndexPath, tableView: UITableView) {
    let getCachedImage = GetCachedImage(url: conversation.ownerPhoto)
    let setConversationProfileImageToRow = SetImageToRow(cell: cell, contentType: "ConversationCell", indexPath: indexPath, tableView: tableView)
    setConversationProfileImageToRow.addDependency(getCachedImage)
    queue.addOperation(getCachedImage)
    OperationQueue.main.addOperation(setConversationProfileImageToRow)
    
    userNameLabel.text = conversation.ownerName
    lastMessageLabel.text = conversation.text
    if conversation.unreadCount > 0 {
      unreadBadgeLabel.text = String(conversation.unreadCount)
      unreadBadgeView.isHidden = false
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    profilePhotoImage.image = UIImage(named: "usersPhotoPlaceholder")
    userNameLabel.text = ""
    lastMessageLabel.text = ""
    unreadBadgeView.isHidden = true
  }
  
}
