//
//  First_Tab_ViewController.swift
//  HearThis
//
//  Created by Thanh Hai Tran on 4/8/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

import UIKit

import MessageUI

//import MarqueeLabel

class PC_Weather_Main_ViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet var tableView: OwnTableView!
    
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var coverView: UIImageView!

//    @IBOutlet var titleLabel: MarqueeLabel!
    
    var config: NSArray!
    
    var dataList: NSMutableArray!
    
    
    var weatherData: NSMutableDictionary!
    
    
    let refreshControl = UIRefreshControl()

    func reloadState() {
        self.bottomView.isHidden = logged() ? true : false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.bottomView.isHidden = logged() ? true : false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let login = self.loginNav(type: "logIn") { (info) in
            self.coverView.alpha = 0
            self.bottomView.isHidden = logged() ? true : false
        }
        self.center()?.present(login, animated: false, completion: nil)
        
        weatherData = NSMutableDictionary.init()
        
        tableView.withCell("PC_Weather_Cell")
        
        tableView.withCell("PC_Day_Cell")

        tableView.withCell("PC_Week_Cell")

        tableView.withCell("PC_Rain_Cell")

        tableView.withCell("PC_Wind_Cell")

        
        tableView.withCell("TG_Room_Cell_Banner_1")

        tableView.withCell("TG_Room_Cell_0")

        tableView.withCell("TG_Room_Cell_1")

        tableView.withCell("TG_Room_Cell_2")

        tableView.withCell("TG_Room_Cell_3")

        tableView.withCell("TG_Room_Cell_4")

        tableView.withCell("TG_Room_Cell_5")
                
        tableView.withCell("TG_Room_Cell_6")

        tableView.withCell("TG_Room_Cell_7")

        tableView.withCell("TG_Room_Cell_8")
                
        tableView.withCell("TG_Room_Cell_9")

        tableView.withCell("TG_Room_Cell_10")
        
        dataList = NSMutableArray.init()
        
        tableView.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(didReload), for: .valueChanged)
        
        config = NSArray.init(array: [["url": ["CMD_CODE":"getHomeEvent",
                                               "page_index": 1,
                                               "page_size": 24,
                                               "position": 1,
            ], "height": self.screenHeight() - 44, "loaded": false, "ident": "PC_Weather_Cell"],
                                      ["title":"Mới nhất",
                                       "url": ["CMD_CODE":"getListBook",
                                          "page_index": 1,
                                          "page_size": 24,
                                          "book_type": 2,
                                          "price": 0,
                                          "sorting": 1,
                                        ], "height": 290, "direction": "horizontal", "loaded": false, "ident": "PC_Day_Cell"],
                                      ["title":"Miễn phí HOT",
                                       "url": ["CMD_CODE":"getListBook",
                                           "page_index": 1,
                                           "page_size": 24,
                                           "book_type": 0,
                                           "price": 2,
                                           "sorting": 1,
                                       ], "height": 450, "direction": "horizontal", "loaded": false, "ident": "PC_Week_Cell"],
                                      ["title":"Đọc nhiều nhất",
                                       "url": ["CMD_CODE":"getListBook",
                                          "page_index": 1,
                                          "page_size": 24,
                                          "book_type": 0,
                                          "price": 0,
                                          "sorting": 1,
                                      ], "height": 300, "direction": "vertical", "loaded": false, "ident": "PC_Rain_Cell"],
                                      ["title":"Sách nói",
                                       "url": ["CMD_CODE":"getListBook",
                                          "page_index": 1,
                                          "page_size": 24,
                                          "book_type": 3,
                                          "price": 0,
                                          "sorting": 1,
                                      ], "height": 300, "direction": "horizontal", "loaded": false, "ident": "PC_Wind_Cell"],
                                      ["title":"Khuyên nên đọc",
                                       "url": ["CMD_CODE":"getListBook",
                                          "page_index": 1,
                                          "page_size": 24,
                                          "book_type": 0,
                                          "price": 0,
                                          "sorting": 3,
                                      ], "height": 0, "direction": "vertical", "loaded": false],
                                      ["url": ["CMD_CODE":"getHomeEvent",
                                               "page_index": 1,
                                               "page_size": 24,
                                               "position": 2,
                                      ], "height": 0, "loaded": false, "ident": "TG_Room_Cell_Banner_1"],
                                      ["title":"Promotion",
                                        "url": ["CMD_CODE":"getListPromotionBook",
                                           "page_index": 1,
                                           "page_size": 24,
                                         ], "height": 0, "direction": "horizontal", "loaded": false],
        ]).withMutable() as NSArray?
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.didReload()
        })
        
        didGetWeather()
    }
    
     func didGetWeather() {
       LTRequest.sharedInstance()?.didRequestInfo(["cmd_code":"getCurrentWeather",
                                                   "lat": self.lat(),
                                                   "long": self.lng(),
                                                   "overrideAlert":"1",
                                                   "overrideLoading":"1",
                                                   "host":self], withCache: { (cacheString) in
       }, andCompletion: { (response, errorCode, error, isValid, object) in
           let result = response?.dictionize() ?? [:]
                                               
           if result.getValueFromKey("error_code") != "0" || result["result"] is NSNull {
               self.showToast(response?.dictionize().getValueFromKey("error_msg") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("error_msg"), andPos: 0)
               return
           }
                  
           self.weatherData.removeAllObjects()
        
           self.weatherData.addEntries(from: (result["result"] as! NSDictionary) as! [AnyHashable : Any])
        
           self.tableView.reloadData()
       })
   }
    
    @objc func didReload() {
        for dict in self.config {
            (dict as! NSMutableDictionary)["loaded"] = false
        }
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.refreshControl.endRefreshing()
        })
    }
    
    @IBAction func didPressMenu() {
        self.root()?.toggleLeftPanel(nil)
        (self.left() as! TG_Intro_ViewController).reloadLogin()
    }
    
    @IBAction func didPressSearch() {
        if logged() {
            self.center()?.pushViewController(PC_Search_Weather_ViewController.init(), animated: true)

//            self.didGetPackage(showMenu: true)
        } else {
            let login = self.loginNav(type: "logOut") { (info) in
                self.bottomView.isHidden = logged() ? true : false
            }
            self.center()?.present(login, animated: true, completion: nil)
        }
        
//        let search = Search_ViewController.init()
//        search.config = [:]
//        self.center()?.pushViewController(search, animated: true)
    }
    
    func didGetPackage(showMenu: Bool) {
        LTRequest.sharedInstance()?.didRequestInfo(["cmd_code":"getPackageInfo",
                                                    "session": Information.token ?? "",
                                                    "overrideAlert":"1",
                                                    "overrideLoading":"1",
                                                    "host":self], withCache: { (cacheString) in
        }, andCompletion: { (response, errorCode, error, isValid, object) in
            let result = response?.dictionize() ?? [:]
                          
            if result.getValueFromKey("error_code") != "0" || result["result"] is NSNull {
                self.showToast(response?.dictionize().getValueFromKey("error_msg") == "" ? "Lỗi xảy ra, mời bạn thử lại" : response?.dictionize().getValueFromKey("error_msg"), andPos: 0)
                return
            }
                    
            let info = ((result["result"] as! NSArray)[0] as! NSDictionary)
            
            if showMenu {
                if info.getValueFromKey("status") == "1" {
                    self.center()?.pushViewController(PC_Search_Weather_ViewController.init(), animated: true)
                } else {
                    EM_MenuView.init(package: (info as! [AnyHashable : Any])).show { (index, objc, menu) in
                        if index == 0 {
                            let data = (objc as! NSDictionary)
                            if (MFMessageComposeViewController.canSendText()) {
                                 let controller = MFMessageComposeViewController()
                                 controller.body = data.getValueFromKey("reg_keyword")
                                 controller.recipients = [data.getValueFromKey("reg_shortcode")]
                                 controller.messageComposeDelegate = self
                                 self.present(controller, animated: true, completion: nil)
                             }
                        }
                    }
                }
            }
        })
    }
    
    @IBAction func didPressLogin() {
        let login = self.loginNav(type: "logOut") { (info) in
            self.bottomView.isHidden = logged() ? true : false
        }
        self.center()?.present(login, animated: true, completion: nil)
    }
    
    @IBAction func didPressRegister() {
       
    }
}

extension PC_Weather_Main_ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (config![indexPath.row] as! NSDictionary)["height"] as! CGFloat
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5//config.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conf = config[indexPath.row] as! NSMutableDictionary
        let cell = tableView.dequeueReusableCell(withIdentifier: conf.getValueFromKey("ident") != "" ? conf.getValueFromKey("ident") : "TG_Room_Cell_%i".format(parameters: indexPath.row) , for: indexPath)
        
        if indexPath.row == 0 {
            (cell as! PC_Weather_Cell).data = self.weatherData as NSDictionary
        }
        
        if indexPath.row == 1 {
            self.dayCell(cell: cell)
        }
        
        if indexPath.row == 2 {
            self.weekCell(cell: cell)
        }
        
        if indexPath.row == 3 {
            
        }
        
        if indexPath.row == 4 {
            (cell as! PC_Wind_Cell).data = self.weatherData as NSDictionary
        }
        
        return cell
    }
    
    func dayCell(cell: UITableViewCell) {
        if !self.weatherData.response(forKey: "currently") {
            return
        }
        let currently = (self.weatherData as NSDictionary)["currently"] as! NSDictionary
        
        let keys = [["key":"precipIntensity", "tag": 1, "unit": "mm"],
                    ["key":"dewPoint", "tag": 2, "unit": "°"],
                    ["key":"humidity", "tag": 3, "unit": "%"],
                    ["key":"windSpeed", "tag": 4, "unit": "km/h"],
                    ["key":"windGust", "tag": 5, "unit": "km/h"],
                    ["key":"pressure", "tag": 6, "unit": "mb"],
                    ["key":"windBearing", "tag": 7, "unit": ""],
                    ["key":"uvIndex", "tag": 8, "unit": "UV"]]
        
        for view in cell.contentView.subviews {
            for key in keys {
                if view.tag == key["tag"] as! Int + 9 {
                    (view as! UILabel).text = self.returnValCurrent(currently.getValueFromKey((key["key"] as! String)), unit: (key["unit"] as! String))
                }
            }
        }
    }
    
    func weekCell(cell: UITableViewCell) {
        if !self.weatherData.response(forKey: "daily") {
            return
        }
        let daily = (self.weatherData as NSDictionary)["daily"] as! NSArray
        let keys = ["temperatureHigh", "temperatureLow", "icon", "humidity", "time"]
        var index = 0
        for view in (self.withView(cell, tag: 11) as! UIStackView).subviews {
            var indexing = 0
            for subView in view.subviews {
                let tempa = (daily[index] as! NSDictionary).getValueFromKey(keys[indexing])
                if subView is UILabel {
                    (subView as! UILabel).text = indexing == 4 ? self.returnDate(tempa) : self.returnVal(tempa, unit: indexing == 3 ? "%" : "°")
                } else {
                    (subView as! UIImageView).image = UIImage.init(named: tempa!.replacingOccurrences(of: "-", with: "_"))
                }
                indexing += 1
            }
            index += 1
        }
    }
    
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}
