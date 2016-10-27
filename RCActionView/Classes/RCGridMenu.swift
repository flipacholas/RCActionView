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
        super.init(frame: CGRect.zero)
    }
    
    convenience init(title: String, image: UIImage, style: RCActionViewStyle?) {
        self.init()
        
        self.clipsToBounds = false
        self.titleLabel!.font = UIFont.systemFont(ofSize: 13)
        self.titleLabel!.backgroundColor = UIColor.clear
        self.titleLabel!.textAlignment = .center
        self.setTitle(title, for: UIControlState())
        self.setTitleColor(RCBaseMenu.BaseMenuTextColor(style), for: UIControlState())
        self.setImage(image, for: UIControlState())
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        let imageRect = CGRect(x: width * 0.2, y: width * 0.2, width: width * 0.6, height: width * 0.6)
        self.imageView!.frame = imageRect
        let labelHeight = height - (imageRect.origin.y + imageRect.size.height)
        let labelRect = CGRect(x: width * 0.05, y: imageRect.origin.y + imageRect.size.height, width: width * 0.9, height: labelHeight)
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
        self.titleLabel = UILabel(frame: CGRect.zero)
        self.contentScrollView = UIScrollView(frame: CGRect.zero)
        self.cancelButton = RCButton(type: .custom)
        
        
        super.init(frame: frame)
        
        
    }
    
    convenience init(title: String, itemTitles: [String], images: [UIImage], style: RCActionViewStyle) {
        self.init(frame: UIScreen.main.bounds)
        var count: Int = min(itemTitles.count, images.count)
        self.titleLabel.text = title
        self.itemTitles = itemTitles
        self.itemImages = images
        
        self.style = style
        
        if (style == .light){
            self.cancelButton.setTitleColor(RCBaseMenu.BaseMenuActionTextColor(), for: UIControlState())
        } else {
            self.cancelButton.setTitleColor(RCBaseMenu.BaseMenuTextColor(self.style), for: UIControlState())
        }
        
        self.backgroundColor = RCBaseMenu.BaseMenuBackgroundColor(self.style)
        self.titleLabel.backgroundColor = UIColor.clear
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = RCBaseMenu.BaseMenuTextColor(self.style)
        self.addSubview(titleLabel)
        self.contentScrollView.contentSize = contentScrollView.bounds.size
        self.contentScrollView.showsHorizontalScrollIndicator = false
        self.contentScrollView.showsVerticalScrollIndicator = true
        self.contentScrollView.backgroundColor = UIColor.clear
        self.addSubview(contentScrollView)
        self.cancelButton.clipsToBounds = true
        self.cancelButton.titleLabel!.font = UIFont.systemFont(ofSize: 17)
        cancelButton.addTarget(self, action: #selector(RCGridMenu.tapAction(_:)), for: .touchUpInside)
        cancelButton.setTitle("Cancel", for: UIControlState())
        self.addSubview(cancelButton)
        
        self.setupWithItemTitles(itemTitles, images: itemImages)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupWithItemTitles(_ titles: [String], images: [UIImage]) {
        var items:[RCGridItem] = []
        for i in 0 ..< titles.count {
            let item: RCGridItem = RCGridItem(title: titles[i], image: images[i], style: style)
            item.tag = i
            item.addTarget(self, action: #selector(RCGridMenu.tapAction(_:)), for: .touchUpInside)
            items.append(item)
            contentScrollView.addSubview(item)
        }
        self.items = items
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: self.bounds.size.width, height: 40))
        self.layoutContentScrollView()
        self.contentScrollView.frame = CGRect(origin: CGPoint(x: 0, y: self.titleLabel.frame.size.height), size: self.contentScrollView.bounds.size)
        self.cancelButton.frame = CGRect(x: self.bounds.size.width * 0.05, y: self.titleLabel.bounds.size.height + self.contentScrollView.bounds.size.height, width: self.bounds.size.width * 0.9, height: 44)
        self.bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: self.bounds.size.width, height: self.titleLabel.bounds.size.height + self.contentScrollView.bounds.size.height + self.cancelButton.bounds.size.height))
    }
    
    func layoutContentScrollView() {
        let margin: UIEdgeInsets = UIEdgeInsetsMake(0, 10, 15, 10)
        let itemSize: CGSize = CGSize(width: (self.bounds.size.width - margin.left - margin.right) / 4, height: 85)
        let itemCount: Int = self.items.count
        let rowCount: Int = ((itemCount - 1) / 4) + 1
        self.contentScrollView.contentSize = CGSize(width: self.bounds.size.width, height: CGFloat(rowCount) * itemSize.height + margin.top + margin.bottom)
        for i in 0 ..< itemCount {
            let item: RCGridItem = self.items[i]
            let row: Int = i / 4
            let column: Int = i % 4
            let p: CGPoint = CGPoint(x: margin.left + CGFloat(column) * itemSize.width, y: margin.top + CGFloat(row) * itemSize.height)
            item.frame = CGRect(origin: p, size: itemSize)
            item.layoutIfNeeded()
        }
        if self.contentScrollView.contentSize.height > kMAX_CONTENT_SCROLLVIEW_HEIGHT {
            self.contentScrollView.bounds = CGRect(origin: CGPoint.zero,size: CGSize(width: self.bounds.size.width, height: kMAX_CONTENT_SCROLLVIEW_HEIGHT))
        }
        else {
            self.contentScrollView.bounds = CGRect(origin: CGPoint.zero, size: self.contentScrollView.contentSize)
        }
    }
    
    func triggerSelectedAction(_ actionHandle: @escaping (NSInteger) -> Void) {
        self.actionHandle = actionHandle
    }
    
    func tapAction(_ sender: AnyObject) {
        if let handle = actionHandle {
            if sender.isEqual(self.cancelButton) {
                let delayInSeconds: Double = 0.15
                let popTime: DispatchTime = DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: popTime, execute: {() -> Void in
                    self.actionHandle!(0)
                })
            }
            else {
                let delayInSeconds: Double = 0.15
                let popTime: DispatchTime = DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: popTime, execute: {() -> Void in
                    self.actionHandle!(sender.tag + 1)
                })
            }
        }
    }
    
    
}
