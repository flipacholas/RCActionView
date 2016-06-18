//
//  ViewController.swift
//  RCActionView
//
//  Created by Rodrigo on 06/10/2016.
//  Copyright (c) 2016 Rodrigo. All rights reserved.
//

import UIKit
import RCActionView

class ViewController: UITableViewController{
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            let selected: Int = self.segmentedControl.selectedSegmentIndex
            let selectedStyle:RCActionViewStyle = selected == 0 ? .Light : .Dark
            if indexPath.row == 0 {
                RCActionView(style: selectedStyle)
                    .showAlertWithTitle("Alert View",
                                        message: "Just input your alert message here.\nUse '\\n' to create a line break.\nAuto height adjust your message.",
                                        leftButtonTitle: "Cancel",
                                        rightButtonTitle: "OK",
                                        selectedHandle: { (selectedOption:Int) -> Void in
                                            self.showDialog(selectedOption) })
            } else if indexPath.row == 1 {
                RCActionView(style: selectedStyle)
                    .showSheetWithTitle("Sheet View",
                                        itemTitles: ["Wedding Bell", "I'm Yours", "When I Was Your Man"],
                                        itemSubTitles: ["Depapepe - Let's go!!!", "Jason Mraz", "Bruno Mars"],
                                        selectedIndex: 0,
                                        selectedHandle: { (selectedOption:Int) -> Void in
                                            self.showDialog(selectedOption) })
            } else if indexPath.row == 2 {
                RCActionView(style: selectedStyle)
                    .showGridMenuWithTitle("Grid View",
                                           itemTitles: ["Facebook", "Twitter", "Google+", "Linkedin", "Weibo", "WeChat", "Pocket", "Dropbox"],
                                           images: [UIImage(named: "facebook")!, UIImage(named: "twitter")!, UIImage(named: "googleplus")!, UIImage(named: "linkedin")!, UIImage(named: "weibo")!, UIImage(named: "wechat")!, UIImage(named: "pocket")!, UIImage(named: "dropbox")!],
                                           selectedHandle: { (selectedOption:Int) -> Void in
                                            self.showDialog(selectedOption) })
            }
            
        }
        
        let delayInSeconds: Double = 0.2
        let popTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue(), {() -> Void in
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        })
    }
    
    
    func showDialog(selectedOption:Int){
        let message = String(format: "You have selected option %i", selectedOption)
        let alert:UIAlertView = UIAlertView(title: "Selected Option", message: message , delegate: nil, cancelButtonTitle: "Ok")
        alert.show()
    }

}

