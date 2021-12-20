//
//  AppUIElement.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import Foundation

//enum listing all ui elements (that are necessary to be listed individually)
//let's try to keep the cases to a minimum

struct AppUIElement {
    //UIViews -- ViewStyle cases
    enum View:Int {
        case View,
        ViewLibraryListingEtcExample,
        BarViewBackground,
        ModeViewBackground,
        ModeViewBackgroundLighterThemeOutlined,
        SlightyOffsetModeViewBackground,
        OppositeModeViewBackground,
        BarDividerView,
        BarViewBackgroundDividerOutlined,
        ThemedViewBackground,
        LighterThemedViewBackground,
        UnreadStatusBackground,
        DownloadedStatusBackground,
        InProgressStatusBackground,
        CompleteReadStatusBackground,
        SettingCellBackground,
        TappableBackground,
        ContentBackground,
        NewContentBackground,
        NewInfoBackground,
        CodeBlockBackground
    }
    
    //UILabel -- LabelStyle cases
    enum Label:Int {
       case Label,
       ClearBackgroundLabelAgainstModeColor,
       ClearBackgroundLabelAgainstOppositeModeColor,
       ClearBackgroundLabelThemedAgainstModeColor,
       ClearBackgroundTextVisibleAgainstThemedLabel,
       ThemedBackgroundLabel,
       ModeBackgroundThemedLabel,
       ModeBackgroundThemedBorderThemedLabel,
       ModeBackgroundLabel,
       DarkModeBackgroundLabel,
       OppositeModeBackgroundLabel,
       UnreadStatusBackgroundThemedBorderLabel,
       InProgressReadStatusBackgroundThemedBorderLabel,
       CompleteReadStatusBackgroundThemedBorderLabel,
       DownloadedStatusBackgroundLabel,
       DownloadedStatusTextModeBackgroundLabel,
       ReadStatusTextModeBackgroundLabel,
       UnreadStatusTextModeBackgroundLabel,
       ContentBackgroundLabel,
       NewContentBackgroundLabel,
       NewContentBackgroundSubtitleLabel,
       NewContentBackgroundThemedLabel,
       ContentBackgroundThemedLabel,
       ClearBackgroundLabelUnselectedLabel,
       CodeBlockTextBackgroundLabel,
       CodeBlockBackgroundLabel,
       NewModeBackgroundSubtitleLabel,
       NewInfoTextBackgroundSubtitleLabel,
       NewInfoTextBackgroundLabel
    }
    
    //UIButton -- ButtonStyle cases
    enum Button:Int {
       case Button,
       ClearBackgroundButtonAgainstModeColor,
       ClearBackgroundButtonThemedAgainstModeColor,
       ThemedBackgroundButton,
       ModeBackgroundThemedButton,
       ModeBackgroundButton,
       OppositeModeBackgroundButton,
       ClearBackgroundVisibleAgainstTheme
    }
    
    //UIImageView -- ImageViewStyle cases
    enum ImageView:Int {
        case ImageView,
        ClearBackgroundImageViewThemedAgainstModeColor,
        ClearBackgroundImageView,
        ClearBackgroundOppositeModeTintedImageView,
        NewClearBackgroundSubtitleTintedImageView,
        ClippedBackgroundImageViewThemedAgainstImageBackground,
        ClippedModeBackgroundImageViewWithThemedBorder,
        ClippedOppositeModeBackgroundImageViewWithThemedBorder,
        ModeBackgroundImageView,
        ModeBackgroundImageThemed, //other color will be mode
        LightModeBackgroundImageThemed, //other color will always be white
        ThemedBackgroundImageMode,
        ModeBackgroundImageOppositeMode,
        ClearBackgroundUnselectedTintedImage,
        ClearBackgroundImageViewTintVisibleAgainstTheme
    }
    
    //UISearchBar -- SearchBarStyle cases
    enum SearchBar:Int {
        case SearchBar,
        BarBackgroundSearchBarThemedAgainstModeColor
    }
    
    //TabBarTabView -- TabBarTabViewStyle cases
    enum TabBarTabView:Int {
        case TabBarTabView,
        BarBackgroundTabBarTabViewAgainstModeColor
    }
    
    enum SegmentedControl:Int {
        case SelectedThemedAgainstModeColor
        case SelectedThemedAgainstClearBackgroundColor
    }
    
    enum RoundShadowView:Int {
        case RoundShadowViewAgainstModeBackground
        case RoundShadoveViewReadingInProgressAgainstModeBackground
        case RoundShadoveViewReadingThemedShadowAgainstModeBackground
             
    }
}
