//
//  MessageLabel.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 18.08.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class MessageLabel: UILabel {

  override func awakeFromNib() {
    super.awakeFromNib()
    self.clipsToBounds = true
    self.layer.cornerRadius = 15
  }
  
  let padding = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
  override func drawText(in rect: CGRect) {
    super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
  }
  
  override var intrinsicContentSize : CGSize {
    let superContentSize = super.intrinsicContentSize
    let width = superContentSize.width + padding.left + padding.right
    let heigth = superContentSize.height + padding.top + padding.bottom
    return CGSize(width: width, height: heigth)
  }
  
}
