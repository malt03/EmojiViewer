//
//  EmojiCollectionViewCell.swift
//  EmojiViewer
//
//  Created by Koji Murata on 2016/02/05.
//  Copyright © 2016年 Koji Murata. All rights reserved.
//

import UIKit

class EmojiCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var emojiLabel: UILabel!
  
  override func drawRect(rect: CGRect) {
    super.drawRect(rect)
    emojiLabel.font = UIFont.systemFontOfSize(min(rect.height, rect.width) * 0.8)
  }
}
