//
//  Weather_Info_ViewController.swift
//  HearThis
//
//  Created by Thanh Hai Tran on 5/14/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

import UIKit

class Weather_Info_ViewController: UIViewController {

    @IBOutlet var avatar: UIImageView!
    
    @IBOutlet var name: UILabel!

    @IBOutlet var package: UILabel!

    var avatarTemp: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        name.action(forTouch: [:]) { (obj) in
            self.navigationController?.pushViewController(Weather_Name_ViewController.init(), animated: true)
        }
        
        package.action(forTouch: [:]) { (obj) in
            EM_MenuView.init(package: [:]).show { (index, objc, menu) in
                
            }
        }
    }
    
    @IBAction func didPressBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didPressImage() {
           EM_MenuView.init(settingMenu: [:]).show(completion: { (indexing, obj, menu) in
               switch indexing {
               case 1:
//                   self.didPressPreview(image: self.avatarTemp != nil ? self.avatarTemp as Any: Information.userInfo?.getValueFromKey("Avatar") as Any)
                   break
               case 2:
                   Permission.shareInstance()?.askCamera { (camType) in
                       switch (camType) {
                       case .authorized:
                           DispatchQueue.main.async(execute: {
                               Media.shareInstance().startPickImage(withOption: true, andBase: nil, andRoot: self, andCompletion: { (image) in
                                   if image != nil {
                                       self.avatarTemp = (image as! UIImage)
                                       self.avatar.image = (image as! UIImage)
                                       Information.avatar = (image as! UIImage)
                                   }
                               })
                           })
                           break
                       case .denied:
                           self.showToast("Bạn chưa cho phép sử dụng Camera", andPos: 0)
                           break
                       case .per_denied:
                           self.showToast("Bạn chưa cho phép sử dụng Camera", andPos: 0)
                           break
                       case .per_granted:
                           DispatchQueue.main.async(execute: {
                               Media.shareInstance().startPickImage(withOption: true, andBase: nil, andRoot: self, andCompletion: { (image) in
                                   if image != nil {
                                       self.avatarTemp = (image as! UIImage)
                                       self.avatar.image = (image as! UIImage)
                                       Information.avatar = (image as! UIImage)
                                   }
                               })
                           })
                           break
                       case .restricted:
                           self.showToast("Bạn chưa cho phép sử dụng Camera", andPos: 0)
                           break
                       default:
                           break
                       }
                   }
                   break
               case 3:
                   Permission.shareInstance()?.askGallery { (camType) in
                      switch (camType) {
                      case .authorized:
                           DispatchQueue.main.async(execute: {
                              Media.shareInstance().startPickImage(withOption: false, andBase: nil, andRoot: self, andCompletion: { (image) in
                                  if image != nil {
                                   self.avatarTemp = (image as! UIImage)
                                   self.avatar.image = (image as! UIImage)
                                   Information.avatar = (image as! UIImage)
                                  }
                              })
                          })
                          break
                      case .denied:
                          self.showToast("Bạn chưa cho phép sử dụng Bộ sưu tập", andPos: 0)
                          break
                      case .per_denied:
                          self.showToast("Bạn chưa cho phép sử dụng Bộ sưu tập", andPos: 0)
                          break
                      case .per_granted:
                           DispatchQueue.main.async(execute: {
                              Media.shareInstance().startPickImage(withOption: false, andBase: nil, andRoot: self, andCompletion: { (image) in
                                  if image != nil {
                                   self.avatarTemp = (image as! UIImage)
                                   self.avatar.image = (image as! UIImage)
                                   Information.avatar = (image as! UIImage)
                                  }
                              })
                           })
                          break
                      case .restricted:
                          self.showToast("Bạn chưa cho phép sử dụng Bộ sưu tập", andPos: 0)
                          break
                      default:
                          break
                      }
                  }
                   break
               default:
                   break
               }
           })
       }

}
