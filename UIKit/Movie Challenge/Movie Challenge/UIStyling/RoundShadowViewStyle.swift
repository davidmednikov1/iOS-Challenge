//
//  RoundShadowViewStyle.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

struct RoundShadowViewStyle {
    let shadowColor:UIColor
    let viewBackgroundColor:UIColor
}
protocol RoundShadowViewStylerType: class {
    func style(_ style: ViewStyle)
}

extension RoundShadowView: RoundShadowViewStylerType {
    func style(_ style: RoundShadowViewStyle){
        self.shadowView.layer.shadowColor = style.shadowColor.cgColor
        self.viewBackgroundColor = style.viewBackgroundColor
    }
}
