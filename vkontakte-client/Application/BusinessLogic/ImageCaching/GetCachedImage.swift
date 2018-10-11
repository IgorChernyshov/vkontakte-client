//
//  GetCachedImage.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 25.07.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class GetCachedImage: Operation {
  
  private let cacheLifeTime: TimeInterval = 3600
  
  private static let pathName: String = {
    let pathName = "Images"
    guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
      return pathName
    }
    let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
    if !FileManager.default.fileExists(atPath: url.path) {
      try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }
    return pathName
  }()
  
  private lazy var filePath: String? = {
    guard let cachesDirectory = FileManager.default.urls(for:
      .cachesDirectory, in: .userDomainMask).first else {
        return nil
    }
    let hashName = String(describing: url.hashValue)
    return cachesDirectory.appendingPathComponent(GetCachedImage.pathName + "/" + hashName).path
  }()
  
  private let url: String
  var outputImage: UIImage?
  
  init(url: String) {
    self.url = url
  }
  
  override func main() {
    guard filePath != nil && !isCancelled else {
      return
    }
    if getImageFromCache() { return }
    guard !isCancelled else {
      return
    }
    if !downloadImage() {
      return
    }
    guard !isCancelled else {
      return
    }
    saveImageToCache()
  }
  
  private func getImageFromCache() -> Bool {
    guard let fileName = filePath, let info = try? FileManager.default.attributesOfItem(atPath: fileName),
      let modificationDate = info[FileAttributeKey.modificationDate] as? Date else {
        return false
    }
    let lifeTime = Date().timeIntervalSince(modificationDate)
    guard lifeTime <= cacheLifeTime, let image = UIImage(contentsOfFile: fileName) else {
      return false
    }
    self.outputImage = image
    return true
  }
  
  private func downloadImage() -> Bool {
    guard let url = URL(string: url), let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
      return false
    }
    self.outputImage = image
    return true
  }
  
  private func saveImageToCache() {
    guard let fileName = filePath, let image = outputImage else {
      return
    }
    let data = UIImagePNGRepresentation(image)
    FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
  }
  
}
