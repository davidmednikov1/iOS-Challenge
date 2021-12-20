//
//  UIImageView+Extensions.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//


import UIKit
import AVFoundation

extension UIImageView {
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat, shadowRadius:CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = shadowRadius
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
    
    //apply shadow to VISIBLE part of imageView
    func addShadowToImageNotLayer(blurSize: CGFloat = 8.0){

        let shadowColor = UIColor(white:0.0, alpha:0.8).cgColor

        guard let image = self.image else {return}

        let context = CGContext(data: nil,
                                width: Int(image.size.width + blurSize),
                                height: Int(image.size.height + blurSize),
                                bitsPerComponent: image.cgImage!.bitsPerComponent,
                                bytesPerRow: 0,
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

        context.setShadow(offset: CGSize(width: blurSize/2,height: -blurSize/2),
                          blur: blurSize,
                          color: shadowColor)
        context.draw(image.cgImage!,
                     in: CGRect(x: 0, y: blurSize, width: image.size.width, height: image.size.height),
                     byTiling:false)

        self.image = UIImage(cgImage: context.makeImage()!)

    }
    
}
