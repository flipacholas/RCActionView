//
//  RCSheetMenu.swift
//  Pods
//
//  Created by Rodrigo on 10/06/2016.
//
//

import Foundation
class RCSheetMenu : RCBaseMenu, UITableViewDataSource, UITableViewDelegate {
    var titleLabel: UILabel
    var tableView: UITableView!
    var items: [String]
    var subItems: [String]
    var actionHandle: RCMenuActionHandler?
    var selectedItemIndex: Int
    
    let kMAX_SHEET_TABLE_HEIGHT = CGFloat(400)
    
    override init(frame: CGRect) {
        self.titleLabel = UILabel(frame: CGRectZero)
        self.items = []
        self.subItems = []
        self.selectedItemIndex = NSIntegerMax
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(title: String, itemTitles: [String], style: RCActionViewStyle) {
        self.init(frame: UIScreen.mainScreen().bounds)
        self.tableView = UITableView(frame: self.bounds, style: .Plain)
        self.tableView.userInteractionEnabled = true
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .SingleLine
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.style = style
        self.backgroundColor = RCBaseMenu.BaseMenuBackgroundColor(self.style)
        self.titleLabel.backgroundColor = UIColor.clearColor()
        self.titleLabel.font = UIFont.boldSystemFontOfSize(17)
        self.titleLabel.textAlignment = .Center
        self.titleLabel.textColor = RCBaseMenu.BaseMenuTextColor(self.style)
        self.addSubview(titleLabel)
        self.addSubview(tableView)
        
        
        self.setupWithTitle(title, items: itemTitles, subItems: nil)
    }
    
    convenience init(title: String, itemTitles: [String], subTitles: [String], style: RCActionViewStyle) {
        self.init(frame: UIScreen.mainScreen().bounds)
        self.tableView = UITableView(frame: self.bounds, style: .Plain)
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .SingleLine
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.userInteractionEnabled = true
        
        
        
        self.style = style
        self.backgroundColor = RCBaseMenu.BaseMenuBackgroundColor(self.style)
        self.titleLabel.backgroundColor = UIColor.clearColor()
        self.titleLabel.font = UIFont.boldSystemFontOfSize(17)
        self.titleLabel.textAlignment = .Center
        self.titleLabel.textColor = RCBaseMenu.BaseMenuTextColor(self.style)
        self.addSubview(titleLabel)
        self.addSubview(tableView)
        
        self.setupWithTitle(title, items: itemTitles, subItems: subTitles)
    }
    
    func setupWithTitle(title: String, items: [String], subItems: [String]?) {
        self.titleLabel.text = title
        self.items = items
        if let _ = subItems {
            self.subItems = subItems! }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var height: CGFloat = 0
        var table_top_margin: CGFloat = 0
        var table_bottom_margin: CGFloat = 10
        self.titleLabel.frame = CGRect(origin: CGPointZero, size: CGSizeMake(self.bounds.size.width, 40))
        height += self.titleLabel.bounds.size.height
        height += table_top_margin
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        var contentHeight: CGFloat = self.tableView.contentSize.height
        if contentHeight > kMAX_SHEET_TABLE_HEIGHT {
            contentHeight = kMAX_SHEET_TABLE_HEIGHT
            self.tableView.scrollEnabled = true
        }
        else {
            self.tableView.scrollEnabled = false
        }
        self.tableView.allowsSelection = true
        self.tableView.frame = CGRectMake(self.bounds.size.width * 0.05, height, self.bounds.size.width * 0.9, contentHeight)
        height += self.tableView.bounds.size.height
        height += table_bottom_margin
        self.bounds = CGRect(origin: CGPointZero, size: CGSizeMake(self.bounds.size.width, height))
    }
    
    func triggerSelectedAction(actionHandle: (NSInteger) -> Void) {
        self.actionHandle = actionHandle
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.subItems.count > 0 {
            return 55
        }
        else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellId: String = "cellId"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId)
        if let _ = cell { } else {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel!.backgroundColor = UIColor.clearColor()
            cell!.detailTextLabel!.backgroundColor = UIColor.clearColor()
            cell!.selectionStyle = .None
            cell!.textLabel!.font = UIFont.systemFontOfSize(16)
            cell!.detailTextLabel!.font = UIFont.systemFontOfSize(14)
            cell!.textLabel!.textColor = RCBaseMenu.BaseMenuTextColor(self.style)
            cell!.detailTextLabel!.textColor = RCBaseMenu.BaseMenuTextColor(self.style)
        }
        cell!.textLabel!.text = self.items[indexPath.row]
        
        if self.subItems.count > indexPath.row {
            var subTitle: String = self.subItems[indexPath.row]
            if !subTitle.isEqual(NSNull()) {
                cell!.detailTextLabel!.text = subTitle
            }
        }
        if self.selectedItemIndex == indexPath.row {
            cell!.accessoryType = .Checkmark
        }
        else {
            cell!.accessoryType = .None
        }
        return cell!
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.selectedItemIndex != indexPath.row {
            self.selectedItemIndex = indexPath.row
            tableView.reloadData()
        }
        
        if (self.actionHandle != nil) {
            var delayInSeconds: Double = 0.15
            var popTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, dispatch_get_main_queue(), {() -> Void in
                self.actionHandle!(index: indexPath.row)
            })
        }
    }
    
}