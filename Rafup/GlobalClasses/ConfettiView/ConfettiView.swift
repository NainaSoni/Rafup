//
//  ConfettiView.swift
//  Rafup
//
//  Created by Ashish on 16/08/18.
//  Copyright © 2018 Ashish Soni. All rights reserved.
//

import UIKit
import QuartzCore

public class ConfettiView: UIView {

    public enum ConfettiType {
        case confetti
        case circle
        case rectangle
        case triangle
        case spiral
        case star
        case diamond
        case image(UIImage)
    }
    
    //CAEmitterLayer is a high-performance particle engine designed to create particle animations such as fire, rain, smoke, snow, etc.
    var emitter: CAEmitterLayer!
    public var colors: [UIColor]!
    public var images:[UIImage]!
    public var intensity: Float!
    public var isMultiImages :Bool!
    public var type: ConfettiType!
    private var active :Bool!
    private var indexValue: Int = 0
    private var index: Int {
        get { indexValue = indexValue + 1
            return indexValue }
        set {
            indexValue = newValue
        }
    }
    
    private var velocities:[Int] = [
        100,
        90,
        150,
        200
    ]
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        colors = [UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
                  UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
                  UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
                  UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
                  UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)]
        
         images = [self.imageForType(type: .rectangle),
                   self.imageForType(type: .triangle),
                   self.imageForType(type: .circle),
                   self.imageForType(type: .spiral)
            ] as! [UIImage]
        
        intensity = 0.5
        type = .confetti
        active = false
        isMultiImages = false
    }
    
    public func startConfetti() {
        emitter = CAEmitterLayer()
        
        emitter.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: -10)
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterSize = CGSize(width: frame.size.width, height: 2.0) //1
        
        var cells = [CAEmitterCell]()
        for color in colors {
            cells.append(confettiWithColor(color: color))
        }
        
        emitter.emitterCells = cells
        layer.addSublayer(emitter)
        active = true
    }
    
    public func stopConfetti() {
        emitter?.birthRate = 0
        active = false
        isMultiImages = false
    }
    
    func imageForType(type: ConfettiType) -> UIImage? {
        
        var fileName: String!
        
        switch type {
        case .confetti:
            fileName = "confetti"
        case .triangle:
            fileName = "triangle"
        case .star:
            fileName = "star"
        case .diamond:
            fileName = "diamond"
        case .circle:
            fileName = "Circle"
        case .rectangle:
            fileName = "Box"
        case .spiral:
            fileName = "Spiral"
        case let .image(customImage):
            return customImage
        }
        return UIImage(named: fileName)
    }
    
    func confettiWithColor(color: UIColor) -> CAEmitterCell {
        let confetti = CAEmitterCell()
        if isMultiImages {
            confetti.birthRate = 4.0
            confetti.lifetime = 14.0
            confetti.lifetimeRange = 0
            confetti.velocity = CGFloat(getRandomVelocity())
            confetti.velocityRange = 0
            confetti.emissionLongitude = CGFloat(Double.pi)
            confetti.emissionRange = 0.5
            confetti.spin = 3.5
            confetti.spinRange = 0
            confetti.color = color.cgColor
            confetti.contents = getNextImage(i: index)
            confetti.scaleRange = 0.25
            confetti.scale = 0.1
        } else {
            confetti.birthRate = 10.0 * intensity
            confetti.lifetime = 18.0 * intensity
            confetti.lifetimeRange = 0
            confetti.color = color.cgColor
            confetti.velocity = CGFloat(350.0 * intensity)
            confetti.velocityRange = CGFloat(80.0 * intensity)
            confetti.emissionLongitude = CGFloat(Double.pi)
            confetti.emissionRange = CGFloat(Double.pi)
            confetti.spin = CGFloat(3.5 * intensity)
            confetti.spinRange = CGFloat(4.0 * intensity)
            confetti.scaleRange = CGFloat(intensity)
            confetti.scaleSpeed = CGFloat(-0.1 * intensity)
            confetti.contents = imageForType(type: type)!.cgImage
        }
        return confetti
    }
    
    public func isActive() -> Bool {
        return self.active
    }
    
    private func getRandomVelocity() -> Int {
        return velocities[getRandomNumber()]
    }
    
    private func getRandomNumber() -> Int {
        return Int(arc4random_uniform(4))
    }
    
    private func getNextImage(i:Int) -> CGImage {
        return images[i % 4].cgImage!
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
