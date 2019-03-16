//
//  NewsFeedTextAndPhotoCell.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 18.07.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class NewsFeedTextAndPhotoCell: UITableViewCell {
  
  @IBOutlet weak var ownerPhoto: RoundedImage!
  @IBOutlet weak var ownerName: UILabel!
  @IBOutlet weak var newsTextLabel: UILabel!
  @IBOutlet weak var attachedPhotoImage: UIImageView!
  @IBOutlet weak var likesButton: UIButton!
  @IBOutlet weak var commentsButton: UIButton!
  @IBOutlet weak var repostsButton: UIButton!
  @IBOutlet weak var viewsLabel: UILabel!
  @IBOutlet weak var attachedImageWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var attachedImageHeightConstraint: NSLayoutConstraint!
  private var post_id: Int!
  private var owner_id: Int!
  
  private let queue: OperationQueue = {
    let queue = OperationQueue()
    queue.qualityOfService = .userInteractive
    return queue
  }()
  
  func configure(_ news: News, cell: NewsFeedTextAndPhotoCell, indexPath: IndexPath, tableView: UITableView) {
    
    // Get owner's photo
    let getCachedProfileImage = GetCachedImage(url: news.ownerPhoto)
    let setNewsFeedTextAndPhotoCellOwnerProfile = SetImageToRow(
      cell: cell,
      contentType: "NewsFeedTextAndPhotoCellOwner",
      indexPath: indexPath,
      tableView: tableView
    )
    setNewsFeedTextAndPhotoCellOwnerProfile.addDependency(getCachedProfileImage)
    queue.addOperation(getCachedProfileImage)
    OperationQueue.main.addOperation(setNewsFeedTextAndPhotoCellOwnerProfile)
    
    // Get attached photo
    let getCachedAttachedImage = GetCachedImage(url: news.imageURL)
    let setNewsFeedTextAndPhotoCellAttachedPhoto = SetImageToRow(
      cell: cell,
      contentType: "NewsFeedTextAndPhotoAttachment",
      indexPath: indexPath,
      tableView: tableView
    )
    setNewsFeedTextAndPhotoCellAttachedPhoto.addDependency(getCachedAttachedImage)
    queue.addOperation(getCachedAttachedImage)
    OperationQueue.main.addOperation(setNewsFeedTextAndPhotoCellAttachedPhoto)
    
    // Fit attached photo into cell based on a screen size
    let screenSize = UIScreen.main.bounds
    attachedImageWidthConstraint.constant = screenSize.width - 30
    let aspectRatio = attachedImageWidthConstraint.constant / CGFloat(news.imageWidth)
    attachedImageHeightConstraint.constant = CGFloat(news.imageHeight) * aspectRatio
    
    // Set the rest of elements in a cell
    ownerName.text = news.ownerName
    newsTextLabel.text = news.text
    likesButton.setTitle(" \(news.likesCount)", for: .normal)
    if news.userLikes == 1 {
      likesButton.setImage(#imageLiteral(resourceName: "likeIconSelected"), for: .normal)
      likesButton.setTitleColor(UIColor.likedIconColor, for: .normal)
    }
    commentsButton.setTitle(" \(news.commentsCount)", for: .normal)
    repostsButton.setTitle(" \(news.repostsCount)", for: .normal)
    viewsLabel.text = String(news.views)
    post_id = news.postId
    owner_id = news.sourceId
  }
  
  @IBAction func likeButtonWasPressed(_ sender: Any) {
    if likesButton.titleColor(for: .normal) == UIColor.likedIconColor {
      NewsFeedService.instance.changeNumberOfLikes(post_id, ownerId: owner_id, action: "delete")
      likesButton.setImage(#imageLiteral(resourceName: "likeIconNotSelected"), for: .normal)
      likesButton.setTitleColor(UIColor.notLikedIconColor, for: .normal)
    } else {
      NewsFeedService.instance.changeNumberOfLikes(post_id, ownerId: owner_id, action: "add")
      likesButton.setImage(#imageLiteral(resourceName: "likeIconSelected"), for: .normal)
      likesButton.setTitleColor(UIColor.likedIconColor, for: .normal)
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    ownerPhoto.image = UIImage(named: "usersProfilePhotoPlaceholder")
    attachedPhotoImage.image = UIImage(named: "usersPhotoPlaceholder")
    ownerName.text = ""
    newsTextLabel.text = ""
    likesButton.setImage(#imageLiteral(resourceName: "likeIconNotSelected"), for: .normal)
    likesButton.setTitleColor(UIColor.notLikedIconColor, for: .normal)
    likesButton.setTitle("", for: .normal)
    commentsButton.setTitle("", for: .normal)
    repostsButton.setTitle("", for: .normal)
    viewsLabel.text = ""
  }
  
}
