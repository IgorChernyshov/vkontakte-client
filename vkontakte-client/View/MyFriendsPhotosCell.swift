//
//  MyFriendsPhotosCell.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 12.06.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class MyFriendsPhotosCell: UICollectionViewCell {

  @IBOutlet weak var usersPhotoImage: UIImageView!
  
  private let queue: OperationQueue = {
    let queue = OperationQueue()
    queue.qualityOfService = .userInteractive
    return queue
  }()
  
  func configure(_ photo: Photo, cell: MyFriendsPhotosCell, indexPath: IndexPath, collectionView: UICollectionView) {
    let getCachedImage = GetCachedImage(url: photo.imageUrl)
    let setFriendsPhotoToCollectionViewCell = SetFriendsPhotoToCollectionViewCell(cell: cell, indexPath: indexPath, collectionView: collectionView)
    setFriendsPhotoToCollectionViewCell.addDependency(getCachedImage)
    queue.addOperation(getCachedImage)
    OperationQueue.main.addOperation(setFriendsPhotoToCollectionViewCell)
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    usersPhotoImage.image = UIImage(named: "usersPhotoPlaceholder")
  }
  
}
