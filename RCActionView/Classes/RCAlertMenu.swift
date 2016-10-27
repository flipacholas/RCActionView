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
        self.init(frame: UIScreen.main.bounds)
        self.style = style
        
        var actionButtonTitles = buttonTitles
        if (buttonTitles.count > 2) {
            actionButtonTitles.removeSubrange((2 ..< actionButtonTitles.count))
        }
        self.setupWithTitle(title, message: message, actionTitles: actionButtonTitles)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupWithTitle(_ title: String, message: String, actionTitles: [String]) {
        self.backgroundColor = RCBaseMenu.BaseMenuBackgroundColor(self.style)
        if title != "" {
            self.titleLabel = UILabel(frame: CGRect.zero)
            self.titleLabel.backgroundColor = UIColor.clear
            self.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
            self.titleLabel.textAlignment = .center
            self.titleLabel.textColor = RCBaseMenu.BaseMenuTextColor(self.style)
            self.titleLabel.text = title
            self.addSubview(titleLabel)
        }
        
        if message != "" {
            self.messageLabel = UILabel(frame: CGRect.zero)
            self.messageLabel.backgroundColor = UIColor.clear
            self.messageLabel.font = UIFont.systemFont(ofSize: 15)
            self.messageLabel.textAlignment = .left
            self.messageLabel.textColor = RCBaseMenu.BaseMenuTextColor(self.style)
            self.messageLabel.numberOfLines = 0
            self.messageLabel.text = message
            self.addSubview(messageLabel)
        }
        
        for i in (0 ..< actionTitles.count) {
            var title: String = actionTitles[i]
            var actionButton: RCButton = RCButton(type: .custom)
            actionButton.tag = i
            actionButton.clipsToBounds = true
            actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            actionButton.setTitleColor(RCBaseMenu.BaseMenuActionTextColor(), for: UIControlState())
            actionButton.setTitle(title, for: UIControlState())
            actionButton.addTarget(self, action: #selector(RCAlertMenu.tapAction(_:)), for: .touchUpInside)
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
        if self.titleLabel.text != "" {
            self.titleLabel.frame = CGRect(origin: CGPoint(x: 0, y: height), size: CGSize(width: self.bounds.size.width, height: 50))
            height += self.titleLabel.bounds.size.height + self.titleLabel.frame.origin.y
        }
        
        height += message_top_margin
        if messageLabel.text != "" {
            var s: CGSize = CGSize(width: self.bounds.size.width * 0.9, height: 1000)
            s = self.messageLabel.sizeThatFits(s)
            self.messageLabel.frame = CGRect(origin: CGPoint(x: self.bounds.size.width * 0.05, y: height), size: s)
            height += s.height
        }
        height += message_bottom_margin
        var btn_y: CGFloat = height
        for i in 0 ..< self.actionButtons.count {
            var button: UIButton = self.actionButtons[i]
            button.frame = CGRect(origin: CGPoint(x: CGFloat(i) * self.bounds.size.width / 2, y: btn_y), size: CGSize(width: self.bounds.size.width / CGFloat(self.actionButtons.count), height: 44))
            if i == 0 {
                height += 44
            }
        }
        self.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: self.bounds.size.width, height: height))
        
    }
    
    func triggerSelectedAction(_ actionHandle: @escaping RCMenuActionHandler) {
        self.actionHandle = actionHandle
    }
    
    func tapAction(_ sender: AnyObject) {
        if (sender is UIButton) {
            let tag: Int = (sender as! UIButton).tag
            let delayInSeconds: Double = 0.15
            let popTime: DispatchTime = DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime, execute: {() -> Void in
                self.actionHandle!(tag)
            })
        }
    }
    
    
    
}
