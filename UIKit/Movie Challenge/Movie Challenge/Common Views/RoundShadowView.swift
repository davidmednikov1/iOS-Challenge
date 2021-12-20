//
//  RoundShadowView.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

class RoundShadowView: UIView {
    let shadowView:UIView = {
        let shadowView:UIView = UIView()
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowRadius = 2.0
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowOffset = CGSize(width: 1, height: 2)
        return shadowView
    }()
    let roundView:UIView = {
        let roundView = UIView()
        roundView.translatesAutoresizingMaskIntoConstraints = false
        roundView.backgroundColor = UIColor.white
        roundView.layer.masksToBounds = true
        roundView.layer.cornerRadius = 5.0
        
        return roundView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpAutoLayout()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard Initializer not implemented")
    }
    
    var viewBackgroundColor:UIColor = UIColor.white {
        didSet {
            roundView.backgroundColor = viewBackgroundColor
            self.backgroundColor = viewBackgroundColor
        }
    }
    
    func setUpAutoLayout() {
        self.backgroundColor = self.viewBackgroundColor
        self.addSubview(shadowView)
        shadowView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        shadowView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        shadowView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        shadowView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        
        shadowView.addSubview(roundView)
        roundView.leftAnchor.constraint(equalTo: shadowView.leftAnchor).isActive=true
        roundView.rightAnchor.constraint(equalTo: shadowView.rightAnchor).isActive=true
        roundView.topAnchor.constraint(equalTo: shadowView.topAnchor).isActive=true
        roundView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor).isActive=true
    }
}
