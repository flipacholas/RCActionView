//
//  RCGridMenu.swift
//  Pods
//
//  Created by Rodrigo on 10/06/2016.
//
//

import Foundation

class RCGridItem: UIButton {
    
    init() {
        super.init(frame: CGRectZero)
    }
    
    convenience init(title: String, image: UIImage, style: RCActionViewStyle?) {
        self.init()
        
        self.clipsToBounds = false
        self.titleLabel!.font = UIFont.systemFontOfSize(13)
        self.titleLabel!.backgroundColor = UIColor.clearColor()
        self.titleLabel!.textAlignment = .Center
        self.setTitle(title, forState: .Normal)
        self.setTitleColor(RCBaseMenu.BaseMenuTextColor(style), forState: .Normal)
        self.setImage(image, forState: .Normal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var width = self.bounds.size.width
        var height = self.bounds.size.height
        var imageRect = CGRectMake(width * 0.2, width * 0.2, width * 0.6, width * 0.6)
        self.imageView!.frame = imageRect
        var labelHeight = height - (imageRect.origin.y + imageRect.size.height)
        var labelRect = CGRectMake(width * 0.05, imageRect.origin.y + imageRect.size.height, width * 0.9, labelHeight)
        self.titleLabel!.frame = labelRect
    }
}

class RCGridMenu: RCBaseMenu{
    
    let kMAX_CONTENT_SCROLLVIEW_HEIGHT:CGFloat = 400
    
    var titleLabel: UILabel
    var contentScrollView: UIScrollView
    var cancelButton: RCButton
    var itemTitles: [String]
    var itemImages: [UIImage]
    var items: [RCGridItem]
    
    var actionHandle: ((NSInteger) -> Void)?
    
    override init(frame: CGRect) {
        self.itemTitles = []
        self.itemImages = []
        self.items = []
        self.titleLabel = UILabel(frame: CGRectZero)
        self.contentScrollView = UIScrollView(frame: CGRectZero)
        self.cancelButton = RCButton(type: .Custom)
        
        
        super.init(frame: frame)
        
        
    }
    
    convenience init(title: String, itemTitles: [String], images: [UIImage], style: RCActionViewStyle) {
        self.init(frame: UIScreen.mainScreen().bounds)
        var count: Int = min(itemTitles.count, images.count)
        self.titleLabel.text = title
        self.itemTitles = itemTitles
        self.itemImages = images
        
        self.style = style
        
        if (style == .Light){
            self.cancelButton.setTitleColor(RCBaseMenu.BaseMenuActionTextColor(), forState: .Normal)
        } else {
            self.cancelButton.setTitleColor(RCBaseMenu.BaseMenuTextColor(self.style), forState: .Normal)
        }
        
        self.backgroundColor = RCBaseMenu.BaseMenuBackgroundColor(self.style)
        self.titleLabel.backgroundColor = UIColor.clearColor()
        self.titleLabel.font = UIFont.boldSystemFontOfSize(17)
        self.titleLabel.textAlignment = .Center
        self.titleLabel.textColor = RCBaseMenu.BaseMenuTextColor(self.style)
        self.addSubview(titleLabel)
        self.contentScrollView.contentSize = contentScrollView.bounds.size
        self.contentScrollView.showsHorizontalScrollIndicator = false
        self.contentScrollView.showsVerticalScrollIndicator = true
        self.contentScrollView.backgroundColor = UIColor.clearColor()
        self.addSubview(contentScrollView)
        self.cancelButton.clipsToBounds = true
        self.cancelButton.titleLabel!.font = UIFont.systemFontOfSize(17)
        cancelButton.addTarget(self, action: "tapAction:", forControlEvents: .TouchUpInside)
        cancelButton.setTitle("Cancel", forState: .Normal)
        self.addSubview(cancelButton)
        
        self.setupWithItemTitles(itemTitles, images: itemImages)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupWithItemTitles(titles: [String], images: [UIImage]) {
        var items:[RCGridItem] = []
        for var i = 0; i < titles.count; i++ {
            var item: RCGridItem = RCGridItem(title: titles[i], image: images[i], style: style)
            item.tag = i
            item.addTarget(self, action: "tapAction:", forControlEvents: .TouchUpInside)
            items.append(item)
            contentScrollView.addSubview(item)
        }
        self.items = items
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = CGRect(origin: CGPointZero, size: CGSizeMake(self.bounds.size.width, 40))
        self.layoutContentScrollView()
        self.contentScrollView.frame = CGRect(origin: CGPointMake(0, self.titleLabel.frame.size.height), size: self.contentScrollView.bounds.size)
        self.cancelButton.frame = CGRectMake(self.bounds.size.width * 0.05, self.titleLabel.bounds.size.height + self.contentScrollView.bounds.size.height, self.bounds.size.width * 0.9, 44)
        self.bounds = CGRect(origin: CGPointZero, size: CGSizeMake(self.bounds.size.width, self.titleLabel.bounds.size.height + self.contentScrollView.bounds.size.height + self.cancelButton.bounds.size.height))
    }
    
    func layoutContentScrollView() {
        var margin: UIEdgeInsets = UIEdgeInsetsMake(0, 10, 15, 10)
        var itemSize: CGSize = CGSizeMake((self.bounds.size.width - margin.left - margin.right) / 4, 85)
        var itemCount: Int = self.items.count
        var rowCount: Int = ((itemCount - 1) / 4) + 1
        self.contentScrollView.contentSize = CGSizeMake(self.bounds.size.width, CGFloat(rowCount) * itemSize.height + margin.top + margin.bottom)
        for var i = 0; i < itemCount; i++ {
            var item: RCGridItem = self.items[i]
            var row: Int = i / 4
            var column: Int = i % 4
            var p: CGPoint = CGPointMake(margin.left + CGFloat(column) * itemSize.width, margin.top + CGFloat(row) * itemSize.height)
            item.frame = CGRect(origin: p, size: itemSize)
            item.layoutIfNeeded()
        }
        if self.contentScrollView.contentSize.height > kMAX_CONTENT_SCROLLVIEW_HEIGHT {
            self.contentScrollView.bounds = CGRect(origin: CGPointZero,size: CGSizeMake(self.bounds.size.width, kMAX_CONTENT_SCROLLVIEW_HEIGHT))
        }
        else {
            self.contentScrollView.bounds = CGRect(origin: CGPointZero, size: self.contentScrollView.contentSize)
        }
    }
    
    func triggerSelectedAction(actionHandle: (NSInteger) -> Void) {
        self.actionHandle = actionHandle
    }
    
    func tapAction(sender: AnyObject) {
        if let handle = actionHandle {
            if sender.isEqual(self.cancelButton) {
                var delayInSeconds: Double = 0.15
                var popTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
                dispatch_after(popTime, dispatch_get_main_queue(), {() -> Void in
                    self.actionHandle!(0)
                })
            }
            else {
                var delayInSeconds: Double = 0.15
                var popTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
                dispatch_after(popTime, dispatch_get_main_queue(), {() -> Void in
                    self.actionHandle!(sender.tag + 1)
                })
            }
        }
    }
    
    
}