//
//  NiceShowViewController.swift
//  NiceLabelDemo
//
//  Created by Jiang Liyin on 14-8-16.
//  Copyright (c) 2014年 Jiang Liyin. All rights reserved.
//

import UIKit

class NiceShowViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  @IBOutlet weak var niceLabelView: NiceLabelView!

  @IBOutlet weak var createBarItem: UINavigationItem!
  var niceContent: NiceContent = NiceContent()

  var filePath: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("showImagePicker"))
    self.niceLabelView.isForCreate = false
    self.title = "Nice label"
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    self.niceLabelView.removeAllLabels()
  }
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
    if segue.identifier == "ShowCreate" {
      let create = segue.destinationViewController as CreateViewController
      create.niceContent.imagePath = filePath
      create.doneBlock = {[weak self] (content: NiceContent) -> Void in
        if self != nil {
          self!.niceContent = content
          self!.showNice()
          self!.navigationController.popToViewController(self!, animated: true)
        }
      }
    }
  }

  func showImagePicker() {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = UIImagePickerControllerSourceType.Camera
    picker.allowsEditing = true
    self.presentViewController(picker, animated: true, completion: nil)
  }

  func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
    let editedImage: UIImage? = info[UIImagePickerControllerEditedImage] as? UIImage
    // TODO: SAVE IMAGE
    let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    let directory: String = paths[0] as String
    let fileName = directory + "/" + "image"
    let data = UIImageJPEGRepresentation(editedImage, 1.0)
    if data.writeToFile(fileName, atomically: true) {
      filePath = fileName
      self.dismissViewControllerAnimated(true, completion: nil)
      self.performSegueWithIdentifier("ShowCreate", sender: nil)
    }
  }
  func showNice() {
    self.niceLabelView.niceContent = self.niceContent
  }

  deinit {
    self.niceLabelView.niceContent = nil
  }
}
