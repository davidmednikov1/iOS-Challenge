//
//  NavigatorDelegate.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

protocol NavigatorDelegate:class {
    func navigate(to: UIViewController, replace:Bool)
    var tabBarController:UITabBarController? { get } //comes for free if it has it
    
    func pop()
}
