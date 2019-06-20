//
//  Created by Ashish on 20/07/15.
//  Copyright © 2015 Ashish. All rights reserved.
//

import UIKit

public extension UIView {
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var shadowColor:  UIColor? {
        set {
            layer.masksToBounds =  false
            layer.shadowColor = newValue?.cgColor
            layer.shadowRadius = 2
            layer.shadowOffset = CGSize.zero//CGSize(width: 2, height: 2)
            layer.shadowOpacity = 0.8
        }
        get {
            guard let color = layer.shadowColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    
    public class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    public class func loadNib() -> Self {
        return loadNib(self)
    }
    
    public func getSnapshot(_ view: UIView) -> UIImage {
        
        var captureImage: UIImage
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, UIScreen.main.scale)
        
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        
        captureImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return captureImage
    }
    
    public func getSnapshot() -> UIImage {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    public func screenshot() -> UIImage {
        return UIGraphicsImageRenderer(size: bounds.size).image { _ in
            drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
        }
    }
    
    public func getSnapshotWithSize(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        //Originaly ------self.bounds
        //For viewcontroller ------- Only
        var rect:CGRect = self.bounds
        rect.origin.y = -64
        drawHierarchy(in: rect, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    public func makeBlurView(_ view: UIView, effectStyle: UIBlurEffectStyle) {
        
        let blurEffect = UIBlurEffect(style: effectStyle) //UIBlurEffectStyle.Light
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        view.addSubview(blurEffectView)
    }
    
    public var width:      CGFloat { return self.frame.size.width }
    public var height:     CGFloat { return self.frame.size.height }
    public var size:       CGSize  { return self.frame.size}
    
    public var origin:     CGPoint { return self.frame.origin }
    public var x:          CGFloat { return self.frame.origin.x }
    public var y:          CGFloat { return self.frame.origin.y }
    public var centerX:    CGFloat { return self.center.x }
    public var centerY:    CGFloat { return self.center.y }
    
    public var left:       CGFloat { return self.frame.origin.x }
    public var right:      CGFloat { return self.frame.origin.x + self.frame.size.width }
    public var top:        CGFloat { return self.frame.origin.y }
    public var bottom:     CGFloat { return self.frame.origin.y + self.frame.size.height }
    
    public func setWidth(_ width:CGFloat) {
        self.frame.size.width = width
    }
    
    public func setHeight(_ height:CGFloat) {
        self.frame.size.height = height
    }
    
    public func setSize(_ size:CGSize) {
        self.frame.size = size
    }
    
    public func setOrigin(_ point:CGPoint) {
        self.frame.origin = point
    }
    
    public func setX(_ x:CGFloat) {
        //only change the origin x
        self.frame.origin = CGPoint(x: x, y: self.frame.origin.y)
    }
    
    public func setY(_ y:CGFloat) {
        //only change the origin x
        self.frame.origin = CGPoint(x: self.frame.origin.x, y: y)
    }
    
    public func setCenterX(_ x:CGFloat) {
        //only change the origin x
        self.center = CGPoint(x: x, y: self.center.y)
    }
    
    public func setCenterY(_ y:CGFloat) {
        //only change the origin x
        self.center = CGPoint(x: self.center.x, y: y)
    }
    
    public func roundCorner(_ radius:CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    public func setTop(_ top:CGFloat) {
        self.frame.origin.y = top
    }
    
    public func setLeft(_ left:CGFloat) {
        self.frame.origin.x = left
    }
    
    public func setRight(_ right:CGFloat) {
        self.frame.origin.x = right - self.frame.size.width
    }
    
    public func setBottom(_ bottom:CGFloat) {
        self.frame.origin.y = bottom - self.frame.size.height
    }
    
    func makeCircular() {
        let cntr:CGPoint = self.center
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.center = cntr
       // self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    func makeCircular1() {
        let cntr:CGPoint = self.center
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.center = cntr
        // self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    func makeCircularWithShadow() {
        let cntr:CGPoint = self.center
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.layer.shadowColor = UIColor.appRed.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 0.5
        
        self.center = cntr
        
        self.clipsToBounds = true
    }
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 2
        
        //        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        //        self.layer.shouldRasterize = true
        //        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
    public func drawPolygon(strokeWidth width: CGFloat?, strokeColor: UIColor?) {
        
        layer.sublayers?
            .filter  { $0.name == "Polygon" }
            .forEach { $0.removeFromSuperlayer() }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        shapeLayer.name = "Polygon"
        shapeLayer.path = UIBezierPath().getPolygon(self.frame, scale: 1, sides: 4).cgPath
        
        shapeLayer.fillRule = kCAFillRuleNonZero
        self.layer.mask = shapeLayer
        
        if let width = width, let color = strokeColor {
            shapeLayer.lineWidth = width
            shapeLayer.strokeColor = color.cgColor
            //shapeLayer.fillColor = COLOR_BLACK.CGColor
        }
    }
    
    //  MARK:- Get view's parent view controller
    public var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    //  MARK:- Add Visual Format constraints.
    ///
    /// - Parameters:
    ///   - withFormat: visual Format language
    ///   - views: array of views which will be accessed starting with index 0 (example: [v0], [v1], [v2]..)
    @available(iOS 9, *) public func addConstraints(withFormat: String, views: UIView...) {
        // https://videos.letsbuildthatapp.com/
        var viewsDictionary: [String: UIView] = [:]
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: withFormat, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    //  MARK:- Anchor all sides of the view into it's superview.
    @available(iOS 9, *) public func fillToSuperview() {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
}

extension UIView {
    
    /// Flip view horizontally.
    func flipX() {
        transform = CGAffineTransform(scaleX: -transform.a, y: transform.d)
    }
    func flipCustomX() {
        transform = CGAffineTransform(a: transform.a, b: transform.b, c: -transform.c, d: transform.d, tx: transform.tx, ty: transform.ty)
    }
    
    /// Flip view vertically.
    func flipY() {
        transform = CGAffineTransform(scaleX: transform.a, y: -transform.d)
    }
    
}

extension UIView {
    
    func startBlink() {
        UIView.animate(withDuration: 0.8,
                       delay:0.0,
                       options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
                       animations: { self.alpha = 0 },
                       completion: nil)
    }
    
    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
    
    func startShine() {
        self.layer.shadowColor = UIColor.yellow.cgColor
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = .zero
        UIView.animate(withDuration: 0.7, delay: 0, options: [.autoreverse, .curveEaseInOut, .repeat, .allowUserInteraction], animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: {(finished: Bool) -> Void in
            self.layer.shadowRadius = 0.0
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
}

extension UIView {
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.layer.add(animation, forKey: nil)
    }
    
}

extension UIView {
    
    func slideWithTransition(type: String, duration: TimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        // Create a CATransition animation
        let slideInFromLeftTransition = CATransition()
        
        // Set its callback delegate to the completionDelegate that was provided (if any)
        /*if let delegate = completionDelegate { //uncomment this line when use
            slideInFromLeftTransition.delegate = delegate
        }*/
        
        // Customize the animation's properties
        slideInFromLeftTransition.type = kCATransitionPush
        slideInFromLeftTransition.subtype = type
        //kCATransitionFromTop, kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromBottom
        
        slideInFromLeftTransition.duration = duration
        slideInFromLeftTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideInFromLeftTransition.fillMode = kCAFillModeRemoved
        
        // Add the animation to the View's layer
        if type == kCATransitionFromRight {
            self.layer.add(slideInFromLeftTransition, forKey: "slideInFromRightTransition")
        } else if type == kCATransitionFromLeft {
            self.layer.add(slideInFromLeftTransition, forKey: "slideInFromLeftTransition")
        } else if type == kCATransitionFromTop {
            self.layer.add(slideInFromLeftTransition, forKey: "slideInFromTopTransition")
        } else if type == kCATransitionFromBottom {
            self.layer.add(slideInFromLeftTransition, forKey: "slideInFromBottomTransition")
        } else {
        }
    }
}


extension UIView {
    
    func setGradient(colours: [UIColor]) -> Void {
        self.setGradient(colours: colours, locations: nil)
    }
    
    func setGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func linearGradient(with color1:UIColor, color2:UIColor, vertical:Bool = false, firstColorRatio:Double = 0.5) {
        
        let gradientLayer       = CAGradientLayer()
        gradientLayer.frame     = self.bounds
        gradientLayer.colors    = [color1.cgColor, color1.cgColor]
        
        if vertical {
            gradientLayer.startPoint = CGPoint(x:0.5, y:0.0)
            gradientLayer.endPoint  = CGPoint(x:0.5, y:1.0)
        }else {
            gradientLayer.startPoint = CGPoint(x:0.0, y:0.5)
            gradientLayer.endPoint = CGPoint(x:1.0, y:0.5)
        }
        let value:Double  = 1.0 - firstColorRatio
        gradientLayer.locations = [1, 0]
        gradientLayer.locations = [0.0, NSNumber(floatLiteral: value)]
        self.layer.addSublayer(gradientLayer)
        
    }
}

public class RadialGradientLayer: CALayer {
    
    public var center:CGPoint = CGPoint.zero
    public var radius:CGFloat = 0
    public var colors = [UIColor]()
    
    required override public init() {
        super.init()
        needsDisplayOnBoundsChange = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override public init(layer: Any) {
        super.init(layer: layer)
    }

    override public func draw(in ctx: CGContext) {
        ctx.saveGState()
        
        let colorSpace  = CGColorSpaceCreateDeviceRGB()
        var locations   = [CGFloat]()
        for i in 0...colors.count-1 {
            locations.append(CGFloat(i) / CGFloat(colors.count))
        }
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        let center = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        let radius = min(bounds.width / 2.0, bounds.height / 2.0)
        ctx.drawRadialGradient(gradient!, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: radius, options: CGGradientDrawingOptions(rawValue: 0))
    }
}

//  MARK:- Add Gradient to UIView.
///
/// - Parameters:
/// - Make sure the UIView is of type GradientView in IB means class name
///   view.gradientLayer.colors = [UIColor.black.cgColor, UIColor.white.cgColor]
///   view.gradientLayer.gradient = GradientPoint.rightLeft.draw()
typealias GradientType = (x: CGPoint, y: CGPoint)

enum GradientPoint {
    case leftRight
    case rightLeft
    case topBottom
    case bottomTop
    case topLeftBottomRight
    case bottomRightTopLeft
    case topRightBottomLeft
    case bottomLeftTopRight
    
    func draw() -> GradientType {
        switch self {
        case .leftRight:
            return (x: CGPoint(x: 0, y: 0.5), y: CGPoint(x: 1, y: 0.5))
        case .rightLeft:
            return (x: CGPoint(x: 1, y: 0.5), y: CGPoint(x: 0, y: 0.5))
        case .topBottom:
            return (x: CGPoint(x: 0.5, y: 0), y: CGPoint(x: 0.5, y: 1))
        case .bottomTop:
            return (x: CGPoint(x: 0.5, y: 1), y: CGPoint(x: 0.5, y: 0))
        case .topLeftBottomRight:
            return (x: CGPoint(x: 0, y: 0), y: CGPoint(x: 1, y: 1))
        case .bottomRightTopLeft:
            return (x: CGPoint(x: 1, y: 1), y: CGPoint(x: 0, y: 0))
        case .topRightBottomLeft:
            return (x: CGPoint(x: 1, y: 0), y: CGPoint(x: 0, y: 1))
        case .bottomLeftTopRight:
            return (x: CGPoint(x: 0, y: 1), y: CGPoint(x: 1, y: 0))
        }
    }
}

class GradientLayer : CAGradientLayer {
    var gradient: GradientType? {
        didSet {
            startPoint = gradient?.x ?? CGPoint.zero
            endPoint = gradient?.y ?? CGPoint.zero
        }
    }
}

class GradientView: UIView {
    override public class var layerClass: Swift.AnyClass {
        get {
            return GradientLayer.self
        }
    }
}

protocol GradientViewProvider {
    associatedtype GradientViewType
}

extension GradientViewProvider where Self: UIView {
    var gradientLayer: GradientViewType {
        return layer as! GradientViewType
    }
}

extension UIView: GradientViewProvider {
    typealias GradientViewType = GradientLayer
}

extension UIView {
    
    // Example use: myView.setBorder(edge: .left, withColor: UIColor.redColor().CGColor, thickness: 1.0)
    
    enum edge {
        case left, right, top, bottom
    }
    
    func setBorder(edge side: edge, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
        case .top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
}

/*extension MapSearchVC  {
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        print("Animation stopped")
    }
}

NOTE: Call from your view controller when hide show

filterView?.hidden = hidden
//filterView.slideWithTransition(kCATransitionFromBottom)
filterView.slideWithTransition(kCATransitionFromLeft, duration: 1.0, completionDelegate: self)
}*/

//view.layer.setBorder
extension CALayer {
    
    func setBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        addSublayer(border)
    }
}

private var GLOWVIEW_KEY = "GLOWVIEW"

extension UIView {
    var glowView: UIView? {
        get {
            return objc_getAssociatedObject(self, &GLOWVIEW_KEY) as? UIView
        }
        set(newGlowView) {
            objc_setAssociatedObject(self, &GLOWVIEW_KEY, newGlowView!, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func startGlowingWithColor(color:UIColor, intensity:CGFloat) {
        self.startGlowingWithColor(color: color, fromIntensity: 0.1, toIntensity: intensity, repeat: true)
    }
    
    func startGlowingWithColor(color:UIColor, fromIntensity:CGFloat, toIntensity:CGFloat, repeat shouldRepeat:Bool) {
        // If we're already glowing, don't bother
        if self.glowView != nil {
            return
        }
        
        // The glow image is taken from the current view's appearance.
        // As a side effect, if the view's content, size or shape changes,
        // the glow won't update.
        var image:UIImage
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale); do {
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            
            let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            
            color.setFill()
            
            path.fill(with: .sourceAtop, alpha:1.0)
            
            
            image = UIGraphicsGetImageFromCurrentImageContext()!
        }
        
        UIGraphicsEndImageContext()
        
        // Make the glowing view itself, and position it at the same
        // point as ourself. Overlay it over ourself.
        let glowView = UIImageView(image: image)
        glowView.center = self.center
        self.superview!.insertSubview(glowView, aboveSubview:self)
        
        // We don't want to show the image, but rather a shadow created by
        // Core Animation. By setting the shadow to white and the shadow radius to
        // something large, we get a pleasing glow.
        glowView.alpha = 0
        glowView.layer.shadowColor = color.cgColor
        glowView.layer.shadowOffset = CGSize.zero
        glowView.layer.shadowRadius = 10
        glowView.layer.shadowOpacity = 1.0
        
        // Create an animation that slowly fades the glow view in and out forever.
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = fromIntensity
        animation.toValue = toIntensity
        animation.repeatCount = shouldRepeat ? .infinity : 0 // HUGE_VAL = .infinity / Thanks http://stackoverflow.com/questions/7082578/cabasicanimation-unlimited-repeat-without-huge-valf
        animation.duration = 1.0
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        glowView.layer.add(animation, forKey: "pulse")
        
        // Finally, keep a reference to this around so it can be removed later
        self.glowView = glowView
    }
    
    func glowOnceAtLocation(point: CGPoint, inView view:UIView) {
        self.startGlowingWithColor(color: UIColor.white, fromIntensity: 0, toIntensity: 0.6, repeat: false)
        
        self.glowView!.center = point
        view.addSubview(self.glowView!)
        
        let delay: Double = 2 * Double(Int64(NSEC_PER_SEC))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.stopGlowing()
        }
    }
    
    func glowOnce() {
        self.startGlowing()
        
        let delay: Double = 2 * Double(Int64(NSEC_PER_SEC))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            self.stopGlowing()
        }
        
    }
    
    // Create a pulsing, glowing view based on this one.
    func startGlowing() {
        self.startGlowingWithColor(color: UIColor.yellow, intensity:0.6);
    }
    
    // Stop glowing by removing the glowing view from the superview
    // and removing the association between it and this object.
    func stopGlowing() {
        self.glowView!.removeFromSuperview()
        self.glowView = nil
    }
    
}

extension UIView
{
    // different inner shadow styles
    public enum innerShadowSide
    {
        case all, left, right, top, bottom, topAndLeft, topAndRight, bottomAndLeft, bottomAndRight, exceptLeft, exceptRight, exceptTop, exceptBottom
    }
    
    // define function to add inner shadow
    public func setInnerShadow(onSide: innerShadowSide, shadowColor: UIColor = UIColor.darkGray, shadowSize: CGFloat = 2.0, shadowOpacity: Float = 0.8)
    {
        // define and set a shaow layer
        let shadowLayer = CAShapeLayer()
        shadowLayer.frame = bounds
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowLayer.shadowOpacity = shadowOpacity
        shadowLayer.shadowRadius = shadowSize
        shadowLayer.fillRule = kCAFillRuleEvenOdd
        
        // define shadow path
        let shadowPath = CGMutablePath()
        
        // define outer rectangle to restrict drawing area
        let insetRect = bounds.insetBy(dx: -shadowSize * 2.0, dy: -shadowSize * 2.0)
        
        // define inner rectangle for mask
        let innerFrame: CGRect = { () -> CGRect in
            switch onSide
            {
            case .all:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height)
            case .left:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
            case .right:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 4.0)
            case .top:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
            case.bottom:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 4.0, height: frame.size.height + shadowSize * 2.0)
            case .topAndLeft:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .topAndRight:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .bottomAndLeft:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .bottomAndRight:
                return CGRect(x: -shadowSize * 2.0, y: -shadowSize * 2.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height + shadowSize * 2.0)
            case .exceptLeft:
                return CGRect(x: -shadowSize * 2.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
            case .exceptRight:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width + shadowSize * 2.0, height: frame.size.height)
            case .exceptTop:
                return CGRect(x: 0.0, y: -shadowSize * 2.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
            case .exceptBottom:
                return CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height + shadowSize * 2.0)
            }
        }()
        
        // add outer and inner rectangle to shadow path
        shadowPath.addRect(insetRect)
        shadowPath.addRect(innerFrame)
        
        // set shadow path as show layer's
        shadowLayer.path = shadowPath
        
        // add shadow layer as a sublayer
        layer.addSublayer(shadowLayer)
        
        // hide outside drawing area
        clipsToBounds = true
    }
}
