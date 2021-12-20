//
//  ColorPalette.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

enum ColorPalette {
    static let lightBlue:UIColor = UIColor(red:0.20, green:0.56, blue:0.87, alpha:1.0) //#338FDE
    enum JazzBlue {
        static let jb0:UIColor = UIColor(hex: "#ADD8E6")! //lighter blue for divider line on listing
    }
    
    
    
    static let lightGreen:UIColor = UIColor(hex: "#1B8057")!
    enum GreenApples {
        static let ga0:UIColor = UIColor(red:0.14, green:0.69, blue:0.20, alpha:1.0) //#1A8057
    }
    
    static let libraryLightBlue:UIColor = UIColor(red:0.20, green:0.56, blue:0.87, alpha:1.0) //TEMP FOR EASY SEARCHING
    static let deleteRed:UIColor = UIColor(hex: "E21C1C")!
    
    enum SteampunkRed {
        static let r0:UIColor = UIColor(hex: "A62947")!
        static let r1:UIColor = UIColor(hex: "92243E")!
        static let r2:UIColor = UIColor(hex: "7E1F35")!
        static let r3:UIColor = UIColor(hex: "691A2D")!
        static let r4:UIColor = UIColor(hex: "551524")!
    }
    enum Purplicious {
        static let p0:UIColor = UIColor(hex: "9623C9")!
        static let p1:UIColor = UIColor(hex: "5B23C9")!
        static let p2:UIColor = UIColor(hex: "4A23C9")!
        static let p3:UIColor = UIColor(hex: "2347c9")!
        static let p4:UIColor = UIColor(hex: "2371C9")!
        static let p5:UIColor = UIColor(hex: "0E0D0C")!//UIColor(hex: "15001E")!
    }
    enum InTheGray {
        static let g0Gray:UIColor = UIColor(hex: "#FEFEFE")!//UIColor(hex: "#FAFAFA")! //background
        static let g005Gray:UIColor = UIColor(hex: "#F4F4F5")! //background for main section (light mode)
        static let g01Gray:UIColor = UIColor(hex: "#E4E4E7")! //for segmented control/button background -- tappable background in light mode //#E4E4E7 //#EEEEF0
        static let g05Gray:UIColor = UIColor(hex: "#e7e7e7")! //background
        static let g1Gray:UIColor = UIColor(hex: "DDDDDD")! //line?
        static let g2Gray:UIColor = UIColor(hex: "A1A1A1")! //text
        static let g3Gray:UIColor = UIColor(hex: "#C6C5C8")! //for vertical divider on +/- in light mode
        static let g5Gray:UIColor = UIColor(hex: "#3A3A3A")!
        
        
        static let g6Gray:UIColor = UIColor(hex: "#1C1C1C")! //settings dark cell background
        static let darkModeDividerGray:UIColor = UIColor(hex: "292A2D")!
        static let darkSettingCellBackground:UIColor = UIColor(hex: "#1E1E1E")!
    }
    
    enum Orangegatang {
        static let o0Orange:UIColor = UIColor(hex: "FFF7DB")!
        static let o1Orange:UIColor = UIColor(hex: "FFC958")!
        static let o2Orange:UIColor = UIColor(hex: "FFA613")!
    }
    enum Pinky {
        static let p0Pink:UIColor = UIColor(hex: "EF98D6")!
        static let p1Pink:UIColor = UIColor(hex: "E27CC5")!
        static let p2Pink:UIColor = UIColor(hex: "DA63B8")!
        static let p3Pink:UIColor = UIColor(hex: "C23499")!
        static let p4Pink:UIColor = UIColor(hex: "AF0E80")!
    }
    enum Violetta {
        static let v0Violet:UIColor = UIColor(hex: "DB76FF")!
        static let v3Violet:UIColor = UIColor(hex: "9600FF")!
    }
    enum DeadRed {
        static let dd0:UIColor = UIColor(hex: "DC6666")!
        static let dd3:UIColor = UIColor(hex: "C50000")!
    }
    
    static let unreadStatusLightMode:UIColor = AppStyleMode.light.color
    static let unreadStatusDarkMode:UIColor =  AppStyleMode.dark.color
    static let downloadedStatus:UIColor = ColorPalette.lightGreen
    static let inProgressReadStatusYellowColor:UIColor = UIColor(hex: "FED017")!
    static let completeReadStatusGreenColor:UIColor = UIColor(hex: "23B033")!
}


class BlueThemePalette:ThemePalette {
    var mainColor: UIColor = ColorPalette.lightBlue
    var lightMainColor: UIColor = ColorPalette.JazzBlue.jb0
}

class GreenThemePalette:ThemePalette {
    var mainColor: UIColor = ColorPalette.lightGreen
    var lightMainColor: UIColor = ColorPalette.GreenApples.ga0
}

class PurpleThemePalette:ThemePalette {
    var mainColor: UIColor = ColorPalette.Purplicious.p3
    var lightMainColor: UIColor = ColorPalette.Purplicious.p0
}
class RedThemePalette:ThemePalette {
    var mainColor: UIColor = ColorPalette.SteampunkRed.r2
    var lightMainColor: UIColor = ColorPalette.SteampunkRed.r0
}
class OrangeThemePalette:ThemePalette {
    var mainColor: UIColor = ColorPalette.Orangegatang.o2Orange
    var lightMainColor: UIColor = ColorPalette.Orangegatang.o1Orange
}
class PinkThemePalette:ThemePalette {
    var mainColor: UIColor = ColorPalette.Pinky.p3Pink
    var lightMainColor: UIColor = ColorPalette.Pinky.p0Pink
}
class VioletThemePalette:ThemePalette {
    var mainColor: UIColor = ColorPalette.Violetta.v3Violet
    var lightMainColor: UIColor = ColorPalette.Violetta.v0Violet
}
class MonotoneThemePalette:ThemePalette {
    var mainColor: UIColor = AppStyleGenerator.getMode().oppositeColor
    var lightMainColor: UIColor = AppStyleGenerator.getMode().dividerColor
}
class DeadRedThemePalette:ThemePalette {
    var mainColor: UIColor = ColorPalette.DeadRed.dd3
    var lightMainColor:UIColor = ColorPalette.DeadRed.dd0
}

class CustomizedThemePalette:ThemePalette {
    var mainColor: UIColor
    var lightMainColor:UIColor
    
    init(mainColor:UIColor, lightMainColor:UIColor){
        self.mainColor = mainColor
        self.lightMainColor = lightMainColor
    }
}

