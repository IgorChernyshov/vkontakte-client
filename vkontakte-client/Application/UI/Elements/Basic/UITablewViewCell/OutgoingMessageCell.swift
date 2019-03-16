//
//  OutgoingMessageCell.swift
//  igor-chernyshov
//
//  Created by Igor Chernyshov on 19.08.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit

class OutgoingMessageCell: UITableViewCell {

  @IBOutlet weak var messageLabel: MessageLabel!
  
  func configure(_ message: RealmMessage) {
    messageLabel.text = message.text
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    messageLabel.text = ""
  }

}
