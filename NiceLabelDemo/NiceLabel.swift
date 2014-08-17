//
//  NiceLabel.swift
//  NiceLabelDemo
//
//  Created by Jiang Liyin on 14-8-16.
//  Copyright (c) 2014年 Jiang Liyin. All rights reserved.
//

import UIKit
import QuartzCore

@objc protocol NiceLabelOperationDelegate {
  func selectTheLabel(label: NiceLabel!)
}

class NiceLabel: UIView {

  var typeImg: UIImage?
  var labelContent: String? = "test"
  var delegate: NiceLabelOperationDelegate?

  private var multiHalo: MultiplePulsingHaloLayer?
  private var typeImageView: UIImageView?
  private var contentLabel: UILabel?
  private var contentLabelBkg: UIImageView?
  private var pointOnleft = true
  private var stop = false
  private var lastPosi: CGPoint?

  override init() {
    super.init()
    self.setupUI()
  }

  required init(coder aDecoder: NSCoder!) {
    super.init(coder: aDecoder)
    self.setupUI()
  }

  init(frame: CGRect, content: String! = "", typeImg: UIImage! = nil) {
    super.init(frame: frame)
    labelContent = content
    setupUI()
    var viewFrame = self.frame
    if pointOnleft {

      viewFrame.origin.x -= typeImageView!.frame.size.width/2
    }
    //    else {
    //      viewFrame.origin.x -= typeImageView!.frame.size.width/2
    //    }
    viewFrame.origin.y -= viewFrame.size.height/2
    self.frame = viewFrame
  }
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  private func setupUI() {
    var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    tapGesture.addTarget(self, action: Selector("handleTapGesture:"))
    self.addGestureRecognizer(tapGesture)
    var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer()
    panGesture.addTarget(self, action: Selector("handlePanGesture:"))
    self.addGestureRecognizer(panGesture)


    contentLabelBkg = UIImageView(image: UIImage(named: "KK_Filter_btn_black"))
    typeImg = UIImage(named: "KK_Brand_Tag_point_white")
    typeImageView = UIImageView(frame: CGRectMake(0, (self.frame.size.height - 15) / 2, 15, 15))
    typeImageView!.image = typeImg
    self.addSubview(typeImageView!)
    contentLabelBkg!.frame = CGRectMake(15, 0, self.frame.size.width, self.frame.size.height)
    contentLabel = UILabel(frame: CGRectMake(5, 0, contentLabelBkg!.frame.size.width, contentLabelBkg!.frame.size.height))
    contentLabel!.textColor = UIColor.whiteColor()
    contentLabel!.text = labelContent
    contentLabel!.textAlignment = NSTextAlignment.Center
    contentLabel!.font = UIFont.systemFontOfSize(12)
    contentLabelBkg!.addSubview(contentLabel!)
    self.addSubview(contentLabelBkg!)
    showAnimation()
  }

  func showAnimation(delay: Double = 0.0) {
    let anim = CABasicAnimation(keyPath: "transform.scale")
    anim.delegate = self
    anim.beginTime = CACurrentMediaTime() + CFTimeInterval(delay)
    anim.duration = 0.5
    anim.repeatCount = 1
    anim.fromValue = NSNumber(float: 0.8)
    anim.toValue = NSNumber(float: 1.2)
    typeImageView!.layer.addAnimation(anim, forKey: "scale-layer")
  }

  func showHalo() {
    multiHalo = MultiplePulsingHaloLayer(haloLayerNum: 2, andStartInterval: 0.5)
    multiHalo!.position = typeImageView!.center
    multiHalo!.useTimingFunction = false
    multiHalo!.buildSublayers()
    multiHalo!.haloLayerColor = UIColor.blackColor().CGColor
    multiHalo!.radius = 15
    multiHalo!.animationDuration = 2
    multiHalo!.animationRepeatCount = 1
    self.layer.insertSublayer(multiHalo, below: typeImageView!.layer)
  }

  func handleTapGesture(tap: UITapGestureRecognizer!) {
    if delegate != nil {
      delegate!.selectTheLabel(self)
    }
  }

  func handlePanGesture(pan: UIPanGestureRecognizer!) {
    let translatedPoint = pan.translationInView(self.superview)
    let x = pan.view.center.x + translatedPoint.x
    let y = pan.view.center.y + translatedPoint.y
    pan.view.center = CGPointMake(x, y)
    pan.setTranslation(CGPointZero, inView: self.superview)
  }

  override func animationDidStart(anim: CAAnimation!) {
    if multiHalo != nil {
      multiHalo!.removeFromSuperlayer()
    }
  }

  /* Called when the animation either completes its active duration or
  * is removed from the object it is attached to (i.e. the layer). 'flag'
  * is true if the animation reached the end of its active duration
  * without being removed. */

  override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
    if !stop {
      showHalo()
      showAnimation(delay: 2)
    }
  }

  func stopAllAnimation() {
    stop = true
    if multiHalo != nil {
      multiHalo!.removeFromSuperlayer()
    }
  }
}
