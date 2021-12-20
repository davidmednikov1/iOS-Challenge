//
//  ViewGenerator.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

enum FontSize {
    case extraSmall
    case almostExtraSmall
    case small
    case medium
    case large
}
enum BorderStyle {
    case normal
    case rounded
}
enum ColorTheme {
    case light
    case dark
}
enum TextBackground {
    case light //means dark text on light background
    case dark //means white text on dark background
    case clear //for image overlay on source detail
}

class ViewGenerator {
    static let regularFont:String = "Avenir-Book" //"HelveticaNeue"
    static let boldFont:String = "Avenir-Heavy" //"HelveticaNeue-Bold"
    
    //MARK: OutlinedLabel
    static func getOutlinedLabel(text: String = "", size: FontSize, border: BorderStyle, background: TextBackground, theme: ColorTheme, align: NSTextAlignment) -> OutlinedLabel {
        let label = OutlinedLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = align
        label.adjustsFontSizeToFitWidth = true
        label.text = text
        label.minimumScaleFactor = CGFloat (0.1)
        label.numberOfLines = 1
        switch size {
            case .extraSmall:
                label.font = UIFont(name: regularFont, size: 10)
            case .almostExtraSmall:
                label.font = UIFont(name: regularFont, size: 13)
            case .small:
                label.font = UIFont(name: regularFont, size: 15)
            case .medium:
                label.font = UIFont(name: regularFont, size: 20)
            case .large:
                label.font = UIFont(name: regularFont, size: 30)
        }
        
        switch background {
            case .clear:
                label.backgroundColor = UIColor.clear
                label.textColor = UIColor.white
            case .dark:
                label.backgroundColor = UIColor.black
                label.textColor = UIColor.white
            case .light:
                label.backgroundColor = UIColor.white
                label.textColor = UIColor.black
        }
        
        switch border {
            case .normal:
                break
            case .rounded:
                label.layer.cornerRadius = 8
                label.layer.masksToBounds = true //corners won't should up rounded without this
        }
        
        return label
    }
    
    static func getPaddingLabel(appUIElement:AppUIElement.Label, textEdgeInsets:UIEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2), text: String = "", size: FontSize, border: BorderStyle, align: NSTextAlignment, touchable: Bool = false, appFont:AppFont = .regular) -> PaddingLabel {
        
        let label = PaddingLabel(textEdgeInsets:textEdgeInsets, labelUIElement: appUIElement)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = align
        label.adjustsFontSizeToFitWidth = true
        label.text = text
        label.minimumScaleFactor = CGFloat (0.1)
        label.numberOfLines = 1
        label.isUserInteractionEnabled = touchable
        
        var fontName:String = ""
        switch appFont {
        case .regular:
            fontName = regularFont
        case .bold:
            fontName = boldFont
        }
        switch size {
            case .extraSmall:
                label.font = UIFont(name: fontName, size: 10)
            case .almostExtraSmall:
                label.font = UIFont(name: fontName, size: 13)
            case .small:
                label.font = UIFont(name: fontName, size: 15)
            case .medium:
                label.font = UIFont(name: fontName, size: 20)
            case .large:
                label.font = UIFont(name: fontName, size: 30)
        }
        
        
        label.style(AppStyleGenerator.getLabelStyle(for: appUIElement))
        
        switch border {
            case .normal:
                break
            case .rounded:
                label.layer.cornerRadius = 8
                label.layer.masksToBounds = true //corners won't should up rounded without this
        }
        
        return label
    }
    
    //MARK: UILabel
    static func getMenuLabel(text: String = "", size: FontSize, border: BorderStyle, background: TextBackground, theme: ColorTheme, align: NSTextAlignment) -> UILabel {
        let label = ViewGenerator.getUILabel(text: text, size: size, border: border, background: background, theme: theme, align: align)
        
        label.baselineAdjustment = .alignCenters //this fixes the text being cut-off on the bottom
        label.isUserInteractionEnabled = true
        
        return label
    }
    
    static func getUILabel(appUIElement:AppUIElement.Label, text: String = "", size: FontSize, border: BorderStyle, align: NSTextAlignment, touchable: Bool = false, appFont:AppFont = .regular, scalable:Bool = true) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = align
        label.adjustsFontSizeToFitWidth = true
        label.text = text
        if scalable {
            label.minimumScaleFactor = CGFloat (0.1)
        }
        else {
            label.minimumScaleFactor = CGFloat (0.9)
        }
        label.numberOfLines = 1
        label.isUserInteractionEnabled = touchable
        
        var fontName:String = ""
        switch appFont {
        case .regular:
            fontName = regularFont
        case .bold:
            fontName = boldFont
        }
        switch size {
            case .extraSmall:
                label.font = UIFont(name: fontName, size: 10)
            case .almostExtraSmall:
                label.font = UIFont(name: fontName, size: 13)
            case .small:
                label.font = UIFont(name: fontName, size: 15)
            case .medium:
                label.font = UIFont(name: fontName, size: 20)
            case .large:
                label.font = UIFont(name: fontName, size: 30)
        }
        
        
        label.style(AppStyleGenerator.getLabelStyle(for: appUIElement))
        
        switch border {
            case .normal:
                break
            case .rounded:
                label.layer.cornerRadius = 8
                label.layer.masksToBounds = true //corners won't should up rounded without this
        }
        
        return label
    }
    
    static func getUILabel(text: String = "", size: FontSize, border: BorderStyle, background: TextBackground, theme: ColorTheme, align: NSTextAlignment, touchable: Bool = false) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = align
        label.adjustsFontSizeToFitWidth = true
        label.text = text
        label.minimumScaleFactor = CGFloat (0.1)
        label.numberOfLines = 1
        label.isUserInteractionEnabled = touchable
        switch size {
            case .extraSmall:
                label.font = UIFont(name: regularFont, size: 10)
            case .almostExtraSmall:
                label.font = UIFont(name: regularFont, size: 13)
            case .small:
                label.font = UIFont(name: regularFont, size: 15)
            case .medium:
                label.font = UIFont(name: regularFont, size: 20)
            case .large:
                label.font = UIFont(name: regularFont, size: 30)
        }
        
        
        switch background {
            case .clear:
                label.backgroundColor = UIColor.clear
                label.textColor = UIColor.white
            case .dark:
                label.backgroundColor = UIColor.black
                label.textColor = UIColor.white
            case .light:
                label.backgroundColor = UIColor.white
                label.textColor = UIColor.black
        }
        
        
        switch border {
            case .normal:
                break
            case .rounded:
                label.layer.cornerRadius = 8
                label.layer.masksToBounds = true //corners won't should up rounded without this
        }
        
        return label
    }
    
    
    //MARK: UICollectionView, UICollectionViewFlowLayout
    enum CollectionViewBackground {
        case light //means light background
        case dark
        case clear
    }
    
    static func getUICollectionViewFlowLayout(scrollDirection:UICollectionView.ScrollDirection) -> UICollectionViewFlowLayout {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.0 //horizontal spacing between cells
        layout.minimumInteritemSpacing = 0.0 //
        layout.scrollDirection = scrollDirection //default is vertical
        return layout
    }
    
    static func getUICollectionView(appUIElement:AppUIElement.View, collectionViewLayout: UICollectionViewLayout, registry: [String:AnyClass], delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource, headerRegistry: [String:AnyClass]? = nil, footerRegistry: [String:AnyClass]? = nil) -> UICollectionView {
        let collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        for (reuseIdentifier, collectionViewCellClass) in registry {
            collectionView.register(collectionViewCellClass, forCellWithReuseIdentifier: reuseIdentifier)
        }
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.style(AppStyleGenerator.getViewStyle(for: appUIElement))
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        
        //attempt to fix issue where horizontal scroll (feed) inside collectionView doesn't scroll
        #if targetEnvironment(macCatalyst)
        collectionView.isDirectionalLockEnabled = false
        #endif
        
        //for header/footer views in sections
        if let headerRegistry = headerRegistry {
            for (reuseIdentifier, collectionViewCellClass) in headerRegistry {
                collectionView.register(collectionViewCellClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier)
            }
        }
        if let footerRegistry = footerRegistry {
            for (reuseIdentifier, collectionViewCellClass) in footerRegistry {
                collectionView.register(collectionViewCellClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reuseIdentifier)
            }
        }
        
        return collectionView
    }
    
    static func getUICollectionView(collectionViewLayout: UICollectionViewLayout, registry: [String:AnyClass], delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource, background: CollectionViewBackground, headerRegistry: [String:AnyClass]? = nil, footerRegistry: [String:AnyClass]? = nil) -> UICollectionView {
        let collectionView:UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        for (reuseIdentifier, collectionViewCellClass) in registry {
            collectionView.register(collectionViewCellClass, forCellWithReuseIdentifier: reuseIdentifier)
        }
        
        collectionView.showsHorizontalScrollIndicator = false
        
        switch background{
        case .clear:
            collectionView.backgroundColor = UIColor.clear
        case .light:
            collectionView.backgroundColor = UIColor.white
        case .dark:
            collectionView.backgroundColor = UIColor.black
        }
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        
        //for header/footer views in sections
        if let headerRegistry = headerRegistry {
            for (reuseIdentifier, collectionViewCellClass) in headerRegistry {
                collectionView.register(collectionViewCellClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseIdentifier)
            }
        }
        if let footerRegistry = footerRegistry {
            for (reuseIdentifier, collectionViewCellClass) in footerRegistry {
                collectionView.register(collectionViewCellClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: reuseIdentifier)
            }
        }
        
        return collectionView
    }
    
    //MARK: UIStackView
    static func getUIStackView(subviews: [UIView], axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment, spacing: CGFloat = 0.0) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.axis = axis
        stackView.distribution = distribution
        stackView.alignment = alignment
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    //MARK: UIImageView
    enum ImageViewBackground {
        case light //means light background
        case dark
        case clear
    }
    
    static func getUIImageView(appUIElement:AppUIElement.ImageView, image: UIImage?, contentMode: UIView.ContentMode, border: BorderStyle = .normal, isOpaque:Bool = true, alpha:CGFloat = 1.0, touchable:Bool = false) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.contentMode = contentMode
        
        imageView.style(AppStyleGenerator.getImageViewStyle(for: appUIElement))
        
        imageView.isOpaque = isOpaque
        imageView.alpha = alpha
        imageView.isUserInteractionEnabled = touchable
        
        switch border {
        case .normal:
            break
        case .rounded:
            imageView.layer.cornerRadius = 5.0
            imageView.layer.masksToBounds = true
        }
        
        return imageView
    }
    
    
    static func getUIImageView(image: UIImage?, contentMode: UIView.ContentMode, background: ImageViewBackground, border: BorderStyle = .normal, isOpaque:Bool = true, alpha:CGFloat = 1.0) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.contentMode = contentMode
        
        switch background{
        case .clear:
            imageView.backgroundColor = UIColor.clear
        case .light:
            imageView.backgroundColor = UIColor.white
        case .dark:
            imageView.backgroundColor = UIColor.black
        }
        
        imageView.isOpaque = isOpaque
        imageView.alpha = alpha
        
        switch border {
        case .normal:
            break
        case .rounded:
            imageView.layer.cornerRadius = 5.0
            imageView.layer.masksToBounds = true
        }
        
        return imageView
    }
    
    //MARK: UIView
    enum ViewBackground {
        case light //means light background
        case dark
        case clear
    }
    
    static func getStretchView(color: UIColor = UIColor.white) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        return view
    }
    
    static func getStretchView(appUIElement:AppUIElement.View) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style(AppStyleGenerator.getViewStyle(for: appUIElement))
        return view
    }
    
    static func getUIView(appUIElement:AppUIElement.View, border: BorderStyle = .normal, isOpaque:Bool = true, alpha:CGFloat = 1.0) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.style(AppStyleGenerator.getViewStyle(for: appUIElement))
        
        view.isOpaque = isOpaque
        view.alpha = alpha
        
        switch border {
        case .normal:
            break
        case .rounded:
            view.layer.cornerRadius = 5.0
            view.layer.masksToBounds = true
        }
        
        return view
    }
    
    static func getUIView(background: ViewBackground, border: BorderStyle = .normal, isOpaque:Bool = true, alpha:CGFloat = 1.0) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        switch background{
        case .clear:
            view.backgroundColor = UIColor.clear
        case .light:
            view.backgroundColor = UIColor.white
        case .dark:
            view.backgroundColor = UIColor.black
        }
        
        view.isOpaque = isOpaque
        view.alpha = alpha
        
        switch border {
        case .normal:
            break
        case .rounded:
            view.layer.cornerRadius = 5.0
            view.layer.masksToBounds = true
        }
        
        return view
    }
    
    //MARK: UIButton
    static func getUIButton(appUIElement:AppUIElement.Button, title: String = ""/*, size: FontSize*/, border: BorderStyle) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle( title , for: .normal )
        
        button.style(AppStyleGenerator.getButtonStyle(for: appUIElement))
       
        switch border {
            case .normal:
                break
            case .rounded:
                button.layer.cornerRadius = 8
        }
        
        return button
    }
    
    //MARK: UISearchBar
    static func getUISearchBar(placeholder: String, delegate: UISearchBarDelegate) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = placeholder
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = UIColor.clear
        searchBar.delegate = delegate
        return searchBar
    }
    
    //MARK: ScrollableStackView -- basically a scrollView with a stackView inside it that you can mutate to add/remove items from it
    static func getMutatableScrollableStackView(startingViews:[(UIView,CGFloat)], superview:UIView) -> UIStackView {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.clear
        scrollView.panGestureRecognizer.minimumNumberOfTouches = 1
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.0
        
        let backgroundView:UIView =  UIView()
        backgroundView.backgroundColor = AppStyleGenerator.getMode().settingCellBackgroundColor
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.cornerRadius = 8.0
        
        var totalRequiredHeight:CGFloat = 0

        var heightConstraints:[NSLayoutConstraint] = [NSLayoutConstraint]()
        
        for viewHeightPair in startingViews {
            totalRequiredHeight += viewHeightPair.1
            heightConstraints.append(viewHeightPair.0.heightAnchor.constraint(equalToConstant: viewHeightPair.1))
        }
        
        let startingArrangedSubviews = startingViews.map({$0.0})
        let verticalStackView:UIStackView = ViewGenerator.getUIStackView(subviews: startingArrangedSubviews, axis: .vertical, distribution: .fill, alignment: .fill)
        
        superview.addSubview(scrollView)
        scrollView.constrainSidesTo(view: superview)
        
        scrollView.addSubview(backgroundView)
        
        backgroundView.constrainSidesTo(view: scrollView)
        backgroundView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive=true
        backgroundView.heightAnchor.constraint(equalToConstant: totalRequiredHeight).isActive=true
        
        backgroundView.addSubview(verticalStackView)
        verticalStackView.constrainLeftAndRightTo(view: backgroundView)
        verticalStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor).isActive=true
        
        NSLayoutConstraint.activate(heightConstraints)
        return verticalStackView
    }
}
