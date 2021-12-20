//
//  Autolayout+Extensions.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

extension UIView {
    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
}

extension UIViewController {
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.topAnchor
        } else {
            return topLayoutGuide.bottomAnchor
        }
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomLayoutGuide.topAnchor
        }
    }
}

extension UIView {
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomAnchor
        }
    }
}

extension UIView {
    func constrainSidesTo(view: UIView, inset: CGFloat = 0.0, safely:Bool = false) {
        if safely {
            self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: inset).isActive=true
            self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -inset).isActive=true
            self.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: inset).isActive=true
            self.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -inset).isActive=true
        }
        else {
            self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: inset).isActive=true
            self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -inset).isActive=true
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: inset).isActive=true
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset).isActive=true
        }
        
    }
    func constrainLeftAndRightTo(view: UIView, inset: CGFloat = 0.0) {
        self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: inset).isActive=true
        self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -inset).isActive=true
    }
    func constrainTopAndBottomTo(view: UIView, inset: CGFloat = 0.0) {
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: inset).isActive=true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset).isActive=true
    }
}
