//
//  ViewController.swift
//  NiceLabelDemo
//
//  Created by Jiang Liyin on 14-8-16.
//  Copyright (c) 2014年 Jiang Liyin. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {
                            
  @IBOutlet weak var niceLabelView: NiceLabelView!


  var niceContent: NiceContent = NiceContent()

  var doneBlock: ((content: NiceContent) -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: Selector("saveLabels"))

    niceLabelView.niceContent = niceContent
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func saveLabels() {
    niceContent = niceLabelView.saveLabels()
    if doneBlock != nil {
      doneBlock!(content: niceContent)
    }
  }
}

