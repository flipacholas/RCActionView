//
//  RCActionView.swift
//  Pods
//
//  Created by Rodrigo on 10/06/2016.
//
//

import Foundation

public enum RCActionViewStyle : Int {
    case Light = 0
    case Dark
}

public typealias RCMenuActionHandler = (index: Int) -> Void

public class RCActionView: UIView, UIGestureRecognizerDelegate {
    var menus: [RCBaseMenu]
    var _showMenuAnimation: CAAnimation?
    var _dismissMenuAnimation: CAAnimation?
    var _dimingAnimation: CAAnimation?
    var _lightingAnimation: CAAnimation?
    
    var tapGesture: UITapGestureRecognizer?
    public var style: RCActionViewStyle
    
    public convenience init(style: RCActionViewStyle) {
        self.init(frame: UIScreen.mainScreen().bounds, style: style)
        
    }
    
    
    public init(frame: CGRect, style: RCActionViewStyle) {
        self.menus = []
        self.style = style
        super.init(frame: frame)
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: "tapAction:")
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
    
    
    func tapAction(tapGesture: UITapGestureRecognizer) {
        var touchPoint: CGPoint = tapGesture.locationInView(self)
        var menu: RCBaseMenu = self.menus[self.menus.endIndex - 1]
        if !CGRectContainsPoint(menu.frame, touchPoint) {
            self.dismissMenu(menu, Animated: true)
            if let _ = self.menus.indexOf(menu){
                self.menus.removeAtIndex(self.menus.indexOf(menu)!)
            }
        }
    }
    
    
    override public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isEqual(self.tapGesture) {
            var p: CGPoint = gestureRecognizer.locationInView(self)
            var topMenu: RCBaseMenu = self.menus[self.menus.endIndex - 1]
            if CGRectContainsPoint(topMenu.frame, p) {
                return false
            }
        }
        return true
    }
    
    func setMenu(menu: UIView, animation animated: Bool) {
        if let view = self.superview { } else {
            var window: UIWindow! = UIApplication.sharedApplication().keyWindow
            window.addSubview(self)
        }
        var topMenu: RCBaseMenu = (menu as! RCBaseMenu)
        self.menus.forEach { $0.removeFromSuperview() }
        self.menus.append(topMenu)
        topMenu.style = self.style
        
        self.addSubview(topMenu)
        topMenu.layoutIfNeeded()
        topMenu.frame = CGRect(origin: CGPointMake(0, self.bounds.size.height - topMenu.bounds.size.height), size: topMenu.bounds.size)
        if animated && self.menus.count == 1 {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.2)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
            self.layer.addAnimation(self.dimingAnimation(), forKey: "diming")
            topMenu.layer.addAnimation(self.showMenuAnimation(), forKey: "showMenu")
            CATransaction.commit()
        }
    }
    
    func dismissMenu(menu: RCBaseMenu, Animated animated: Bool) {
        if let _ = self.superview {
            self.menus.removeAtIndex(self.menus.indexOf(menu)!)
            if animated && self.menus.count == 0 {
                CATransaction.begin()
                CATransaction.setAnimationDuration(0.2)
                CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn))
                CATransaction.setCompletionBlock({
                    self.removeFromSuperview()
                    menu.removeFromSuperview()
                })
                self.layer.addAnimation(self.lightingAnimation(), forKey: "lighting")
                menu.layer.addAnimation(self.dismissMenuAnimation(), forKey: "dismissMenu")
                CATransaction.commit()
            }
            else {
                menu.removeFromSuperview()
                var topMenu: RCBaseMenu = self.menus[self.menus.endIndex - 1]
                topMenu.style = self.style
                self.addSubview(topMenu)
                topMenu.layoutIfNeeded()
                topMenu.frame = CGRect(origin: CGPointMake(0, self.bounds.size.height - topMenu.bounds.size.height), size: topMenu.bounds.size)
                
            }
        }
    }
    
    func dimingAnimation() -> CAAnimation {
        if let _ = _dimingAnimation { } else{
            var opacityAnimation: CABasicAnimation = CABasicAnimation(keyPath: "backgroundColor")
            opacityAnimation.fromValue = (UIColor(white: 0.0, alpha: 0.0).CGColor as! AnyObject)
            opacityAnimation.toValue = (UIColor(white: 0.0, alpha: 0.4).CGColor as! AnyObject)
            opacityAnimation.removedOnCompletion = false
            opacityAnimation.fillMode = kCAFillModeBoth
            _dimingAnimation = opacityAnimation
        }
        return _dimingAnimation!
    }
    
    func lightingAnimation() -> CAAnimation {
        if let _ = _lightingAnimation { } else{
            var opacityAnimation: CABasicAnimation = CABasicAnimation(keyPath: "backgroundColor")
            opacityAnimation.fromValue = (UIColor(white: 0.0, alpha: 0.4).CGColor as! AnyObject)
            opacityAnimation.toValue = (UIColor(white: 0.0, alpha: 0.0).CGColor as! AnyObject)
            opacityAnimation.removedOnCompletion = false
            opacityAnimation.fillMode = kCAFillModeBoth
            _lightingAnimation = opacityAnimation
        }
        return _lightingAnimation!
    }
    
    func showMenuAnimation() -> CAAnimation {
        if let _ = _showMenuAnimation {} else{
            var rotateAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform")
            var t: CATransform3D = CATransform3DIdentity
            t.m34 = 1 / -500.0
            var from: CATransform3D = CATransform3DRotate(t, -30.0 * CGFloat(M_PI) / 180.0, 1, 0, 0)
            var to: CATransform3D = CATransform3DIdentity
            rotateAnimation.fromValue = NSValue(CATransform3D: from)
            rotateAnimation.toValue = NSValue(CATransform3D: to)
            var scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 0.9
            scaleAnimation.toValue = 1.0
            var positionAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y")
            positionAnimation.fromValue = Int(50.0)
            positionAnimation.toValue = Int(0.0)
            var opacityAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 0.0
            opacityAnimation.toValue = 1.0
            var group: CAAnimationGroup = CAAnimationGroup()
            group.animations = [rotateAnimation, scaleAnimation, opacityAnimation, positionAnimation]
            group.removedOnCompletion = false
            group.fillMode = kCAFillModeBoth
            _showMenuAnimation = group
        }
        return _showMenuAnimation!
    }
    
    
    func dismissMenuAnimation() -> CAAnimation {
        if let _ = _dismissMenuAnimation {} else{
            var rotateAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform")
            var t: CATransform3D = CATransform3DIdentity
            t.m34 = 1 / -500.0
            var from: CATransform3D = CATransform3DIdentity
            var to: CATransform3D = CATransform3DRotate(t, -30.0 * CGFloat(M_PI) / 180.0, 1, 0, 0)
            rotateAnimation.fromValue = NSValue(CATransform3D: from)
            rotateAnimation.toValue = NSValue(CATransform3D: to)
            var scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 1.0
            scaleAnimation.toValue = 0.9
            var positionAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.y")
            positionAnimation.fromValue = Int(0.0)
            positionAnimation.toValue = Int(50.0)
            var opacityAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 1.0
            opacityAnimation.toValue = 0.0
            var group: CAAnimationGroup = CAAnimationGroup()
            group.animations = [rotateAnimation, scaleAnimation, opacityAnimation, positionAnimation]
            group.removedOnCompletion = false
            group.fillMode = kCAFillModeBoth
            _dismissMenuAnimation = group
        }
        return _dismissMenuAnimation!
    }
    
    public func showAlertWithTitle(title: String, message: String, leftButtonTitle leftTitle: String, rightButtonTitle rightTitle: String, selectedHandle handler: RCMenuActionHandler?) {
        var menu: RCAlertMenu = RCAlertMenu(title: title, message: message, buttonTitles: [leftTitle, rightTitle], style: self.style)
        menu.triggerSelectedAction({(index: Int) -> Void in
            self.dismissMenu(menu, Animated: true)
            if handler != nil {
                handler!(index: index)
            }
        })
        self.setMenu(menu, animation: true)
    }
    
    
    public func showSheetWithTitle(title: String, itemTitles: [String], selectedIndex: Int, selectedHandle handler: RCMenuActionHandler?) {
        var menu: RCSheetMenu = RCSheetMenu(title: title, itemTitles: itemTitles, style: self.style)
        menu.selectedItemIndex = selectedIndex
        menu.triggerSelectedAction({(index: Int) -> Void in
            self.dismissMenu(menu, Animated: true)
            if handler != nil {
                handler!(index: index)
            }
        })
        self.setMenu(menu, animation: true)
    }
    
    public func showSheetWithTitle(title: String, itemTitles: [String], itemSubTitles: [String], selectedIndex: Int, selectedHandle handler: RCMenuActionHandler?) {
        var menu: RCSheetMenu = RCSheetMenu(title: title, itemTitles: itemTitles, subTitles: itemSubTitles, style: self.style)
        menu.selectedItemIndex = selectedIndex
        menu.triggerSelectedAction({(index: Int) -> Void in
            self.dismissMenu(menu, Animated: true)
            if handler != nil {
                handler!(index: index)
            }
        })
        self.setMenu(menu, animation: true)
    }
    
    
    public func showGridMenuWithTitle(title: String, itemTitles: [String], images: [UIImage], selectedHandle handler: RCMenuActionHandler?) {
        var menu: RCGridMenu = RCGridMenu(title: title, itemTitles: itemTitles, images: images, style: self.style)
        menu.triggerSelectedAction({(index: Int) -> Void in
            self.dismissMenu(menu, Animated: true)
            if handler != nil {
                handler!(index: index)
            }
        })
        self.setMenu(menu, animation: true)
        
    }
    
}
