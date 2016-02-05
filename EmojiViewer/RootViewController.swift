//
//  RootViewController.swift
//  EmojiViewer
//
//  Created by Koji Murata on 2016/02/05.
//  Copyright © 2016年 Koji Murata. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let vc = segue.destinationViewController as? EmojiViewController {
      vc.emojiSelectedHandler = { (emoji) in
        print(emoji)
        self.dismissViewControllerAnimated(true, completion: nil)
      }
    }
  }
}