//
//  PC_Search_Weather_ViewController.swift
//  HearThis
//
//  Created by Thanh Hai Tran on 5/15/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

import UIKit

import SwipyCell

class PC_Search_Weather_ViewController: UIViewController {

    var dataList: NSMutableArray!

    @IBOutlet weak var tableView: UITableView! {
          didSet {
              tableView.rowHeight = UITableView.automaticDimension
              tableView.estimatedRowHeight = 80.0
          }
      }
    
    @IBAction func didPressBack() {
       self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataList = NSMutableArray.init()
        
        tableView.withCell("PC_Notification_Cell")
        
        didGetLocation()
    }
    
    func viewWithImageName(_ imageName: String) -> UIView {
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        return imageView
    }
    
    func didGetLocation() {
         LTRequest.sharedInstance()?.didRequestInfo(["cmd_code":"getListFavouriteLocation",
                                                     "session":Information.token ?? "",
                                                     "overrideAlert":"1",
                                                     "overrideLoading":"1",
                                                     "host":self], withCache: { (cacheString) in
         }, andCompletion: { (response, errorCode, error, isValid, object) in
             let result = response?.dictionize() ?? [:]
                                                 
             if result.getValueFromKey("error_code") != "0" || result["result"] is NSNull {
                 self.showToast(response?.dictionize().getValueFromKey("error_msg") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("error_msg"), andPos: 0)
                 return
             }
            
            self.dataList.removeAllObjects()
            
            self.dataList.addObjects(from: ((result["result"] as! NSArray) as! [Any]))
                                               
            self.tableView.reloadData()
            
//             print(result)
       })
   }
}

extension PC_Search_Weather_ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92//UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PC_Notification_Cell", for: indexPath) as! SwipyCell
        
        let data = dataList[indexPath.row] as! NSDictionary

        let weather = ((dataList[indexPath.row] as! NSDictionary)["weather"] as! NSDictionary)["currently"] as! NSDictionary

        let swipeView = viewWithImageName("ic-delete-all")
        let swipeColor = AVHexColor.color(withHexString: "#CCCCCD")
        
        (self.withView(cell, tag: 11) as! UILabel).text = (data["info"] as! NSDictionary).getValueFromKey("name")
            
        (self.withView(cell, tag: 12) as! UILabel).text = weather.getValueFromKey("temperature") + "°"

        (self.withView(cell, tag: 13) as! UIImageView).image = UIImage.init(named: (weather.getValueFromKey("icon")?.replacingOccurrences(of: "-", with: "_"))!)
        
        print(weather.getValueFromKey("icon"))
        
        cell.addSwipeTrigger(forState: .state(0, .right), withMode: .exit, swipeView: swipeView, swipeColor: swipeColor!, completion: { cell, trigger, state, mode in
            
//            self.dataList.removeObject(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            let status = data.getValueFromKey("status")
//            if status == "0" {
//                Information.changeInfo(notification: -1)
//            }
//            self.tableView.reloadData()
//            self.didRequestDeleteNotification(idNotification: data.getValueFromKey("notification_id")! as NSString)
            
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
