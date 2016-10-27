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
        self.titleLabel = UILabel(frame: CGRect.zero)
        self.items = []
        self.subItems = []
        self.selectedItemIndex = NSIntegerMax
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(title: String, itemTitles: [String], style: RCActionViewStyle) {
        self.init(frame: UIScreen.main.bounds)
        self.tableView = UITableView(frame: self.bounds, style: .plain)
        self.tableView.isUserInteractionEnabled = true
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .singleLine
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.style = style
        self.backgroundColor = RCBaseMenu.BaseMenuBackgroundColor(self.style)
        self.titleLabel.backgroundColor = UIColor.clear
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = RCBaseMenu.BaseMenuTextColor(self.style)
        self.addSubview(titleLabel)
        self.addSubview(tableView)
        
        
        self.setupWithTitle(title, items: itemTitles, subItems: nil)
    }
    
    convenience init(title: String, itemTitles: [String], subTitles: [String], style: RCActionViewStyle) {
        self.init(frame: UIScreen.main.bounds)
        self.tableView = UITableView(frame: self.bounds, style: .plain)
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .singleLine
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.isUserInteractionEnabled = true
        
        
        
        self.style = style
        self.backgroundColor = RCBaseMenu.BaseMenuBackgroundColor(self.style)
        self.titleLabel.backgroundColor = UIColor.clear
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = RCBaseMenu.BaseMenuTextColor(self.style)
        self.addSubview(titleLabel)
        self.addSubview(tableView)
        
        self.setupWithTitle(title, items: itemTitles, subItems: subTitles)
    }
    
    func setupWithTitle(_ title: String, items: [String], subItems: [String]?) {
        self.titleLabel.text = title
        self.items = items
        if let _ = subItems {
            self.subItems = subItems! }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var height: CGFloat = 0
        let table_top_margin: CGFloat = 0
        let table_bottom_margin: CGFloat = 10
        self.titleLabel.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.bounds.size.width, height: 40))
        height += self.titleLabel.bounds.size.height
        height += table_top_margin
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        var contentHeight: CGFloat = self.tableView.contentSize.height
        if contentHeight > kMAX_SHEET_TABLE_HEIGHT {
            contentHeight = kMAX_SHEET_TABLE_HEIGHT
            self.tableView.isScrollEnabled = true
        }
        else {
            self.tableView.isScrollEnabled = false
        }
        self.tableView.allowsSelection = true
        self.tableView.frame = CGRect(x: self.bounds.size.width * 0.05, y: height, width: self.bounds.size.width * 0.9, height: contentHeight)
        height += self.tableView.bounds.size.height
        height += table_bottom_margin
        self.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: self.bounds.size.width, height: height))
    }
    
    func triggerSelectedAction(_ actionHandle: @escaping (NSInteger) -> Void) {
        self.actionHandle = actionHandle
    }
    
    func numberOfSections(in tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView!, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.subItems.count > 0 {
            return 55
        }
        else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView!, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellId: String = "cellId"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId)
        if let _ = cell { } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
            cell!.backgroundColor = UIColor.clear
            cell!.textLabel!.backgroundColor = UIColor.clear
            cell!.detailTextLabel!.backgroundColor = UIColor.clear
            cell!.selectionStyle = .none
            cell!.textLabel!.font = UIFont.systemFont(ofSize: 16)
            cell!.detailTextLabel!.font = UIFont.systemFont(ofSize: 14)
            cell!.textLabel!.textColor = RCBaseMenu.BaseMenuTextColor(self.style)
            cell!.detailTextLabel!.textColor = RCBaseMenu.BaseMenuTextColor(self.style)
        }
        cell!.textLabel!.text = self.items[(indexPath as NSIndexPath).row]
        
        if self.subItems.count > (indexPath as NSIndexPath).row {
            var subTitle: String = self.subItems[(indexPath as NSIndexPath).row]
            if !subTitle.isEqual(NSNull()) {
                cell!.detailTextLabel!.text = subTitle
            }
        }
        if self.selectedItemIndex == (indexPath as NSIndexPath).row {
            cell!.accessoryType = .checkmark
        }
        else {
            cell!.accessoryType = .none
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView!, didSelectRowAt indexPath: IndexPath) {
        if self.selectedItemIndex != (indexPath as NSIndexPath).row {
            self.selectedItemIndex = (indexPath as NSIndexPath).row
            tableView.reloadData()
        }
        
        if (self.actionHandle != nil) {
            let delayInSeconds: Double = 0.15
            let popTime: DispatchTime = DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime, execute: {() -> Void in
                self.actionHandle!((indexPath as NSIndexPath).row)
            })
        }
    }
    
}
