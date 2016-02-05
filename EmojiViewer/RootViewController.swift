//
//  RootViewController.swift
//  EmojiViewer
//
//  Created by Koji Murata on 2016/02/05.
//  Copyright © 2016年 Koji Murata. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
  
  private var hidden = true

  @IBAction func toggle() {
    hidden = !hidden
    self.containerViewBottomConstraint.constant = hidden ? -200 : 0
    if !hidden { self.containerView.hidden = false }
    UIView.animateWithDuration(0.24, animations: {
      self.view.layoutIfNeeded()
    }, completion: { _ in
      if self.hidden { self.containerView.hidden = true }
    })

    UIView.animateWithDuration(0.24) {
      self.view.layoutIfNeeded()
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let vc = segue.destinationViewController as? EmojiViewController {
      vc.emojiSelectedHandler = { (emoji) in
        self.textField.text = (self.textField.text ?? "") + emoji
      }
    }
  }
}