//
//  MyFriendsCell.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 12.06.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class MyFriendsCell: UITableViewCell {
  
  @IBOutlet weak var profilePhotoImage: RoundedImage! {
    didSet {
      profilePhotoImage.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  
  @IBOutlet weak var userNameLabel: UILabel! {
    didSet {
      userNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  
  let insets: CGFloat = 16.0
  
  private let queue: OperationQueue = {
    let queue = OperationQueue()
    queue.qualityOfService = .userInteractive
    return queue
  }()
  
  func getLabelSize(text: String, font: UIFont) -> CGSize {
    let maxWidth = bounds.width - insets * 2
    let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
    let rect = text.boundingRect(with: textBlock, options:
      .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font],
                               context: nil)
    let width = Double(rect.size.width)
    let height = Double(rect.size.height)
    let size = CGSize(width: ceil(width), height: ceil(height))
    return size
  }
  
  func userNameLabelFrame() {
    let userNameLabelSize = getLabelSize(text: userNameLabel.text!, font: userNameLabel.font)
    let userNameLabelOrigin = CGPoint(x: bounds.minX + (insets * 2) + 50, y: bounds.midY - userNameLabelSize.height / 2)
    userNameLabel.frame = CGRect(origin: userNameLabelOrigin, size: userNameLabelSize)
  }
  
  func profilePhotoImageFrame() {
    let profilePhotoImageLength: CGFloat = 50
    let profilePhotoImageSize = CGSize(width: profilePhotoImageLength, height: profilePhotoImageLength)
    let profilePhotoImageOrigin = CGPoint(x: bounds.minX + insets, y: bounds.midY - profilePhotoImageLength / 2)
    profilePhotoImage.frame = CGRect(origin: profilePhotoImageOrigin, size: profilePhotoImageSize)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    userNameLabelFrame()
    profilePhotoImageFrame()
  }
  
  func setUserNameLabel(text: String) {
    userNameLabel.text = text
    userNameLabelFrame()
  }
  
  func configure(_ user: User, cell: MyFriendsCell, indexPath: IndexPath, tableView: UITableView) {
    cell.setUserNameLabel(text: "\(user.firstName) \(user.lastName)")
    let getCachedImage = GetCachedImage(url: user.imageUrl)
    let setFriendsProfileImageToRow = SetFriendsProfileImageToRow(cell: cell, indexPath: indexPath, tableView: tableView)
    setFriendsProfileImageToRow.addDependency(getCachedImage)
    queue.addOperation(getCachedImage)
    OperationQueue.main.addOperation(setFriendsProfileImageToRow)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    profilePhotoImage.image = UIImage(named: "usersProfilePhotoPlaceholder")
  }
  
}
