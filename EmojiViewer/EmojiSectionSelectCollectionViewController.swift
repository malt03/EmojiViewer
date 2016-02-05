//
//  EmojiSectionSelectCollectionViewController.swift
//  EmojiViewer
//
//  Created by Koji Murata on 2016/02/05.
//  Copyright © 2016年 Koji Murata. All rights reserved.
//

import UIKit

class EmojiSectionSelectCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  var emojiViewController: EmojiViewController!
  
  private let selectionView = UIView()
  private var currentSection = 0

  @IBOutlet weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    selectionView.backgroundColor = .lightGrayColor()
    view.addSubview(selectionView)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    selectionView.frame = CGRect(origin: .zero, size: cellSize)
    selectionView.layer.cornerRadius = cellSize.height / 2
    view.sendSubviewToBack(selectionView)
  }
  
  func setSection(section: Int, scroll: Bool) {
    if currentSection == section { return }
    if scroll { emojiViewController.setSection(section) }
    currentSection = section
    let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forRow: section, inSection: 0))!
    let point = cell.convertPoint(.zero, toView: collectionView)
    UIView.animateWithDuration(0.24) {
      self.selectionView.frame.origin = point
    }
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return Emoji.emojis.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("default", forIndexPath: indexPath) as! EmojiCollectionViewCell
    cell.emojiLabel.text = Emoji.emojis[indexPath.row][0]
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return cellSize
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    setSection(indexPath.row, scroll: true)
  }
  
  private var cellSize: CGSize {
    return CGSize(width: collectionView.frame.width / CGFloat(Emoji.emojis.count), height: collectionView.frame.height)
  }
}