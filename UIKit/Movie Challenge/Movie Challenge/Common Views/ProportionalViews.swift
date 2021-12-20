//
//  ProportionalViews.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

//subclasses for UILabel, UIButton, UIImageView to have proportional width/height properties so that they can fill a stackView proportionally

class ProportionalImage: UIImageView{
    var proportionalHeight:CGFloat = 1.0
    var proportionalWidth:CGFloat = 1.0
    override var intrinsicContentSize: CGSize { return CGSize(width: proportionalWidth, height: proportionalHeight) }
}
class ProportionalLabel: UILabel{
    var proportionalHeight:CGFloat = 1.0
    var proportionalWidth:CGFloat = 1.0
    override var intrinsicContentSize: CGSize { return CGSize(width: proportionalWidth, height: proportionalHeight) }
    
    //This allows you to set content mode = .bottom and text will be centered inside box at bottom edge
    override func drawText(in rect: CGRect) {
        var newRect = rect
        switch contentMode {
        case .top:
            newRect.size.height = sizeThatFits(rect.size).height
        case .bottom:
            let height = sizeThatFits(rect.size).height
            newRect.origin.y += rect.size.height - height
            newRect.size.height = height
        default:
            ()
        }
        
        super.drawText(in: newRect)
    }
}
class ProportionalButton: UIButton{
    var proportionalHeight:CGFloat = 1.0
    var proportionalWidth:CGFloat = 1.0
    override var intrinsicContentSize: CGSize { return CGSize(width: proportionalWidth, height: proportionalHeight) }
}
class ProportionalView: UIView{
    var proportionalHeight:CGFloat = 1.0
    var proportionalWidth:CGFloat = 1.0
    override var intrinsicContentSize: CGSize { return CGSize(width: proportionalWidth, height: proportionalHeight) }
}
