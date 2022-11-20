//
//  DesignableButton.swift
//  SkyApp
//
//  Created by Mark Moeykens on 12/18/16.
//  Copyright © 2016 Mark Moeykens. All rights reserved.
//

import UIKit

@IBDesignable
class UIButtonX: UIButton, UIActionSheetDelegate {
    
    enum FromDirection:Int {
        case Top = 0
        case Right = 1
        case Bottom = 2
        case Left = 3
    }
    
    var shadowView: UIView!
    var direction: FromDirection = .Left
    var shapeLayer: CAShapeLayer!
    var alphaBefore: CGFloat = 1
    var actionSheet: UIView!
    
    @IBInspectable var animate: Bool = false
    @IBInspectable var animateDelay: Double = 0.2
    @IBInspectable var animateFrom: Int {
        get {
            return direction.rawValue
        }
        set (directionIndex) {
            direction = FromDirection(rawValue: directionIndex) ?? .Left
        }
    }
    
    @IBInspectable var popIn: Bool = false
    @IBInspectable var popInDelay: Double = 0.4
    
    @IBInspectable var offset: CGFloat = 0 {
           didSet {
            configureShapeLayer()
           }
       }
    
    @IBInspectable var bezierPathY: CGFloat = 0 {
        didSet {
         configureShapeLayer()
        }
    }
    
     @IBInspectable var bezierPath_width: CGFloat = 0 {
               didSet {
                configureShapeLayer()
               }
           }
    
    
    func addShapeLayerbelowView(offset:CGFloat, bezierPath_width:CGFloat){
           
           let path = UIBezierPath()
        
        var startPoint:CGPoint?
        var endPoint:CGPoint?
        //let y = self.frame.origin.y
      
//            print(self.frame.origin.x)
//            startPoint = CGPoint(x: self.frame.origin.x, y: bezierPathY)
//            print(startPoint!.x+bezierPath_width-offset)
//            endPoint = CGPoint(x: startPoint!.x+bezierPath_width-offset, y: bezierPathY)
//            
            startPoint = CGPoint(x: self.frame.origin.x, y: bezierPathY)
                       print(startPoint!.x)
            endPoint = CGPoint(x: (startPoint!.x+self.frame.width)-offset, y: bezierPathY)
    
    
        
        path.move(to: startPoint!)
        path.addLine(to: endPoint!)
           
           //        let path2 = UIBezierPath(roundedRect: view.bounds, cornerRadius: 15.0)
           
           shapeLayer = CAShapeLayer()
           shapeLayer.path = path.cgPath
           shapeLayer.strokeColor = #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)
           shapeLayer.fillColor = UIColor.clear.cgColor
         //  shapeLayer.setAffineTransform(CGAffineTransform(rotationAngle: -.pi))
        self.layer.addSublayer(shapeLayer)
       }
    
    func configureShapeLayer(){
     
    
        guard let shape_Layer = shapeLayer else {
         
            addShapeLayerbelowView(offset: offset, bezierPath_width: bezierPath_width)
            return
        }
     
        shape_Layer.removeFromSuperlayer()
        addShapeLayerbelowView(offset: offset, bezierPath_width: bezierPath_width)
    }
    
    @IBInspectable var isBttnPressed: Bool = false{
        didSet {
            showActionSheet()
        }
    }
   
    @IBInspectable var ActionSheetViewID: Int = 120{
           didSet {
               showActionSheet()
           }
       }
    
    
     func showActionSheet(){
        
        if (actionSheet != nil) {

           actionSheet.removeFromSuperview()
        }
//
//         actionSheet = UIActionSheet.init(title: nil, delegate: self, cancelButtonTitle: "cancel", destructiveButtonTitle: nil, otherButtonTitles: "call \(self.titleLabel?.text!)")
//
//        let view = recurseToFindSuperView(with: ActionSheetViewID, view: superview!)
//
//
//        actionSheet.translatesAutoresizingMaskIntoConstraints = false
//       // actionSheet.backgroundColor = UIColor.gray
//        print(actionSheet.frame.height)
//        actionSheet.frame = CGRect.init(x: 0,
//                                        y: view.bounds.height-100,
//                                        width: view.bounds.width,
//        height: 100)
//        view.addSubview(actionSheet)
//
    }
    
    
    override func draw(_ rect: CGRect) {
        self.clipsToBounds = true
        
        if animate {
            let originalFrame = frame
            
            if direction == .Bottom {
                frame = CGRect(x: frame.origin.x, y: frame.origin.y + 200, width: frame.width, height: frame.height)
            }
            
            UIView.animate(withDuration: 0.3, delay: animateDelay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                self.frame = originalFrame
            }, completion: nil)
        }
        
        if popIn {
            transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.8, delay: popInDelay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        
        if shadowView == nil && shadowOpacity > 0 {
            shadowView = UIView(frame: self.frame)
            shadowView.backgroundColor = UIColor.clear
            shadowView.layer.shadowColor = shadowColor.cgColor
            shadowView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius).cgPath
            shadowView.layer.shadowOffset = shadowOffset
            shadowView.layer.shadowOpacity = Float(shadowOpacity)
            shadowView.layer.shadowRadius = shadowRadius
            shadowView.layer.masksToBounds = true
            shadowView.clipsToBounds = false
            
            self.superview?.addSubview(shadowView)
            self.superview?.bringSubviewToFront(self)
        }
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        alphaBefore = alpha
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
            self.alpha = 0.4
        })
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        UIView.animate(withDuration: 0.35, delay: 0, options: .allowUserInteraction, animations: {
            self.alpha = self.alphaBefore
        })
    }
    
    // MARK: - Borders
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    // MARK: - Shadow
    
    @IBInspectable public var shadowOpacity: CGFloat = 0
    @IBInspectable public var shadowColor: UIColor = UIColor.clear
    @IBInspectable public var shadowRadius: CGFloat = 0
    @IBInspectable public var shadowOffset: CGSize = CGSize(width: 0, height: 0)
    
    
   //    MARK: - Gradient
    @IBInspectable var firstColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var secondColor: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var horizontalGradient: Bool = false {
        didSet {
            updateView()
        }
    }
    
    override public class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [ firstColor.cgColor, secondColor.cgColor ]
        
        if (horizontalGradient) {
            layer.startPoint = CGPoint(x: 0.0, y: 0.5)
            layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 0, y: 1)
        }
    }
}
