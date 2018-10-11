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
  private let contentType: String?
  
  init(cell: T, contentType: String, indexPath: IndexPath, tableView: UITableView) {
    self.indexPath = indexPath
    self.tableView = tableView
    self.cell = cell
    self.contentType = contentType
  }
  
  override func main() {
    guard let tableView = tableView,
      let cell = cell,
      let getCachedImage = dependencies[0] as? GetCachedImage,
      let image = getCachedImage.outputImage else {
        return
    }
    // Check what type of cell requests the image
    switch self.contentType {
    case "MyFriendsCell":
      guard let cell = cell as? MyFriendsCell else { return }
      setFriendsProfileImage(image: image, cell: cell, tableView: tableView)
    case "MyGroupsCell":
      guard let cell = cell as? MyGroupsCell else { return }
      setGroupsProfileImage(image: image, cell: cell, tableView: tableView)
    case "AddGroupCell":
      guard let cell = cell as? AddGroupCell else { return }
      setAddGroupsProfileImage(image: image, cell: cell, tableView: tableView)
    case "NewsFeedTextCell":
      guard let cell = cell as? NewsFeedTextCell else { return }
      setNewsFeedTextCellImage(image: image, cell: cell, tableView: tableView)
    case "ConversationCell":
      guard let cell = cell as? ConversationCell else { return }
      setConversationOwnerPhotoImage(image: image, cell: cell, tableView: tableView)
    case "NewsFeedTextAndPhotoCellOwner":
      guard let cell = cell as? NewsFeedTextAndPhotoCell else { return }
      setNewsFeedTextAndImageOwnerImage(image: image, cell: cell, tableView: tableView)
    case "NewsFeedTextAndPhotoAttachment":
      guard let cell = cell as? NewsFeedTextAndPhotoCell else { return }
      setNewsFeedTextAndImageAttachmentImage(image: image, cell: cell, tableView: tableView)
    default:
      return
    }
  }
  
  private func setFriendsProfileImage(image: UIImage, cell: MyFriendsCell, tableView: UITableView) {
    if let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath {
      cell.profilePhotoImage.image = image
    }
  }
  
  private func setGroupsProfileImage(image: UIImage, cell: MyGroupsCell, tableView: UITableView) {
    if let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath {
      cell.groupProfileImage.image = image
    }
  }
  
  private func setAddGroupsProfileImage(image: UIImage, cell: AddGroupCell, tableView: UITableView) {
    if let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath {
      cell.groupProfileImage.image = image
    }
  }
  
  private func setNewsFeedTextCellImage(image: UIImage, cell: NewsFeedTextCell, tableView: UITableView) {
    if let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath {
      cell.ownerPhoto.image = image
    }
  }
  
  private func setConversationOwnerPhotoImage(image: UIImage, cell: ConversationCell, tableView: UITableView) {
    if let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath {
      cell.profilePhotoImage.image = image
    }
  }
  
  private func setNewsFeedTextAndImageOwnerImage(image: UIImage, cell: NewsFeedTextAndPhotoCell, tableView: UITableView) {
    if let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath {
      cell.ownerPhoto.image = image
    }
  }
  
  private func setNewsFeedTextAndImageAttachmentImage(image: UIImage, cell: NewsFeedTextAndPhotoCell, tableView: UITableView) {
    if let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath {
      cell.attachedPhotoImage.image = image
    }
  }
}
