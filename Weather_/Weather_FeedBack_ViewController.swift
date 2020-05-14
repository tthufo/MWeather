//
//  Weather_FeedBack_ViewController.swift
//  HearThis
//
//  Created by Thanh Hai Tran on 5/14/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

import UIKit

class Weather_FeedBack_ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var textView: UITextView!
    
    @IBOutlet var submit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.inputAccessoryView = self.toolBar()

         self.view.action(forTouch: [:]) { (objc) in
             self.view.endEditing(true)
         }
    }
    
    func toolBar() -> UIToolbar {
              
      let toolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: Int(self.screenWidth()), height: 50))
      
      toolBar.barStyle = .default
      
      toolBar.items = [UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                       UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                       UIBarButtonItem.init(title: "Thoát", style: .done, target: self, action: #selector(disMiss))]
      return toolBar
    }
      
    @objc func disMiss() {
        self.view.endEditing(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        submit.isEnabled = textView.text?.count != 0
        submit.alpha = textView.text?.count != 0 ? 1 : 0.5
    }
    
    @IBAction func didPressBack() {
       self.view.endEditing(true)
       self.navigationController?.popViewController(animated: true)
    }
}
