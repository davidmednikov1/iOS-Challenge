//
//  ScreenManager.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

enum Orientations {
    case landscape
    case portrait
}

class ScreenManager {
    class var sharedInstance: ScreenManager {
        struct Singleton {
            static let instance = ScreenManager()
        }
        
        return Singleton.instance
    }
    //set in appdelegate and should never be changed
    var rect = UIScreen.main.bounds
    lazy var width:CGFloat = rect.size.width
    lazy var height:CGFloat = rect.size.height
    
    //this is generic should work for resize window on MacOS -- only cares about dimensions rather than physical orientation
    var orientation:Orientations {
        if width > height {
            return .landscape
        }
        return .portrait
    }
}

