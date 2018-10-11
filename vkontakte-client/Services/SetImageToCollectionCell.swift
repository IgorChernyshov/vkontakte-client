//
//  SetFriendsPhotoToCollectionViewCell.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 31.07.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class SetImageToCollectionCell: Operation {
  
  private let indexPath: IndexPath
  private weak var collectionView: UICollectionView?
  private var cell: MyFriendsPhotosCell?
  
  init(cell: MyFriendsPhotosCell, indexPath: IndexPath, collectionView: UICollectionView) {
    self.indexPath = indexPath
    self.collectionView = collectionView
    self.cell = cell
  }
  
  override func main() {
    guard let collectionView = collectionView,
      let cell = cell,
      let getCachedImage = dependencies[0] as? GetCachedImage,
      let image = getCachedImage.outputImage else {
        return
    }
    if let newIndexPath = collectionView.indexPath(for: cell), newIndexPath == indexPath {
      cell.usersPhotoImage.image = image
    } else if collectionView.indexPath(for: cell) == nil {
      cell.usersPhotoImage.image = image
    }
  }
  
}
