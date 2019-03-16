//
//  MyFriendsPhotosController.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 19.06.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit
import RealmSwift

class MyFriendsPhotosController: UICollectionViewController {
  
  var userId = ""
  private var photos: List<Photo>!
  private var token: NotificationToken?
  
  private let refreshControl = UIRefreshControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addRefreshControl()
    APIService.instance.requestUsersProfilePhotos(userId: userId)
    pairCollectionViewAndRealm()
    calculatePhotosSize()
  }
  
  private func addRefreshControl() {
    collectionView?.addSubview(refreshControl)
    refreshControl.tintColor = UIColor.activityIndicatorColor
    refreshControl.addTarget(self, action: #selector(refreshUsersPhotos(_:)), for: .valueChanged)
  }
  
  @objc private func refreshUsersPhotos(_ sender: Any) {
    self.refreshControl.endRefreshing()
    APIService.instance.requestUsersProfilePhotos(userId: userId)
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
  
  private func pairCollectionViewAndRealm() {
    guard let realm = try? Realm(), let user = realm.object(ofType: User.self, forPrimaryKey: Int(userId)) else {
      return
    }
    photos = user.photos
    token = photos.observe { [weak self] (changes: RealmCollectionChange) in
      guard let collectionView = self?.collectionView else {
        return
      }
      switch changes {
      case .initial:
        collectionView.reloadData()
      case .update:
        collectionView.reloadData()
      case .error(let error):
        print(error.localizedDescription)
      }
    }
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