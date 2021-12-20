//
//  ButtonStyle.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

struct ButtonStyle {
    let borderColor:CGColor
    let backgroundColor:UIColor
    let textColor:UIColor
}
protocol ButtonStylerType: class {
    func style(_ style: ButtonStyle)
}

extension UIButton: ButtonStylerType {
    func style(_ style: ButtonStyle){
        self.layer.borderColor = style.borderColor
        self.backgroundColor = style.backgroundColor
        self.setTitleColor(style.textColor, for: .normal)
    }
}
