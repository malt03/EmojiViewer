//
//  EmojiViewController
//  EmojiViewer
//
//  Created by Koji Murata on 2016/02/05.
//  Copyright © 2016年 Koji Murata. All rights reserved.
//

import UIKit

class EmojiViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  var emojiSelectedHandler: ((emoji: String) -> Void)?
  
  private let emojiCollectionViewColNum = 5
  private let sectionMargin = CGFloat(20)
  private var forceScroll = false
  private var emojiSectionSelectCollectionViewController: EmojiSectionSelectCollectionViewController!
  
  @IBOutlet weak var emojiCollectionView: UICollectionView!

  private let labels = Emoji.categories.map { (category) -> UILabel in
    let label = UILabel()
    label.text = category
    return label
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    for l in labels {
      view.addSubview(l)
      l.hidden = true
      l.frame.origin = .zero
      l.sizeToFit()
    }
    labels[0].hidden = false
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return Emoji.emojis.count
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return Emoji.emojis[section].count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("default", forIndexPath: indexPath) as! EmojiCollectionViewCell
    cell.emojiLabel.text = Emoji.emojis[indexPath.section][indexPath.row]
    return cell
  }

  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return cellSize
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return CGSize(width: sectionMargin, height: collectionView.frame.height)
  }
  
  func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    let footer = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "default", forIndexPath: indexPath)
    footer.tag = indexPath.section + 10000
    return footer
  }
  
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    emojiSelectedHandler?(emoji: Emoji.emojis[indexPath.section][indexPath.row])
  }
  
  func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
    forceScroll = false
  }
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    var currentSection = -1
    if let s = emojiCollectionView.indexPathForItemAtPoint(scrollView.contentOffset)?.section {
      currentSection = s
    } else if let s = scrollView.hitTest(scrollView.contentOffset, withEvent: nil)?.tag {
      currentSection = s - 10000
    }
    
    if currentSection < 0 { return }
    
    if !forceScroll {
      emojiSectionSelectCollectionViewController.setSection(currentSection, scroll: false)
    }
    
    for (i, l) in labels.enumerate() { l.hidden = (i != currentSection) }

    labels[currentSection].frame.origin.x = 0
    if let currentSectionLastCell = emojiCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: Emoji.emojis[currentSection].count - 1, inSection: currentSection)) {
      let sectionLastX = currentSectionLastCell.convertPoint(CGPoint(x: cellSize.width - 1, y: 0), toView: view).x
      let currentLabelWidth = labels[currentSection].frame.width
      if currentLabelWidth > sectionLastX {
        labels[currentSection].frame.origin.x = sectionLastX - currentLabelWidth
      }
    }

    for i in (currentSection+1)..<Emoji.emojis.count {
      if let nextSectionTopCell = emojiCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: 0, inSection: i)) {
        labels[i].hidden = false
        let nextSectionTopX = nextSectionTopCell.convertPoint(.zero, toView: view).x
        labels[i].frame.origin.x = nextSectionTopX
        if nextSectionTopX < sectionMargin + 2 {
          labels[currentSection].hidden = true
        }
      }
    }
  }
  
  private var cellSize: CGSize {
    let size = emojiCollectionView.frame.height / CGFloat(emojiCollectionViewColNum)
    return CGSize(width: size, height: size)
  }
  
  func setSection(section: Int) {
    forceScroll = true
    emojiCollectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: section), atScrollPosition: .Left, animated: true)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let vc = segue.destinationViewController as? EmojiSectionSelectCollectionViewController {
      emojiSectionSelectCollectionViewController = vc
      emojiSectionSelectCollectionViewController.emojiViewController = self
    }
  }
}