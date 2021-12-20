//
//  GradientView.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

enum GradientDirection{
    case LeftToRight, RightToLeft, TopToBottom, BottomToTop, TopLeftToBottomRight
}

class GradientView:UIView {
    let gradientLayer: CAGradientLayer
    
    var gradientColors:[CGColor] {
        didSet {
            self.gradientLayer.colors = gradientColors
        }
    }
    var gradientDirection:GradientDirection
    
    var locations:[NSNumber]?
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(gradientColors:[CGColor], gradientDirection: GradientDirection, locations:[NSNumber]? = nil){
        self.gradientColors = gradientColors
        self.gradientDirection = gradientDirection
        self.locations = locations
        
        
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        
        if let locations = self.locations {
            gradientLayer.locations = locations //locations are percentages (0.2) etc of where to put the colors
        }
            
        switch gradientDirection {
        case .LeftToRight:
        //LEFT TO RIGHT
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        case .RightToLeft:
        // RIGHT TO LEFT
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        
        case .BottomToTop:
        // BOTTOM TO TOP
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        case .TopToBottom:
        // TOP TO BOTTOM
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        case .TopLeftToBottomRight:
        //TOP LEFT TO BOTTOM RIGHT (DIAGONALLY)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        }
        
        super.init(frame: .zero)
        setUpAutolayout()
    }
    
    func setUpAutolayout() {
        layer.addSublayer(gradientLayer)
    }
    override func layoutSubviews() {
        //super must be called first
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
