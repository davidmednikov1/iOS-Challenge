//
//  ViewStyle.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

protocol Restylable: UIView {
    func restyle()
}

struct ViewStyle {
    let borderColor:CGColor
    let backgroundColor:UIColor
}
protocol ViewStylerType: AnyObject {
    func style(_ style: ViewStyle)
}

extension UIView: ViewStylerType {
    func style(_ style: ViewStyle){
        self.layer.borderColor = style.borderColor
        self.backgroundColor = style.backgroundColor
    }
}

