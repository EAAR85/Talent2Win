//
// ViewExtension.swift
// demo
//
// Created by Elvis on 2/01/23.
// Copyright (c) 2022. All rights reserved.
//



import Foundation
import UIKit


@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

extension UIView {
    
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}

extension UIView {
    
    func addDashedBorder() {
        let color = UIColor.lightGray.cgColor
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,6]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        self.layer.addSublayer(shapeLayer)
        
    }
    
}

class CustomDashedView: UIView {
    
    @IBInspectable var cornerRadiusView: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0
    
    var dashBorder: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}


extension NSMutableAttributedString {
    
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
}


extension UIView {
    
    func zoomAnimation(){
        zoomIn()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.zoomOut()
        }
    }
    
    
    private func zoomIn(){
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        })
    }
    
    private func zoomOut(){
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    func leftToRightAnimation(){
        UIView.animate(withDuration: 0.5, animations: {
            let animation = CATransition()
            animation.isRemovedOnCompletion = true
            animation.duration = 0.3
            animation.autoreverses = true
            animation.type = CATransitionType.push
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            self.layer.add(animation,  forKey: "changeTextTransition")
        })
    }
    
    func flipAnimation(){
        UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        //UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    

    func skipAnimation(){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { (finished: Bool) -> Void in
            // wait for first animation to complete
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            }, completion: { (finished: Bool) -> Void in
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion: { (finished: Bool) -> Void in
                    if (finished)
                    {
                        //self.removeFromSuperview()
                    }
                })
                
            })
        })
    }
    
    func selectAnimation(){
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }, completion: { (finished: Bool) -> Void in
            // wait for first animation to complete
            UIView.animate(withDuration: 0.2, animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: { (finished: Bool) -> Void in
               
                
            })
        })
    }
}


extension UIView {
    public func setGradientBackground() {
        let l = CAGradientLayer()
        l.frame = self.bounds
        l.colors = [UIColor.systemCyan.cgColor, UIColor.white.cgColor]
        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = 8
        self.layer.insertSublayer(l, at: 0)
    }
}


