//
//  UIColor+Extensions.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt32 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else {
            self.init(red: r, green: g, blue: b, alpha: a)
            return
        }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            self.init(red: r, green: g, blue: b, alpha: a)
            return
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    //helper function to create UIColor from R,G,B values (just /255.0)
    static func color(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        let divider: CGFloat = 255.0
        return UIColor(red: red/divider, green: green/divider, blue: blue/divider, alpha: alpha)
    }
    
    //helper function to create UIColor from Hex value e.g. #F5EFE0
    static func color(hex: String) -> UIColor {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt32 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return UIColor.black }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return UIColor.black
        }
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    //MARK: Helper operation functions to set alphas
    //e.g. operator to make a color with alpha value, simply do UIColor * alpha value (Alpha.low) or (.83)
    
    static func *(color: UIColor, alpha: CGFloat) -> UIColor {
        return color.withAlphaComponent(CGFloat(alpha))
    }
    
    //given a uicolor of a background, this will return the uicolor the text should be on it
    var brightnessAdjustedColor:UIColor{
        
        var components = self.cgColor.components
        let alpha = components?.last
        components?.removeLast()
        let color = CGFloat(1-(components?.max())! >= 0.5 ? 1.0 : 0.0)
        return UIColor(red: color, green: color, blue: color, alpha: alpha!)
    }
    var hexString: String {
        let colorRef = cgColor.components
        let r = colorRef?[0] ?? 0
        let g = colorRef?[1] ?? 0
        let b = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : g) ?? 0
        let a = cgColor.alpha
        
        var color = String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)),lroundf(Float(g * 255)),lroundf(Float(b * 255)))
        
        if a < 1 {
            color += String(format: "%02lX", lroundf(Float(a)))
        }
        
        return color
    }
    
    var imageWithColor:UIImage {
        var rect = CGRect(x: 0, y: 0, width: 60, height: 60)
        UIGraphicsBeginImageContext(rect.size)
        var context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(self.cgColor);
        context!.fill(rect);
        
        var image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();
        return image!;
    }
    
    func isCloseToColor(color: UIColor, tolerance: CGFloat = 0.0) -> Bool{
            
            var r1 : CGFloat = 0
            var g1 : CGFloat = 0
            var b1 : CGFloat = 0
            var a1 : CGFloat = 0
            var r2 : CGFloat = 0
            var g2 : CGFloat = 0
            var b2 : CGFloat = 0
            var a2 : CGFloat = 0
            
            self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
            color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
            
            return
                fabs(r1 - r2) <= tolerance &&
                    fabs(g1 - g2) <= tolerance &&
                    fabs(b1 - b2) <= tolerance &&
                    fabs(a1 - a2) <= tolerance
    }
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                        green: .random(),
                        blue:  .random(),
                        alpha: 1.0)
    }
    
    static func random(close color:UIColor, by tolerance:CGFloat = 0.05) -> UIColor {
        var r1 : CGFloat = 0
        var g1 : CGFloat = 0
        var b1 : CGFloat = 0
        var a1 : CGFloat = 0
        
        color.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        
        let r2 : CGFloat = r1 + CGFloat.random(in: -tolerance..<tolerance)
        let g2 : CGFloat = g1 + CGFloat.random(in: -tolerance..<tolerance)
        let b2 : CGFloat = b1 + CGFloat.random(in: -tolerance..<tolerance)
        
        return UIColor(red: r2, green: g2, blue: b2, alpha: 1.0)
    }
    
    /**
    Create a lighter color
    */
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: abs(percentage))
    }

    /**
    Create a darker color
    */
    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: -abs(percentage))
    }

    /**
    Try to increase brightness or decrease saturation
    */
    func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
          if b < 1.0 {
            let newB: CGFloat = max(min(b + (percentage/100.0)*b, 1.0), 0.0)
            return UIColor(hue: h, saturation: s, brightness: newB, alpha: a)
          } else {
            let newS: CGFloat = min(max(s - (percentage/100.0)*s, 0.0), 1.0)
            return UIColor(hue: h, saturation: newS, brightness: b, alpha: a)
          }
        }
        return self
    }
    

    static func blend(color1: UIColor, intensity1: CGFloat = 0.5, color2: UIColor, intensity2: CGFloat = 0.5) -> UIColor {
        let total = intensity1 + intensity2
        let l1 = intensity1/total
        let l2 = intensity2/total
        guard l1 > 0 else { return color2}
        guard l2 > 0 else { return color1}
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)

        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return UIColor(red: l1*r1 + l2*r2, green: l1*g1 + l2*g2, blue: l1*b1 + l2*b2, alpha: l1*a1 + l2*a2)
    }
}
