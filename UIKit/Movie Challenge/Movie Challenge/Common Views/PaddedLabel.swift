//
//  PaddedLabel.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

class PaddedLabel:UIView {
    
    var text:String = "" {
        didSet {
            label.text = text
        }
    }
    
    let edgeInsets:UIEdgeInsets
    let cornerRadius:CGFloat?
    
    let label:UILabel
    
    var labelUIElement:AppUIElement.Label
    var viewUIElement:AppUIElement.View
    
    init(edgeInsets:UIEdgeInsets, cornerRadius:CGFloat?, label:UILabel, viewUIElement:AppUIElement.View, labelUIElement:AppUIElement.Label){
        self.edgeInsets = edgeInsets
        self.cornerRadius = cornerRadius
        self.label = label
        self.viewUIElement = viewUIElement
        self.labelUIElement = labelUIElement
        
        super.init(frame: .zero)
        
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAutoLayout(){
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: self.edgeInsets.left).isActive=true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -self.edgeInsets.right).isActive=true
        label.topAnchor.constraint(equalTo: topAnchor, constant: self.edgeInsets.top).isActive=true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -self.edgeInsets.bottom).isActive=true
        
        if let cornerRadius = self.cornerRadius {
            self.layer.cornerRadius = cornerRadius
        }
        
        self.restyle()
    }
}

extension PaddedLabel:Restylable {
    func restyle(){
        self.style(AppStyleGenerator.getViewStyle(for: self.viewUIElement))
        self.label.style(AppStyleGenerator.getLabelStyle(for: self.labelUIElement))
    }
}


import Foundation
import UIKit

@IBDesignable
class PaddingLabel: UILabel {
    var textEdgeInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textEdgeInsets)//bounds.inset(by: textEdgeInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textEdgeInsets.top, left: -textEdgeInsets.left, bottom: -textEdgeInsets.bottom, right: -textEdgeInsets.right)
        return textRect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textEdgeInsets))
    }
    
    @IBInspectable
    var paddingLeft: CGFloat {
        set { textEdgeInsets.left = newValue }
        get { return textEdgeInsets.left }
    }
    
    @IBInspectable
    var paddingRight: CGFloat {
        set { textEdgeInsets.right = newValue }
        get { return textEdgeInsets.right }
    }
    
    @IBInspectable
    var paddingTop: CGFloat {
        set { textEdgeInsets.top = newValue }
        get { return textEdgeInsets.top }
    }
    
    @IBInspectable
    var paddingBottom: CGFloat {
        set { textEdgeInsets.bottom = newValue }
        get { return textEdgeInsets.bottom }
    }
    
    var labelUIElement:AppUIElement.Label
    
    init(textEdgeInsets:UIEdgeInsets, labelUIElement:AppUIElement.Label){
        self.textEdgeInsets = textEdgeInsets
        
        self.labelUIElement = labelUIElement
        
        super.init(frame: .zero)
        
        self.restyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PaddingLabel:Restylable {
    func restyle(){
        self.style(AppStyleGenerator.getLabelStyle(for: self.labelUIElement))
    }
}
