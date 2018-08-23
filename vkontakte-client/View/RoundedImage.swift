//
//  RoundedImage.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 26.06.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class RoundedImage: UIImageView {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.clipsToBounds = true
    self.layer.cornerRadius = 25
  }
  
}
