//
//  RCBaseMenu.swift
//  Pods
//
//  Created by Rodrigo on 10/06/2016.
//
//

import Foundation
import QuartzCore


class RCButton: UIButton {
    
    override var highlighted: Bool {
        willSet(newValue) {
            super.selected = newValue;
            highlight(newValue)
        }
    }
    
    func highlight(highlighted: Bool) {
        if highlighted {
            self.backgroundColor = UIColor.lightGrayColor()
        }
        else {
            var delayInSeconds: Double = 0.2
            var popTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, dispatch_get_main_queue(), {() -> Void in
                self.backgroundColor = UIColor.clearColor()
            })
        }
    }
}

class RCBaseMenu: UIView {
    
    var roundedCorner: Bool?
    var style: RCActionViewStyle
    
    override init(frame: CGRect) {
        self.style = .Light
        super.init(frame: frame)
        
        setRoundedCorner(self.nicePerformance())
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    static func BaseMenuBackgroundColor(style:RCActionViewStyle?) -> UIColor{
        if (style == RCActionViewStyle.Light){
            return UIColor(white: 1.0, alpha: 1.0)
        } else{
            return UIColor(white: 0.2, alpha: 1.0)
        }
    }
    
    static func BaseMenuTextColor(style:RCActionViewStyle?) -> UIColor{
        if (style == RCActionViewStyle.Light){
            return UIColor.darkTextColor()
        } else{
            return UIColor.lightTextColor()
        }
    }
    
    static func BaseMenuActionTextColor() -> UIColor{
        return UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
    }
    
    
    
    func setRoundedCorner(roundedCorner: Bool) {
        if roundedCorner {
            var path: UIBezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.TopLeft, .TopRight], cornerRadii: CGSizeMake(8, 8))
            var maskLayer: CAShapeLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.CGPath
            self.layer.mask = maskLayer
        }
        else {
            self.layer.mask = nil
        }
        self.roundedCorner = roundedCorner
        self.setNeedsDisplay()
    }
    
    func nicePerformance() -> Bool {
        var size : Int = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var name = [CChar](count: Int(size), repeatedValue: 0)
        sysctlbyname("hw.machine", &name, &size, nil, 0)
        var machine: NSString = String.fromCString(name)!
        
        var b: Bool = true
        if machine.hasPrefix("iPhone") {
            b = CInt(machine.substringWithRange(NSRange(location: 6, length: 1)))! >= 4
        }
        else if machine.hasPrefix("iPod") {
            b = CInt(machine.substringWithRange(NSMakeRange(4, 1)))! >= 5
        }
        else if machine.hasPrefix("iPad") {
            b = CInt(machine.substringWithRange(NSMakeRange(4, 1)))! >= 2
        }
        
        return b
    }
    
    
    
}
