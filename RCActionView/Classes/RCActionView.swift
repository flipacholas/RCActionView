//
//  RCActionView.swift
//  Pods
//
//  Created by Rodrigo on 10/06/2016.
//
//

import Foundation

public enum RCActionViewStyle : Int {
    case light = 0
    case dark
}

public typealias RCMenuActionHandler = (_ index: Int) -> Void

open class RCActionView: UIView, UIGestureRecognizerDelegate {
    var menus: [RCBaseMenu]
    var _showMenuAnimation: CAAnimation?
    var _dismissMenuAnimation: CAAnimation?
    var _dimingAnimation: CAAnimation?
    var _lightingAnimation: CAAnimation?
    
    var tapGesture: UITapGestureRecognizer?
    open var style: RCActionViewStyle
    
    public convenience init(style: RCActionViewStyle) {
        self.init(frame: UIScreen.main.bounds, style: style)
        
    }
    
    
    public init(frame: CGRect, style: RCActionViewStyle) {
        self.menus = []
        self.style = style
        super.init(frame: frame)
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(RCActionView.tapAction(_:)))
        tapGesture?.cancelsTouchesInView = false
        //self.tapGesture!.delegate! = self
        self.addGestureRecognizer(tapGesture!)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.removeGestureRecognizer(tapGesture!)
    }
    
    
    func tapAction(_ tapGesture: UITapGestureRecognizer) {
        let touchPoint: CGPoint = tapGesture.location(in: self)
        let menu: RCBaseMenu = self.menus[self.menus.endIndex - 1]
        if !menu.frame.contains(touchPoint) {
            self.dismissMenu(menu, Animated: true)
            if let _ = self.menus.index(of: menu){
                self.menus.remove(at: self.menus.index(of: menu)!)
            }
        }
    }
    
    
    override open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isEqual(self.tapGesture) {
            let p: CGPoint = gestureRecognizer.location(in: self)
            let topMenu: RCBaseMenu = self.menus[self.menus.endIndex - 1]
            if topMenu.frame.contains(p) {
                return false
            }
        }
        return true
    }
    
    func setMenu(_ menu: UIView, animation animated: Bool) {
        if let view = self.superview { } else {
            let window: UIWindow! = UIApplication.shared.keyWindow
            window.addSubview(self)
        }
        let topMenu: RCBaseMenu = (menu as! RCBaseMenu)
        self.menus.forEach { $0.removeFromSuperview() }
        self.menus.append(topMenu)
        topMenu.style = self.style
        
        self.addSubview(topMenu)
        topMenu.layoutIfNeeded()
        topMenu.frame = CGRect(origin: CGPoint(x: 0, y: self.bounds.size.height - topMenu.bounds.size.height), size: topMenu.bounds.size)
        if animated && self.menus.count == 1 {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.2)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
            self.layer.add(self.dimingAnimation(), forKey: "diming")
            topMenu.layer.add(self.showMenuAnimation(), forKey: "showMenu")
            CATransaction.commit()
        }
    }
    
    func dismissMenu(_ menu: RCBaseMenu, Animated animated: Bool) {
        if let _ = self.superview {
            self.menus.remove(at: self.menus.index(of: menu)!)
            if animated && self.menus.count == 0 {
                CATransaction.begin()
                CATransaction.setAnimationDuration(0.2)
                CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn))
                CATransaction.setCompletionBlock({
                    self.removeFromSuperview()
                    menu.removeFromSuperview()
                })
                self.layer.add(self.lightingAnimation(), forKey: "lighting")
                menu.layer.add(self.dismissMenuAnimation(), forKey: "dismissMenu")
                CATransaction.commit()
            }
            else {
                menu.removeFromSuperview()
                let topMenu: RCBaseMenu = self.menus[self.menus.endIndex - 1]
                topMenu.style = self.style
                self.addSubview(topMenu)
                topMenu.layoutIfNeeded()
                topMenu.frame = CGRect(origin: CGPoint(x: 0, y: self.bounds.size.height - topMenu.bounds.size.height), size: topMenu.bounds.size)
                
            }
        }
    }
    
    func dimingAnimation() -> CAAnimation {
        if let _ = _dimingAnimation { } else{
            let opacityAnimation: CABasicAnimation = CABasicAnimation(keyPath: "backgroundColor")
            opacityAnimation.fromValue = (UIColor(white: 0.0, alpha: 0.0).cgColor as AnyObject)
            opacityAnimation.toValue = (UIColor(white: 0.0, alpha: 0.4).cgColor as AnyObject)
            opacityAnimation.isRemovedOnCompletion = false
            opacityAnimation.fillMode = kCAFillModeBoth
            _dimingAnimation = opacityAnimation
        }
        return _dimingAnimation!
    }
    
    func lightingAnimation() -> CAAnimation {
        if let _ = _lightingAnimation { } else{
            let opacityAnimation: CABasicAnimation = CABasicAnimation(keyPath: "backgroundColor")
            opacityAnimation.fromValue = (UIColor(white: 0.0, alpha: 0.4).cgColor as AnyObject)
            opacityAnimation.toValue = (UIColor(white: 0.0, alpha: 0.0).cgColor as AnyObject)
            opacityAnimation.isRemovedOnCompletion = false
            opacityAnimation.fillMode = kCAFillModeBoth
            _lightingAnimation = opacityAnimation
        }
        return _lightingAnimation!
    }
    
    func showMenuAnimation() -> CAAnimation {
        if let _ = _showMenuAnimation {} else{
            let rotateAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform")
            var t: CATransform3D = CATransform3DIdentity
            t.m34 = 1 / -500.0
            let from: CATransform3D = CATransform3DRotate(t, -30.0 * CGFloat(M_PI) / 180.0, 1, 0, 0)
            let to: CATransform3D = CATransform3DIdentity
            rotateAnimation.fromValue = NSValue(caTransform3D: from)
            rotateAnimation.toValue = NSValue(caTransform3D: to)
            let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 0.9
            scaleAnimation.toValue = 1.0
            let positionAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y")
            positionAnimation.fromValue = Int(50.0)
            positionAnimation.toValue = Int(0.0)
            let opacityAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 0.0
            opacityAnimation.toValue = 1.0
            let group: CAAnimationGroup = CAAnimationGroup()
            group.animations = [rotateAnimation, scaleAnimation, opacityAnimation, positionAnimation]
            group.isRemovedOnCompletion = false
            group.fillMode = kCAFillModeBoth
            _showMenuAnimation = group
        }
        return _showMenuAnimation!
    }
    
    
    func dismissMenuAnimation() -> CAAnimation {
        if let _ = _dismissMenuAnimation {} else{
            let rotateAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform")
            var t: CATransform3D = CATransform3DIdentity
            t.m34 = 1 / -500.0
            let from: CATransform3D = CATransform3DIdentity
            let to: CATransform3D = CATransform3DRotate(t, -30.0 * CGFloat(M_PI) / 180.0, 1, 0, 0)
            rotateAnimation.fromValue = NSValue(caTransform3D: from)
            rotateAnimation.toValue = NSValue(caTransform3D: to)
            let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 1.0
            scaleAnimation.toValue = 0.9
            let positionAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y")
            positionAnimation.fromValue = Int(0.0)
            positionAnimation.toValue = Int(50.0)
            let opacityAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 1.0
            opacityAnimation.toValue = 0.0
            let group: CAAnimationGroup = CAAnimationGroup()
            group.animations = [rotateAnimation, scaleAnimation, opacityAnimation, positionAnimation]
            group.isRemovedOnCompletion = false
            group.fillMode = kCAFillModeBoth
            _dismissMenuAnimation = group
        }
        return _dismissMenuAnimation!
    }
    
    open func showAlertWithTitle(_ title: String, message: String, leftButtonTitle leftTitle: String, rightButtonTitle rightTitle: String, selectedHandle handler: RCMenuActionHandler?) {
        var menu: RCAlertMenu = RCAlertMenu(title: title, message: message, buttonTitles: [leftTitle, rightTitle], style: self.style)
        menu.triggerSelectedAction({(index: Int) -> Void in
            self.dismissMenu(menu, Animated: true)
            if handler != nil {
                handler!(index)
            }
        })
        self.setMenu(menu, animation: true)
    }
    
    
    open func showSheetWithTitle(_ title: String, itemTitles: [String], selectedIndex: Int, selectedHandle handler: RCMenuActionHandler?) {
        var menu: RCSheetMenu = RCSheetMenu(title: title, itemTitles: itemTitles, style: self.style)
        menu.selectedItemIndex = selectedIndex
        menu.triggerSelectedAction({(index: Int) -> Void in
            self.dismissMenu(menu, Animated: true)
            if handler != nil {
                handler!(index)
            }
        })
        self.setMenu(menu, animation: true)
    }
    
    open func showSheetWithTitle(_ title: String, itemTitles: [String], itemSubTitles: [String], selectedIndex: Int, selectedHandle handler: RCMenuActionHandler?) {
        var menu: RCSheetMenu = RCSheetMenu(title: title, itemTitles: itemTitles, subTitles: itemSubTitles, style: self.style)
        menu.selectedItemIndex = selectedIndex
        menu.triggerSelectedAction({(index: Int) -> Void in
            self.dismissMenu(menu, Animated: true)
            if handler != nil {
                handler!(index)
            }
        })
        self.setMenu(menu, animation: true)
    }
    
    
    open func showGridMenuWithTitle(_ title: String, itemTitles: [String], images: [UIImage], selectedHandle handler: RCMenuActionHandler?) {
        var menu: RCGridMenu = RCGridMenu(title: title, itemTitles: itemTitles, images: images, style: self.style)
        menu.triggerSelectedAction({(index: Int) -> Void in
            self.dismissMenu(menu, Animated: true)
            if handler != nil {
                handler!(index)
            }
        })
        self.setMenu(menu, animation: true)
        
    }
    
}
