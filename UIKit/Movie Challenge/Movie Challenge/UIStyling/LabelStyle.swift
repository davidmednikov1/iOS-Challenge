//
//  LabelStyle.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit
import SwiftUI

struct LabelStyle {
    let borderColor:CGColor
    let backgroundColor:UIColor
    let textColor:UIColor
}
protocol LabelStylerType: class {
    func style(_ style: LabelStyle)
}

extension UILabel: LabelStylerType {
    func style(_ style: LabelStyle){
        self.layer.borderColor = style.borderColor
        self.backgroundColor = style.backgroundColor
        self.textColor = style.textColor
    }
}

extension UITextField: LabelStylerType {
    func style(_ style: LabelStyle){
        self.layer.borderColor = style.borderColor
        self.backgroundColor = style.backgroundColor
        self.textColor = style.textColor
    }
}

extension UITextView: LabelStylerType {
    func style(_ style: LabelStyle){
        self.layer.borderColor = style.borderColor
        self.backgroundColor = style.backgroundColor
        self.textColor = style.textColor
    }
}

@available(iOS 14, *)
struct StyledText: ViewModifier {
    var labelStyle: LabelStyle
    
    func body(content: Content) -> some View {
        content
            .background(Color(labelStyle.backgroundColor))
            .foregroundColor(Color(labelStyle.textColor))
            .border(Color(UIColor(cgColor: labelStyle.borderColor)))
    }
}
@available(iOS 14.0, *)
extension View {
    func style(labelStyle: LabelStyle) -> some View{
        self.modifier(StyledText(labelStyle: labelStyle))
    }
}

