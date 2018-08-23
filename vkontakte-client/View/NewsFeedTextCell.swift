//
//  FeedTextNewsCell.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 13.07.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class NewsFeedTextCell: UITableViewCell {
  
  @IBOutlet weak var ownerPhoto: RoundedImage!
  @IBOutlet weak var ownerName: UILabel!
  @IBOutlet weak var newsTextLabel: UILabel!
  @IBOutlet weak var likesButton: UIButton!
  @IBOutlet weak var commentsButton: UIButton!
  @IBOutlet weak var repostsButton: UIButton!
  @IBOutlet weak var viewsLabel: UILabel!
  var post_id: Int!
  var owner_id: Int!
  
  private let queue: OperationQueue = {
    let queue = OperationQueue()
    queue.qualityOfService = .userInteractive
    return queue
  }()
  
  func configure(_ news: News, cell: NewsFeedTextCell, indexPath: IndexPath, tableView: UITableView) {
    let getCachedImage = GetCachedImage(url: news.ownerPhoto)
    let setNewsFeedTextCellImagesToRow = SetNewsFeedTextCellImagesToRow(cell: cell, indexPath: indexPath, tableView: tableView)
    setNewsFeedTextCellImagesToRow.addDependency(getCachedImage)
    queue.addOperation(getCachedImage)
    OperationQueue.main.addOperation(setNewsFeedTextCellImagesToRow)
    
    ownerName.text = news.ownerName
    newsTextLabel.text = news.text
    likesButton.setTitle(" \(news.likesCount)", for: .normal)
    if news.userLikes == 1 {
      likesButton.setImage(#imageLiteral(resourceName: "likeIconSelected"), for: .normal)
      likesButton.setTitleColor(#colorLiteral(red: 0.9215686275, green: 0.2823529412, blue: 0.3058823529, alpha: 1), for: .normal)
    }
    commentsButton.setTitle(" \(news.commentsCount)", for: .normal)
    repostsButton.setTitle(" \(news.repostsCount)", for: .normal)
    viewsLabel.text = String(news.views)
    post_id = news.postId
    owner_id = news.sourceId
  }
  
  @IBAction func likeButtonWasPressed(_ sender: Any) {
    if likesButton.titleColor(for: .normal) == #colorLiteral(red: 0.9215686275, green: 0.2823529412, blue: 0.3058823529, alpha: 1) {
      NewsFeedService.instance.changeNumberOfLikes(post_id, ownerId: owner_id, action: "delete")
      likesButton.setImage(#imageLiteral(resourceName: "likeIconNotSelected"), for: .normal)
      likesButton.setTitleColor(#colorLiteral(red: 0.7161806226, green: 0.7311164737, blue: 0.7643541098, alpha: 1), for: .normal)
    } else {
      NewsFeedService.instance.changeNumberOfLikes(post_id, ownerId: owner_id, action: "add")
      likesButton.setImage(#imageLiteral(resourceName: "likeIconSelected"), for: .normal)
      likesButton.setTitleColor(#colorLiteral(red: 0.9215686275, green: 0.2823529412, blue: 0.3058823529, alpha: 1), for: .normal)
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    ownerPhoto.image = UIImage(named: "usersProfilePhotoPlaceholder")
    ownerName.text = ""
    newsTextLabel.text = ""
    likesButton.setImage(#imageLiteral(resourceName: "likeIconNotSelected"), for: .normal)
    likesButton.setTitleColor(#colorLiteral(red: 0.7161806226, green: 0.7311164737, blue: 0.7643541098, alpha: 1), for: .normal)
    likesButton.setTitle("", for: .normal)
    commentsButton.setTitle("", for: .normal)
    repostsButton.setTitle("", for: .normal)
    viewsLabel.text = ""
  }
  
}
