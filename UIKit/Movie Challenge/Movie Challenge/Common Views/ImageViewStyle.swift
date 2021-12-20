//
//  ImageViewStyle.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

struct ImageViewStyle {
    let borderColor:CGColor
    let backgroundColor:UIColor
    let tintColor:UIColor?
}
protocol ImageViewStylerType: class {
    func style(_ style: ImageViewStyle)
}

extension UIImageView: ImageViewStylerType {
    func style(_ style: ImageViewStyle){
        self.layer.borderColor = style.borderColor
        self.backgroundColor = style.backgroundColor
        
        if let tintColor = style.tintColor {
            self.tintColor = tintColor
        }
    }
}
