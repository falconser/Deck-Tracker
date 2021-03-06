//
//  GraphsCollectionCell.swift
//  Deck Tracker
//
//  Created by Andrei Joghiu on 22/10/15.
//  Copyright © 2015 Andrei Joghiu. All rights reserved.
//

import UIKit

class GraphsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var versusLabel: UILabel!
    @IBOutlet weak var winInfoLabel: UILabel!
    @IBOutlet weak var opponentClassImage: UIImageView!
    
    let bgLayer = CAShapeLayer()
    var bgColor: UIColor = UIColor.red
    
    let fgLayer = CAShapeLayer()
    var fgColor: UIColor = UIColor.green
    
    let π = CGFloat(Double.pi)
    var per : CGFloat = 0 {
        didSet {
            DispatchQueue.main.async {
                self.setup()
                self.setNeedsLayout()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    func setup() {
        
        layer.borderWidth = 1
        let width = bgLayer.bounds.width
        //print(width)
        
        var lineWidth = width / 5.5
        // For iPhone 4S
        if width == 139.0 {
            lineWidth = 25
        }
        
        // Setup background layer
        bgLayer.lineWidth = lineWidth
        bgLayer.fillColor = nil
        bgLayer.strokeEnd = 1
        layer.addSublayer(bgLayer)
        
        // Setup foreground layer
        fgLayer.lineWidth = lineWidth
        fgLayer.fillColor = nil
        fgLayer.strokeEnd = 1
        layer.addSublayer(fgLayer)
        
    }
    
    func configure() {
        bgLayer.strokeColor = UIColor(rgbValue:0xC40233).cgColor
        fgLayer.strokeColor = UIColor(rgbValue:0x009F6B).cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBGShapeLayer(bgLayer)
        setupFGShapeLayer(fgLayer)
    }

    
    private func setupFGShapeLayer(_ shapeLayer: CAShapeLayer) {
        
        let width = bgLayer.bounds.width
        //print(width)
        var radiusFactor: CGFloat = 0.25
        // For iPhone 4S
        if width == 139.0 {
            radiusFactor = 0.23
        }
        
        
        shapeLayer.frame = self.bounds
        let startAngle = DegreesToRadians(90.0)
        let calculatedEndAngle = getAngleFromWinRate()
        let endAngle = DegreesToRadians(calculatedEndAngle)
        let center = opponentClassImage.center
        let radius = self.bounds.width * radiusFactor
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        shapeLayer.path = path.cgPath
    }
    
    private func setupBGShapeLayer(_ shapeLayer: CAShapeLayer) {
        
        let width = bgLayer.bounds.width
        //print(width)
        var radiusFactor: CGFloat = 0.25
        // For iPhone 4S
        if width == 139.0 {
            radiusFactor = 0.23
        }
        
        shapeLayer.frame = self.bounds
        let calculatedEndAngle = getAngleFromWinRate()
        var startAngle = DegreesToRadians(calculatedEndAngle) + 0.00001
        if winInfoLabel.text == "No Data" {
            startAngle = DegreesToRadians(calculatedEndAngle)
        }
        let endAngle = DegreesToRadians(90.0)
        let center = opponentClassImage.center
        let radius = self.bounds.width * radiusFactor
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        shapeLayer.path = path.cgPath
    }
    
    private func getAngleFromWinRate() -> CGFloat {
        let angle = (per * 3.6) + 90
        return angle
    }
    
    func DegreesToRadians (_ value:CGFloat) -> CGFloat {
        return value * π / 180.0
    }
    
    func RadiansToDegrees (_ value:CGFloat) -> CGFloat {
        return value * 180.0 / π
    }
    
    func animate() {
        
        let fromValue = fgLayer.strokeEnd
        let toValue = per/100
        
        // 1
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = fromValue
        animation.toValue = toValue
        // 2
        animation.duration = CFTimeInterval(1000000)
        // 3
        fgLayer.removeAnimation(forKey: "stroke")
        fgLayer.add(animation, forKey: "stroke")
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        fgLayer.strokeEnd = toValue
        CATransaction.commit()
    }
}
