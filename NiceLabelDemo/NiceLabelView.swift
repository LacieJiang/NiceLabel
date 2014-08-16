//
//  NiceLabelView.swift
//  NiceLabelDemo
//
//  Created by Jiang Liyin on 14-8-16.
//  Copyright (c) 2014年 Jiang Liyin. All rights reserved.
//

import UIKit

class NiceLabelView: UIView, NiceLabelOperationDelegate {
  @IBOutlet weak var imageView: NiceLabelImageView!

  var niceContent: NiceContent? {
    didSet {
      if self.niceContent != nil {
        imageView.image = UIImage(contentsOfFile: self.niceContent!.imagePath)
      }
        removeAllLabels()
    }
  }
  var isForCreate: Bool = true

  @IBAction func handleTapGesture(tap: UITapGestureRecognizer!) {
    if isForCreate {
      // Insert label
      let point = tap.locationInView(self)
      let model = NiceLabelModel()
      model.content = "Nice\(niceContent!.labels.count)"

      // TODO: PIC_X ,PIC_Y
      model.pic_x = NSInteger(imageView.image.size.width * (point.x/tap.view.frame.size.width))
      model.pic_y = NSInteger(imageView.image.size.height * (point.y/tap.view.frame.size.height))
      niceContent!.labels.append(model)
      let label = NiceLabel(frame: CGRectMake(point.x, point.y, 50, 26), content: model.content)
      label.tag = 100 + niceContent!.labels.count
      label.delegate = self
      self.addSubview(label)
    } else {
      removeAllLabels()
      // show all labels
      let image = UIImage(contentsOfFile: niceContent!.imagePath)
      for item in niceContent!.labels {
        let model = item as NiceLabelModel
        let point: CGPoint = CGPoint(x: tap.view.frame.size.width * CGFloat(model.pic_x)/CGFloat(image.size.width), y: tap.view.frame.size.height * CGFloat(model.pic_y)/CGFloat(image.size.height))
        let label = NiceLabel(frame: CGRectMake(point.x, point.y, 50, 26), content: model.content)
        label.tag = 100 + niceContent!.labels.count
        label.delegate = self
        self.addSubview(label)
      }
    }
  }

  func selectTheLabel(label: NiceLabel!) {
    if isForCreate {
      // Delete label
      niceContent!.labels.removeAtIndex(label.tag - 100 - 1)
      label.stopAllAnimation()
      label.removeFromSuperview()
    } else {

    }
  }

  func saveLabels() -> NiceContent {
    removeAllLabels()
    return niceContent!
  }

  func removeAllLabels() {
    for subview in self.subviews {
      if subview.isKindOfClass(NiceLabel.classForCoder()) {
        let label = subview as NiceLabel
        label.stopAllAnimation()
        label.removeFromSuperview()
      }
    }

  }
}
