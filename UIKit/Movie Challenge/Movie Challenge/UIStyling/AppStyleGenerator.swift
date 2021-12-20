//
//  AppStyleGenerator.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

struct CustomThemePalette:Codable, Equatable { //saved as hex codes
    var mainColor: String
    var lightMainColor: String
    func toString() -> String {
        return "custom-\(mainColor.uppercased())-\(lightMainColor.uppercased())"
    }
}

protocol ThemePalette {
    var mainColor:UIColor { get }
    var lightMainColor:UIColor { get }
}
enum AppFont:String {
    case regular
    case bold
}

enum AppStyleMode:String {
    case light
    case dark
    
    var color:UIColor {
        switch self {
        case .light:
            return UIColor.white
        case .dark:
            return UIColor.black
        }
    }
    var oppositeColor:UIColor {
        switch self {
        case .light:
            return UIColor.black
        case .dark:
            return UIColor.white
        }
    }
    var offsetColor:UIColor {
        switch self {
        case .light:
            return ColorPalette.InTheGray.g1Gray
        case .dark:
            return ColorPalette.InTheGray.g6Gray
        }
    }
    
    var dividerColor:UIColor {
        switch self {
        case .light:
            return ColorPalette.InTheGray.g05Gray
        case .dark:
            return ColorPalette.InTheGray.darkModeDividerGray
        }
    }
    var verticalDividerColor:UIColor {
        switch self {
        case .light:
            return ColorPalette.InTheGray.g3Gray
        case .dark:
            return ColorPalette.InTheGray.darkModeDividerGray
        }
    }
    var settingCellBackgroundColor:UIColor {
        switch self {
        case .light:
            return UIColor.white
        case .dark:
            return ColorPalette.InTheGray.darkSettingCellBackground
        }
    }
    var tappableBackgroundColor:UIColor { //for segmentedControl, +/- etc
        switch self {
        case .light:
            return ColorPalette.InTheGray.g01Gray
        case .dark:
            return ColorPalette.InTheGray.darkSettingCellBackground
        }
    }
    var contentBackgroundColor:UIColor {
        switch self {
        case .light:
            return ColorPalette.InTheGray.g005Gray
        case .dark:
            return ColorPalette.Purplicious.p5
        }
    }
    
    var newContentBackgroundColor:UIColor {
        let themeIntensity:CGFloat = AppStyleGenerator.getContentBackgroundThemeBlendingPercentPreference()
        //themeIntensity can be 0.0 to 100.0 (maybe not 100 - 95%?)
        switch self {
        case .light:
            return UIColor.blend(color1: AppStyleGenerator.getTheme().palette.mainColor, intensity1: themeIntensity, color2: UIColor(hex: "FCFCFC")!, intensity2: 100.0 - themeIntensity)
        case .dark:
            return UIColor.blend(color1: AppStyleGenerator.getTheme().palette.mainColor, intensity1: themeIntensity, color2: UIColor(hex: "080809")!, intensity2: 100.0 - themeIntensity)
        }
    }
    
    var inProgressReadStatusColor:UIColor {
        return ColorPalette.inProgressReadStatusYellowColor //no difference between light/dark
    }
    
    var codeCommentBackgroundColor:UIColor {
        switch self {
        case .light:
            return UIColor(hex: "C8C6C1")!
        case .dark:
            return UIColor(hex: "37393E")!
        }
    }
    var codeCommentBorderColor:UIColor {
        switch self {
        case .light:
            return UIColor(hex: "DFDDDA")!
        case .dark:
            return UIColor(hex: "202225")!
        }
    }
    var codeCommentTextBackgroundColor:UIColor {
        switch self {
        case .light:
            return UIColor(hex: "D0CEC8")!
        case .dark:
            return UIColor(hex: "2F3137")!
        }
    }
    
    var newSubtitledTextColor:UIColor {
        switch self {
        case .light:
            return UIColor(hex: "8FA7B3")!
        case .dark:
            return UIColor(hex: "8FA7B3")!
        }
    }
    
    var newInfoTextBackgroundColor:UIColor {
        switch self {
        case .light:
            return UIColor(hex: "F5F8FA")!
        case .dark:
            return UIColor(hex: "0E1113")! //That's a Nice Color =]
        }
    }
}
enum AppStyleTheme {
    case blue(ThemePalette)
    case green(ThemePalette)
    case purple(ThemePalette)
    case red(ThemePalette)
    case orange(ThemePalette)
    case pink(ThemePalette)
    case violet(ThemePalette)
    case monotone(ThemePalette)
    case deadred(ThemePalette)
    case custom(ThemePalette)
    
    var palette:ThemePalette {
        switch self {
        case .blue(let theme):
            return theme
        case .green(let theme):
            return theme
        case .purple(let theme):
            return theme
        case .red(let theme):
            return theme
        case .orange(let theme):
            return theme
        case .pink(let theme):
            return theme
        case .violet(let theme):
            return theme
        case .monotone(let theme):
            return theme
        case .deadred(let theme):
            return theme
        case .custom(let theme):
            return theme
        }
    }
    
    
    func toString() -> String{
        switch self {
        case .blue(_):
            return "blue"
        case .green(_):
            return "green"
        case .purple(_):
            return "purple"
        case .red(_):
            return "red"
        case .orange(_):
            return "orange"
        case .pink(_):
            return "pink"
        case .violet(_):
            return "violet"
        case .monotone(_):
            return "monotone"
        case .deadred(_):
            return "deadred"
        case .custom(let themePalette):
            return "custom-\(themePalette.mainColor.hexString)-\(themePalette.lightMainColor.hexString)"
        }
    }
    
    static func get(from stringValue:String) -> AppStyleTheme {
        switch stringValue {
        case "blue":
            return .blue(BlueThemePalette())
        case "green":
            return green(GreenThemePalette())
        case "purple":
            return purple(PurpleThemePalette())
        case "red":
            return red(RedThemePalette())
        case "orange":
            return orange(OrangeThemePalette())
        case "pink":
            return pink(PinkThemePalette())
        case "violet":
            return violet(VioletThemePalette())
        case "monotone":
            return monotone(MonotoneThemePalette())
        case "deadred":
            return deadred(DeadRedThemePalette())
        default:
            return AppStyleGenerator.defaultAppStyleThemePreference
        }
    }
}

class AppStyleGenerator {
    static let themes:[AppStyleTheme] = [.monotone(MonotoneThemePalette()),
                                         .deadred(DeadRedThemePalette()),
                                         .red(RedThemePalette()),
                                         .orange(OrangeThemePalette()),
                                         .green(GreenThemePalette()),
                                         .blue(BlueThemePalette()),
                                         .purple(PurpleThemePalette()),
                                         .violet(VioletThemePalette()),
                                         .pink(PinkThemePalette())]
    static let defaultAppStyleThemePreference:AppStyleTheme = AppStyleTheme.purple(PurpleThemePalette())
    static func setAppStyleThemePreference(_ appStyleTheme:AppStyleTheme){
        /*AppGroupManager.sharedInstance.userDefaults.setValue(appStyleTheme.toString(), forKey: UserDefaultsKeys.Theme.COLOR_SCHEME)
        AppStyleGenerator.setAppStyleCustomThemePreference(nil)*/
    }
    
    static func getAppStyleThemePreference() -> AppStyleTheme {
        /*if let stringValue = AppGroupManager.sharedInstance.userDefaults.string(forKey: UserDefaultsKeys.Theme.COLOR_SCHEME){
            return AppStyleTheme.get(from: stringValue)
        }*/
        return defaultAppStyleThemePreference
    }
    
    static func setAppStyleCustomThemePreference(_ customStyleTheme:CustomThemePalette?){
        //AppGroupManager.sharedInstance.setCodableToUserDefaults(key: UserDefaultsKeys.Theme.SELECTED_CUSTOM_THEME, value: customStyleTheme)
    }
    static func getAppStyleCustomThemePreference() -> CustomThemePalette? {
        //return AppGroupManager.sharedInstance.getSingleCodableFromUserDefaults(key: UserDefaultsKeys.Theme.SELECTED_CUSTOM_THEME, type: CustomThemePalette.self)
        return nil
    }
    
    static let defaultAppStyleModePreference:AppStyleMode = AppStyleMode.light
    static func setAppStyleModePreference(_ appStyleMode:AppStyleMode){
        //AppGroupManager.sharedInstance.userDefaults.setValue(appStyleMode.rawValue, forKey: UserDefaultsKeys.Theme.MODE)
    }
    static func getAppStyleModePreference() -> AppStyleMode {
        /*if let rawValue = AppGroupManager.sharedInstance.userDefaults.string(forKey: UserDefaultsKeys.Theme.MODE){
            return AppStyleMode(rawValue: rawValue) ?? defaultAppStyleModePreference
        }*/
        return defaultAppStyleModePreference
    }
    
    //MARK: CONTENT BACKGROUND THEME BLENDING PREFERENCE -- this is a % that the content background should be mixed with the current theme as opposed to purely off-light/off-dark mode  -- store as 1-100
    static let defaultContentBackgroundThemeBlendingPercentPreference:CGFloat = 15.0 //2.0 %
    static func setContentBackgroundThemeBlendingPercentPreference(_ percentage:CGFloat){
        //AppGroupManager.sharedInstance.userDefaults.setValue(percentage, forKey: UserDefaultsKeys.Theme.CONTENT_BACKGROUND_THEME_BLENDING_PERCENT)
    }
    static func getContentBackgroundThemeBlendingPercentPreference() -> CGFloat {
        /*if let percentage = AppGroupManager.sharedInstance.userDefaults.object(forKey: UserDefaultsKeys.Theme.CONTENT_BACKGROUND_THEME_BLENDING_PERCENT) as? CGFloat{
                return percentage
        }*/
        return defaultContentBackgroundThemeBlendingPercentPreference
    }
    
    static func getMode() -> AppStyleMode {
        return getAppStyleModePreference()
    }
    static func getTheme() -> AppStyleTheme {
        
        if let customThemePalette = AppStyleGenerator.getAppStyleCustomThemePreference() {
            if let mainColor = UIColor(hex: customThemePalette.mainColor), let lightMainColor = UIColor(hex: customThemePalette.lightMainColor){
                return .custom(CustomizedThemePalette(mainColor: mainColor, lightMainColor: lightMainColor))
            }
        }
        return getAppStyleThemePreference()
    }
    
    static func getFont(for appFont:AppFont, size:CGFloat) -> UIFont? {
        switch appFont {
        case .regular:
            return UIFont(name: "Helvetica", size: size)
        case .bold:
            return UIFont(name: "Helvetica-Bold", size: size)
        }
    }
    
    static func getViewStyle(for viewElement:AppUIElement.View) -> ViewStyle {
        let theme = AppStyleGenerator.getTheme()
        let mainColor = theme.palette.mainColor
        let lightMainColor = theme.palette.lightMainColor
        
        let mode = AppStyleGenerator.getMode()
        var modeColor = mode.color
        var oppositeModeColor = mode.oppositeColor
        var barColor = ColorPalette.InTheGray.g0Gray
        var unreadStatusColor = ColorPalette.unreadStatusLightMode
        
        switch mode {
        case .light:
            barColor = ColorPalette.InTheGray.g0Gray
            unreadStatusColor = ColorPalette.unreadStatusLightMode
        case .dark:
            barColor = ColorPalette.Purplicious.p5
            unreadStatusColor = ColorPalette.unreadStatusDarkMode
        }
        
        switch viewElement {
        case .View:
            return ViewStyle(borderColor: UIColor.clear.cgColor, backgroundColor: UIColor.white)
        case .ViewLibraryListingEtcExample:
            return ViewStyle(borderColor: UIColor.clear.cgColor, backgroundColor: UIColor.white)
        case .BarViewBackground:
            return ViewStyle(borderColor: barColor.cgColor, backgroundColor: barColor)
        case .ModeViewBackground:
            return ViewStyle(borderColor: modeColor.cgColor, backgroundColor: modeColor)
        case .ModeViewBackgroundLighterThemeOutlined:
            return ViewStyle(borderColor: lightMainColor.cgColor, backgroundColor: modeColor)
        case .SlightyOffsetModeViewBackground:
            return ViewStyle(borderColor: getMode().offsetColor.cgColor, backgroundColor: getMode().offsetColor)
        case .OppositeModeViewBackground:
            return ViewStyle(borderColor: oppositeModeColor.cgColor, backgroundColor: oppositeModeColor)
        case .BarDividerView:
            return ViewStyle(borderColor: getMode().dividerColor.cgColor, backgroundColor: getMode().dividerColor)
        case .BarViewBackgroundDividerOutlined:
            return ViewStyle(borderColor: getMode().dividerColor.cgColor, backgroundColor: barColor)
        case .ThemedViewBackground:
            return ViewStyle(borderColor: mainColor.cgColor, backgroundColor: mainColor)
        case .LighterThemedViewBackground:
            return ViewStyle(borderColor: lightMainColor.cgColor, backgroundColor: lightMainColor)
        case .UnreadStatusBackground:
            return ViewStyle(borderColor: unreadStatusColor.cgColor, backgroundColor: unreadStatusColor)
        case .DownloadedStatusBackground:
            return ViewStyle(borderColor: ColorPalette.downloadedStatus.cgColor, backgroundColor: ColorPalette.downloadedStatus)
        case .SettingCellBackground:
            return ViewStyle(borderColor: getMode().settingCellBackgroundColor.cgColor, backgroundColor: getMode().settingCellBackgroundColor)
        case .TappableBackground:
            return ViewStyle(borderColor: getMode().tappableBackgroundColor.cgColor, backgroundColor: getMode().tappableBackgroundColor)
        case .ContentBackground:
            return ViewStyle(borderColor: getMode().contentBackgroundColor.cgColor, backgroundColor: getMode().contentBackgroundColor)
        case .NewContentBackground:
            return ViewStyle(borderColor: getMode().newContentBackgroundColor.cgColor, backgroundColor: getMode().newContentBackgroundColor)
        case .NewInfoBackground:
            return ViewStyle(borderColor: getMode().newInfoTextBackgroundColor.cgColor, backgroundColor: getMode().newInfoTextBackgroundColor)
        case .InProgressStatusBackground:
            return ViewStyle(borderColor: ColorPalette.inProgressReadStatusYellowColor.cgColor, backgroundColor: ColorPalette.inProgressReadStatusYellowColor)
        case .CompleteReadStatusBackground:
            return ViewStyle(borderColor: ColorPalette.completeReadStatusGreenColor.cgColor, backgroundColor: ColorPalette.completeReadStatusGreenColor)
        case .CodeBlockBackground:
            return ViewStyle(borderColor: getMode().codeCommentBackgroundColor.cgColor, backgroundColor: getMode().codeCommentBackgroundColor)
        }
    }
    static func getLabelStyle(for labelElement:AppUIElement.Label) -> LabelStyle {
        let mode = AppStyleGenerator.getMode()
        var modeColor = mode.color
        var oppositeModeColor = mode.oppositeColor
        var unreadStatusColor = ColorPalette.unreadStatusLightMode
        var inProgressReadStatusColor = ColorPalette.inProgressReadStatusYellowColor //no difference between light/dark
        var completeReadStatusColor = ColorPalette.completeReadStatusGreenColor //no difference between light/dark
        
        var unselectedTabColor:UIColor = ColorPalette.InTheGray.g2Gray
        
        switch mode {
        case .light:
            unreadStatusColor = ColorPalette.unreadStatusLightMode
            unselectedTabColor = ColorPalette.InTheGray.g2Gray
        case .dark:
            unreadStatusColor = ColorPalette.unreadStatusDarkMode
            unselectedTabColor = oppositeModeColor
        }
        
        
        let theme = AppStyleGenerator.getTheme()
        let mainColor = theme.palette.mainColor
        
        var textVisibleColorAgainstTheme:UIColor = UIColor.white
        if AppStyleGenerator.getTheme().toString() == "monotone" {
            textVisibleColorAgainstTheme = AppStyleGenerator.getMode().color
        }
        switch labelElement {
        case .Label:
            return LabelStyle(borderColor: UIColor.clear.cgColor, backgroundColor: UIColor.white, textColor: UIColor.black)
        case .ClearBackgroundLabelAgainstModeColor:
            return LabelStyle(borderColor: UIColor.clear.cgColor, backgroundColor: UIColor.clear, textColor: oppositeModeColor)
        case .ClearBackgroundLabelAgainstOppositeModeColor:
            return LabelStyle(borderColor: UIColor.clear.cgColor, backgroundColor: UIColor.clear, textColor: modeColor)
        case .ClearBackgroundLabelThemedAgainstModeColor:
            return LabelStyle(borderColor: UIColor.clear.cgColor, backgroundColor: UIColor.clear, textColor: mainColor)
        case .ThemedBackgroundLabel:
            return LabelStyle(borderColor: mainColor.cgColor, backgroundColor: mainColor, textColor: textVisibleColorAgainstTheme)
        case .ClearBackgroundTextVisibleAgainstThemedLabel:
            return LabelStyle(borderColor: UIColor.clear.cgColor, backgroundColor: UIColor.clear, textColor: textVisibleColorAgainstTheme)
        case .ModeBackgroundThemedLabel:
            return LabelStyle(borderColor: modeColor.cgColor, backgroundColor: modeColor, textColor: mainColor)
        case .ModeBackgroundThemedBorderThemedLabel:
            return LabelStyle(borderColor: mainColor.cgColor, backgroundColor: modeColor, textColor: mainColor)
        case .ModeBackgroundLabel:
            return LabelStyle(borderColor: modeColor.cgColor, backgroundColor: modeColor, textColor: oppositeModeColor)
        case .DarkModeBackgroundLabel:
            return LabelStyle(borderColor: AppStyleMode.dark.color.cgColor, backgroundColor: AppStyleMode.dark.color, textColor: AppStyleMode.light.color)
        case .OppositeModeBackgroundLabel:
            return LabelStyle(borderColor: oppositeModeColor.cgColor, backgroundColor: oppositeModeColor, textColor: modeColor)
        case .UnreadStatusBackgroundThemedBorderLabel:
            return LabelStyle(borderColor: mainColor.cgColor, backgroundColor: unreadStatusColor, textColor: oppositeModeColor)
        case .InProgressReadStatusBackgroundThemedBorderLabel:
            return LabelStyle(borderColor: mainColor.cgColor, backgroundColor: inProgressReadStatusColor, textColor: AppStyleMode.dark.color)
        case .CompleteReadStatusBackgroundThemedBorderLabel:
            return LabelStyle(borderColor: mainColor.cgColor, backgroundColor: completeReadStatusColor, textColor: AppStyleMode.light.color)
        case .DownloadedStatusBackgroundLabel:
            return LabelStyle(borderColor: ColorPalette.downloadedStatus.cgColor, backgroundColor: ColorPalette.downloadedStatus, textColor: AppStyleMode.dark.color)
        case .DownloadedStatusTextModeBackgroundLabel:
            return LabelStyle(borderColor: AppStyleGenerator.getMode().color.cgColor, backgroundColor: AppStyleGenerator.getMode().color, textColor: ColorPalette.downloadedStatus)
        case .ReadStatusTextModeBackgroundLabel:
            return LabelStyle(borderColor: AppStyleGenerator.getMode().color.cgColor, backgroundColor: AppStyleGenerator.getMode().color, textColor: AppStyleGenerator.getMode().dividerColor)
        case .UnreadStatusTextModeBackgroundLabel:
            return LabelStyle(borderColor: AppStyleGenerator.getMode().color.cgColor, backgroundColor: AppStyleGenerator.getMode().color, textColor: AppStyleGenerator.getMode().oppositeColor)
        case .ContentBackgroundLabel:
            return LabelStyle(borderColor: getMode().contentBackgroundColor.cgColor, backgroundColor: getMode().contentBackgroundColor, textColor: AppStyleGenerator.getMode().oppositeColor)
        case .NewContentBackgroundLabel:
            return LabelStyle(borderColor: getMode().newContentBackgroundColor.cgColor, backgroundColor: getMode().newContentBackgroundColor, textColor: AppStyleGenerator.getMode().oppositeColor)
        case .NewContentBackgroundThemedLabel:
            return LabelStyle(borderColor: getMode().newContentBackgroundColor.cgColor, backgroundColor: getMode().newContentBackgroundColor, textColor: AppStyleGenerator.getTheme().palette.mainColor)
        case .NewContentBackgroundSubtitleLabel:
            return LabelStyle(borderColor: getMode().newContentBackgroundColor.cgColor, backgroundColor: getMode().newContentBackgroundColor, textColor: AppStyleGenerator.getMode().newSubtitledTextColor)
        case .ContentBackgroundThemedLabel:
            return LabelStyle(borderColor: getMode().contentBackgroundColor.cgColor, backgroundColor: getMode().contentBackgroundColor, textColor: AppStyleGenerator.getTheme().palette.mainColor)
        case .ClearBackgroundLabelUnselectedLabel:
            return LabelStyle(borderColor: UIColor.clear.cgColor, backgroundColor: UIColor.clear, textColor: unselectedTabColor)
        case .CodeBlockTextBackgroundLabel:
            return LabelStyle(borderColor: getMode().codeCommentBorderColor.cgColor, backgroundColor: getMode().codeCommentTextBackgroundColor, textColor: getMode().oppositeColor)
        case .CodeBlockBackgroundLabel:
            return LabelStyle(borderColor: getMode().codeCommentBackgroundColor.cgColor, backgroundColor: getMode().codeCommentBackgroundColor, textColor: getMode().oppositeColor)
        case .NewModeBackgroundSubtitleLabel:
            return LabelStyle(borderColor: getMode().color.cgColor, backgroundColor: getMode().color, textColor: getMode().newSubtitledTextColor)
        case .NewInfoTextBackgroundSubtitleLabel:
            return LabelStyle(borderColor: getMode().newInfoTextBackgroundColor.cgColor, backgroundColor: getMode().newInfoTextBackgroundColor, textColor: getMode().newSubtitledTextColor)
        case .NewInfoTextBackgroundLabel:
            return LabelStyle(borderColor: getMode().newInfoTextBackgroundColor.cgColor, backgroundColor: getMode().newInfoTextBackgroundColor, textColor: getMode().oppositeColor)
        }
        
    }
    
    static func getButtonStyle(for buttonElement:AppUIElement.Button) -> ButtonStyle {
        let mode = AppStyleGenerator.getMode()
        var modeColor = mode.color
        var oppositeModeColor = mode.oppositeColor
        
        let theme = AppStyleGenerator.getTheme()
        let mainColor = theme.palette.mainColor
        
        let textVisibleColorAgainstTheme:UIColor = UIColor.white
        
        switch buttonElement {
        case .Button:
            return ButtonStyle(borderColor: UIColor.clear.cgColor, backgroundColor: UIColor.white, textColor: UIColor.black)
        case .ClearBackgroundButtonAgainstModeColor:
            return ButtonStyle(borderColor: UIColor.clear.cgColor, backgroundColor: UIColor.clear, textColor: oppositeModeColor)
        case .ClearBackgroundButtonThemedAgainstModeColor:
            return ButtonStyle(borderColor: UIColor.clear.cgColor, backgroundColor: UIColor.clear, textColor: mainColor)
        case .ThemedBackgroundButton:
            return ButtonStyle(borderColor: mainColor.cgColor, backgroundColor: mainColor, textColor: textVisibleColorAgainstTheme)
        case .ModeBackgroundThemedButton:
            return ButtonStyle(borderColor: modeColor.cgColor, backgroundColor: modeColor, textColor: mainColor)
        case .ModeBackgroundButton:
            return ButtonStyle(borderColor: modeColor.cgColor, backgroundColor: modeColor, textColor: oppositeModeColor)
        case .OppositeModeBackgroundButton:
            return ButtonStyle(borderColor: oppositeModeColor.cgColor, backgroundColor: oppositeModeColor, textColor: modeColor)
        case .ClearBackgroundVisibleAgainstTheme:
            return ButtonStyle(borderColor: UIColor.clear.cgColor, backgroundColor: UIColor.clear, textColor: textVisibleColorAgainstTheme)
        }
    }
    
    static func getRoundShadowViewStyle(for roundShadowElement:AppUIElement.RoundShadowView) -> RoundShadowViewStyle {
        let theme = AppStyleGenerator.getTheme()
        let mainColor = theme.palette.mainColor
        let lightMainColor = theme.palette.lightMainColor
        
        let mode = AppStyleGenerator.getMode()
        var modeColor = mode.color
        var oppositeModeColor = mode.oppositeColor
        var barColor = ColorPalette.InTheGray.g0Gray
        var unreadStatusColor = ColorPalette.unreadStatusLightMode
        
        switch mode {
        case .light:
            barColor = ColorPalette.InTheGray.g0Gray
            unreadStatusColor = ColorPalette.unreadStatusLightMode
        case .dark:
            barColor = ColorPalette.Purplicious.p5
            unreadStatusColor = ColorPalette.unreadStatusDarkMode
        }
        
        switch roundShadowElement {
        case .RoundShadowViewAgainstModeBackground:
            return RoundShadowViewStyle(shadowColor: oppositeModeColor, viewBackgroundColor: modeColor)
        case .RoundShadoveViewReadingInProgressAgainstModeBackground:
            return RoundShadowViewStyle(shadowColor: AppStyleGenerator.getMode().inProgressReadStatusColor, viewBackgroundColor: modeColor)
        case .RoundShadoveViewReadingThemedShadowAgainstModeBackground:
            return RoundShadowViewStyle(shadowColor: AppStyleGenerator.getTheme().palette.mainColor, viewBackgroundColor: modeColor)
        }
    }
    
    static func getImageViewStyle(for imageElement:AppUIElement.ImageView) -> ImageViewStyle {
        let mode = AppStyleGenerator.getMode()
        var modeColor = mode.color
        var oppositeModeColor = mode.oppositeColor
        
        let theme = AppStyleGenerator.getTheme()
        let mainColor = theme.palette.mainColor
        
        let tintVisibleColorAgainstTheme:UIColor = UIColor.white
        
        var unselectedTabColor:UIColor = ColorPalette.InTheGray.g2Gray
        switch mode {
        case .light:
            unselectedTabColor = ColorPalette.InTheGray.g2Gray
        case .dark:
            unselectedTabColor = oppositeModeColor
        }
        
        switch imageElement {
        case .ImageView:
            return ImageViewStyle(borderColor: UIColor.white.cgColor, backgroundColor: UIColor.white, tintColor: UIColor.white)
        case .ClearBackgroundOppositeModeTintedImageView:
            return ImageViewStyle(borderColor: UIColor.clear.cgColor, backgroundColor: UIColor.clear, tintColor: oppositeModeColor)
        case .NewClearBackgroundSubtitleTintedImageView:
            return ImageViewStyle(borderColor: UIColor.clear.cgColor, backgroundColor: UIColor.clear, tintColor: AppStyleGenerator.getMode().newSubtitledTextColor)
        case .ClearBackgroundImageViewThemedAgainstModeColor:
            return ImageViewStyle(borderColor: UIColor.clear.cgColor, backgroundColor: UIColor.clear, tintColor: mainColor)
        case .ClearBackgroundImageView:
            return ImageViewStyle(borderColor: UIColor.clear.cgColor, backgroundColor: UIColor.clear, tintColor: UIColor.clear)
        case .ClippedBackgroundImageViewThemedAgainstImageBackground:
            return ImageViewStyle(borderColor: UIColor.clear.cgColor, backgroundColor: UIColor.white, tintColor: mainColor)
        case .ClippedModeBackgroundImageViewWithThemedBorder:
            return ImageViewStyle(borderColor: mainColor.cgColor, backgroundColor: modeColor, tintColor: mainColor)
        case .ClippedOppositeModeBackgroundImageViewWithThemedBorder:
            return ImageViewStyle(borderColor: oppositeModeColor.cgColor, backgroundColor: oppositeModeColor, tintColor: mainColor)
        case .ModeBackgroundImageView:
            return ImageViewStyle(borderColor: modeColor.cgColor, backgroundColor: modeColor, tintColor: nil)
        case .ModeBackgroundImageThemed:
            return ImageViewStyle(borderColor: modeColor.cgColor, backgroundColor: modeColor, tintColor: mainColor)
        case .ThemedBackgroundImageMode:
            return ImageViewStyle(borderColor: mainColor.cgColor, backgroundColor: mainColor, tintColor: tintVisibleColorAgainstTheme)
        case .LightModeBackgroundImageThemed:
            return ImageViewStyle(borderColor: AppStyleMode.light.color.cgColor, backgroundColor: AppStyleMode.light.color, tintColor: mainColor)
        case .ModeBackgroundImageOppositeMode:
            return ImageViewStyle(borderColor: modeColor.cgColor, backgroundColor: modeColor, tintColor: oppositeModeColor)
        case .ClearBackgroundUnselectedTintedImage:
            return ImageViewStyle(borderColor: UIColor.clear.cgColor, backgroundColor: UIColor.clear, tintColor: unselectedTabColor)
        case .ClearBackgroundImageViewTintVisibleAgainstTheme:
            return ImageViewStyle(borderColor: UIColor.clear.cgColor, backgroundColor: UIColor.clear, tintColor: tintVisibleColorAgainstTheme)
        }
    }
}
