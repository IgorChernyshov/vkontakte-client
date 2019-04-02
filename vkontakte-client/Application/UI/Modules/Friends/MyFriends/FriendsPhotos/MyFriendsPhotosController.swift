//
//  MyFriendsPhotosController.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 19.06.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class MyFriendsPhotosController: UICollectionViewController {
  
  var userId = ""
  private let myFriendsPhotosService = MyFriendsPhotosAdapter()
  private var photos: [Photo] = []
  
  private let refreshControl = UIRefreshControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addRefreshControl()
    
    myFriendsPhotosService.getPhotos(of: userId) { [weak self] photos in
      self?.photos = photos
      self?.collectionView?.reloadData()
    }
    calculatePhotosSize()
  }
  
  private func addRefreshControl() {
    collectionView?.addSubview(refreshControl)
    refreshControl.tintColor = UIColor.activityIndicatorColor
    refreshControl.addTarget(self, action: #selector(refreshUsersPhotos(_:)), for: .valueChanged)
  }
  
  @objc private func refreshUsersPhotos(_ sender: Any) {
    APIService.instance.requestUsersProfilePhotos(userId: userId)
    self.refreshControl.endRefreshing()
  }
  
  private func calculatePhotosSize() {
    // Set cells size automatically
    let flow = self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
    let itemSpacing: CGFloat = 3
    let itemsInOneLine: CGFloat = 2
    flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
    let width = UIScreen.main.bounds.size.width - itemSpacing * CGFloat(itemsInOneLine - 1)
    flow.itemSize = CGSize(width: floor(width/itemsInOneLine), height: width/itemsInOneLine)
    flow.minimumInteritemSpacing = 3
    flow.minimumLineSpacing = 3
  }
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    collectionView.backgroundView?.isHidden = (photos.count > 0)
    return photos.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myFriendsPhotos", for: indexPath) as? MyFriendsPhotosCell else {
      return UICollectionViewCell()
    }
    cell.configure(photos[indexPath.row], cell: cell, indexPath: indexPath, collectionView: collectionView)
    return cell
  }
  
}
