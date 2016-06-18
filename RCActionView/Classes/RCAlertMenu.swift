//
//  RCAlertMenu.swift
//  Pods
//
//  Created by Rodrigo on 10/06/2016.
//
//

import Foundation

class RCAlertMenu: RCBaseMenu {
    
    var titleLabel: UILabel
    var messageLabel: UILabel
    var actionButtons: [UIButton]
    var actionHandle: RCMenuActionHandler?
    
    override init(frame: CGRect) {
        self.titleLabel = UILabel()
        self.messageLabel = UILabel()
        self.actionButtons = []
        super.init(frame: frame)
        
    }
    
    convenience init(title: String, message: String, buttonTitles: [String], style:RCActionViewStyle) {
        self.init(frame: UIScreen.mainScreen().bounds)
        self.style = style
        
        var actionButtonTitles = buttonTitles
        if (buttonTitles.count > 2) {
            actionButtonTitles.removeRange(Range(start: 2,end: actionButtonTitles.count))
        }
        self.setupWithTitle(title, message: message, actionTitles: actionButtonTitles)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupWithTitle(title: String, message: String, actionTitles: [String]) {
        self.backgroundColor = RCBaseMenu.BaseMenuBackgroundColor(self.style)
        if title != "" {
            self.titleLabel = UILabel(frame: CGRectZero)
            self.titleLabel.backgroundColor = UIColor.clearColor()
            self.titleLabel.font = UIFont.boldSystemFontOfSize(17)
            self.titleLabel.textAlignment = .Center
            self.titleLabel.textColor = RCBaseMenu.BaseMenuTextColor(self.style)
            self.titleLabel.text = title
            self.addSubview(titleLabel)
        }
        
        if message != "" {
            self.messageLabel = UILabel(frame: CGRectZero)
            self.messageLabel.backgroundColor = UIColor.clearColor()
            self.messageLabel.font = UIFont.systemFontOfSize(15)
            self.messageLabel.textAlignment = .Left
            self.messageLabel.textColor = RCBaseMenu.BaseMenuTextColor(self.style)
            self.messageLabel.numberOfLines = 0
            self.messageLabel.text = message
            self.addSubview(messageLabel)
        }
        
        for (var i = 0; i < actionTitles.count; i++) {
            var title: String = actionTitles[i]
            var actionButton: RCButton = RCButton(type: .Custom)
            actionButton.tag = i
            actionButton.clipsToBounds = true
            actionButton.titleLabel?.font = UIFont.systemFontOfSize(16)
            actionButton.setTitleColor(RCBaseMenu.BaseMenuActionTextColor(), forState: .Normal)
            actionButton.setTitle(title, forState: .Normal)
            actionButton.addTarget(self, action: "tapAction:", forControlEvents: .TouchUpInside)
            self.addSubview(actionButton)
            self.actionButtons.append(actionButton)
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var height: CGFloat = 0
        var title_top_margin: CGFloat = (self.messageLabel.text != nil) ? 0 : 15
        var message_top_margin: CGFloat = 0
        var message_bottom_margin: CGFloat = (self.messageLabel.text != nil) ? 15 : 0
        height += title_top_margin
        if self.titleLabel != "" {
            self.titleLabel.frame = CGRect(origin: CGPointMake(0, height), size: CGSizeMake(self.bounds.size.width, 50))
            height += self.titleLabel.bounds.size.height + self.titleLabel.frame.origin.y
        }
        
        height += message_top_margin
        if messageLabel != "" {
            var s: CGSize = CGSizeMake(self.bounds.size.width * 0.9, 1000)
            s = self.messageLabel.sizeThatFits(s)
            self.messageLabel.frame = CGRect(origin: CGPointMake(self.bounds.size.width * 0.05, height), size: s)
            height += s.height
        }
        height += message_bottom_margin
        var btn_y: CGFloat = height
        for var i = 0; i < self.actionButtons.count; i++ {
            var button: UIButton = self.actionButtons[i]
            button.frame = CGRect(origin: CGPointMake(CGFloat(i) * self.bounds.size.width / 2, btn_y), size: CGSizeMake(self.bounds.size.width / CGFloat(self.actionButtons.count), 44))
            if i == 0 {
                height += 44
            }
        }
        self.bounds = CGRect(origin: CGPointZero, size: CGSizeMake(self.bounds.size.width, height))
        
    }
    
    func triggerSelectedAction(actionHandle: RCMenuActionHandler) {
        self.actionHandle = actionHandle
    }
    
    func tapAction(sender: AnyObject) {
        if (sender is UIButton) {
            var tag: Int = (sender as! UIButton).tag
            var delayInSeconds: Double = 0.15
            var popTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, dispatch_get_main_queue(), {() -> Void in
                self.actionHandle!(index: tag)
            })
        }
    }
    
    
    
}
