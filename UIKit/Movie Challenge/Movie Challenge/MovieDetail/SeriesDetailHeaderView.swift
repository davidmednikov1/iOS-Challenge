//
//  SeriesDetailHeaderView.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

class SeriesDetailHeaderView: UIView {
    
    var index:Int = 0
    weak var navigationDelegate:NavigatorDelegate?
    weak var popUpPresenterDelegate:PopUpPresenterDelegate?
    
    weak var viewModel:MovieDetailViewModelType? {
        didSet {
            setupDisplayOnViewModelDidSet()
        }
    }
    
    var thumbnailImageSpinnerView:UIView?
    var thumbnailImageSpinnerIndicatorView:UIView?
    
    func showLoadingSpinnerForDownloadingImage(){
        removeLoadingSpinnerForDownloadedImage()
        let view = thumbnailImage
        
        DispatchQueue.main.async { [weak self] in
            let spinnerView = UIView(frame: view.bounds)
            spinnerView.backgroundColor =  AppStyleMode.dark.color.withAlphaComponent(0.9)
            
            var ai = UIActivityIndicatorView(style: .whiteLarge)
            ai.startAnimating()
            ai.center = spinnerView.center
            ai.color = AppStyleGenerator.getTheme().palette.mainColor
               DispatchQueue.main.async {
                   spinnerView.addSubview(ai)
                    view.addSubview(spinnerView)
               }
            self?.thumbnailImageSpinnerIndicatorView = ai
            self?.thumbnailImageSpinnerView = spinnerView
        }
    }
    func removeLoadingSpinnerForDownloadedImage(){
        DispatchQueue.main.async { [weak self] in
            if let thumbnailImageSpinnerIndicatorView = self?.thumbnailImageSpinnerIndicatorView as? UIActivityIndicatorView{
                thumbnailImageSpinnerIndicatorView.stopAnimating()
                thumbnailImageSpinnerIndicatorView.removeFromSuperview()
            }
            else if let thumbnailImageSpinnerIndicatorView = self?.thumbnailImageSpinnerIndicatorView as? UIImageView {
                thumbnailImageSpinnerIndicatorView.removeFromSuperview()
                
            }
            self?.thumbnailImageSpinnerIndicatorView?.removeFromSuperview()
            self?.thumbnailImageSpinnerView?.removeFromSuperview()
            self?.thumbnailImage.removeAllSubviews()
        }
    }
    
    lazy var thumbnailBackgroundOverlay:UIVisualEffectView = {
        var blur = UIBlurEffect(style: UIBlurEffect.Style.light)
        
        if AppStyleGenerator.getMode() == .dark {
            blur =  UIBlurEffect(style: UIBlurEffect.Style.dark)
        }
        var blurView = UIVisualEffectView(effect: blur)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        blurView.roundCorners([.topLeft,.topRight], radius: 12.0) //this clipsToBounds
        return blurView
    }()
    
    lazy var thumbnailBackgroundImage:UIImageView = {
        let thumbnailBackgroundImage:UIImageView = ViewGenerator.getUIImageView(image: UIImage(named: AssetConstants.IMAGE_NOT_AVAILABLE), contentMode: .scaleAspectFill, background: .dark, isOpaque: false, alpha: 1.0)
        
        thumbnailBackgroundImage.roundCorners([.topLeft,.topRight], radius: 12.0) //this clipsToBounds
        return thumbnailBackgroundImage
    }()
    
    lazy var thumbnailImage:UIImageView = {
        let thumbnailImage = ViewGenerator.getUIImageView(image: nil, contentMode: .scaleAspectFill, background: .clear, border: .rounded)
        thumbnailImage.isUserInteractionEnabled = true
        thumbnailImage.layer.cornerRadius = GridCellSizeCalculator.thumbnailCornerRadius
        thumbnailImage.layer.masksToBounds = true //corners won't should up rounded without this
        
        return thumbnailImage
    }()
    let thumbnailImageContainer:UIView = ViewGenerator.getUIView(background: .clear)
    
    var unreadCountLabelBlurView:UIVisualEffectView = {
        var blur = UIBlurEffect(style: UIBlurEffect.Style.dark)
        var blurView = UIVisualEffectView(effect: blur)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurView
    }()
    var unreadCountLabelBackgroundViewForBlur:UIView = {
        //always dark
        let unreadCountLabelBackgroundViewForBlur:UIView = ViewGenerator.getUIView(appUIElement: .ModeViewBackground)
        unreadCountLabelBackgroundViewForBlur.backgroundColor = AppStyleMode.dark.color.withAlphaComponent(0.3)
        return unreadCountLabelBackgroundViewForBlur
    }()
    
    var unreadCountLabel: ProportionalLabel = {
        let updateCountLabel = ProportionalLabel()
        updateCountLabel.translatesAutoresizingMaskIntoConstraints = false
        updateCountLabel.textAlignment = NSTextAlignment.center
        updateCountLabel.adjustsFontSizeToFitWidth = true
        updateCountLabel.text = "10"
        updateCountLabel.font = UIFont(name: ViewGenerator.regularFont, size: 10)
        updateCountLabel.minimumScaleFactor = CGFloat (0.1)
        updateCountLabel.numberOfLines = 1
        
        updateCountLabel.layer.masksToBounds = true //cornerRadius does not show up without this
        
        updateCountLabel.style(AppStyleGenerator.getLabelStyle(for: .ClearBackgroundTextVisibleAgainstThemedLabel)) //always white basically
        
        updateCountLabel.isUserInteractionEnabled = true //can't add tap recognizer without this
        return updateCountLabel
    }()
    
    //will ticker for long titles
    lazy var titleLabel: MarqueeLabel = {
        let marquee = MarqueeLabel(frame: .zero, rate: 30, fadeLength: 10.0) //rate is pixels per second to scroll
        marquee.font = UIFont(name: ViewGenerator.boldFont, size: 18)
        marquee.textColor = AppStyleGenerator.getMode().oppositeColor
        marquee.textAlignment = .left
        marquee.backgroundColor = UIColor.clear
        //marquee.type = .continuous //this is the default
        marquee.translatesAutoresizingMaskIntoConstraints = false
        return marquee
    }()
    
    init(viewModel:MovieDetailViewModelType, popUpPresenterDelegate:PopUpPresenterDelegate?, navigationDelegate:NavigatorDelegate?){
        self.viewModel = viewModel
        self.popUpPresenterDelegate = popUpPresenterDelegate
        self.navigationDelegate = navigationDelegate
        super.init(frame: .zero)
        setUpAutoLayout()
        setupDisplayOnViewModelDidSet()
        self.titleLabel.text = (self.viewModel?.title ?? "") + " " //space so end is not glued to begginning
    }
    

  
    static let spaceForThumbnailImageContainerLabel:CGFloat = 10.0
    
    static let titleLabelHeight:CGFloat = 40.0
    static let spacing:CGFloat = 13.5
    
    public static func totalHeight() -> CGFloat {
        return SeriesDetailHeaderView.immutableHeight
    }
    
    var thumbnailImageContainerDescriptionCollapsedBottomAnchor:NSLayoutConstraint?
    var thumbnailImageContainerDescriptionExpandedBottomAnchor:NSLayoutConstraint?
    
    private static let updateLabelSize:CGFloat = 23.0
    public static let updateLabelPartOutsideImage:CGFloat = 7.0
    
    static let verticalInsetWithUpdateBubble:CGFloat = 15.0
    
    static let genresHeight:CGFloat = 35.0
    
    static let inset:CGFloat = 20.0
    static let thumbnailImageContainerHeight:CGFloat = 110.0
    static let seriesInfoHorizontalStackViewSingleRowHeight:CGFloat = 25.0
    static let spaceBeforeDescription:CGFloat = 5.0
    static let immutableHeight:CGFloat = 280.0
    
    static let resumeLabelHeight:CGFloat = 25.0
    
    static let thumbnailBackgroundImageHeight:CGFloat = 145.0
    static let thumbnailImageContainerVerticalInsetFromBackgroundImage:CGFloat = 45.0
    static let thumbnailImageContainerWidth:CGFloat = 115.0
    static let horizontalSpacing:CGFloat = 13.5
    static let verticalSpacing:CGFloat = 10.0
    
    func setUpAutoLayout() {
        self.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        
        self.addSubview(thumbnailBackgroundImage)
        thumbnailBackgroundImage.constrainLeftAndRightTo(view: self)
        thumbnailBackgroundImage.topAnchor.constraint(equalTo: topAnchor).isActive=true
        thumbnailBackgroundImage.heightAnchor.constraint(equalToConstant: SeriesDetailHeaderView.thumbnailBackgroundImageHeight).isActive=true
        
        self.addSubview(thumbnailBackgroundOverlay)
        thumbnailBackgroundOverlay.constrainSidesTo(view: thumbnailBackgroundImage)
        thumbnailBackgroundOverlay.isHidden=true
        
        self.addSubview(thumbnailImageContainer)
        thumbnailImageContainer.leftAnchor.constraint(equalTo: self.leftAnchor, constant: SeriesDetailHeaderView.inset).isActive=true
        thumbnailImageContainer.widthAnchor.constraint(equalToConstant: SeriesDetailHeaderView.thumbnailImageContainerWidth).isActive=true
        thumbnailImageContainer.heightAnchor.constraint(equalToConstant: GridCellSizeCalculator.getThumbnailHeight(width: SeriesDetailHeaderView.thumbnailImageContainerWidth).height).isActive=true
        
        thumbnailImageContainer.addSubview(thumbnailImage)
        thumbnailImage.constrainSidesTo(view: thumbnailImageContainer)
        
        self.addSubview(unreadCountLabelBackgroundViewForBlur)
        self.addSubview(unreadCountLabelBlurView)
        self.addSubview(unreadCountLabel)
        let sizeMultiplierForEditSelectLabel:CGFloat = 0.16
        let unreadCountLabelWidth:CGFloat = SeriesDetailHeaderView.updateLabelSize * 1.4
        
        unreadCountLabel.rightAnchor.constraint(equalTo: thumbnailImage.rightAnchor).isActive=true
        unreadCountLabel.topAnchor.constraint(equalTo: thumbnailImage.topAnchor).isActive=true
        
        unreadCountLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: SeriesDetailHeaderView.updateLabelSize).isActive=true
        
        let resizeUnreadCountLabelOnNumberRowChangeContraint = unreadCountLabel.heightAnchor.constraint(equalTo: thumbnailImage.widthAnchor, multiplier: sizeMultiplierForEditSelectLabel)
        resizeUnreadCountLabelOnNumberRowChangeContraint.priority = UILayoutPriority(999) //lower priority than min heightAnchor
        resizeUnreadCountLabelOnNumberRowChangeContraint.isActive=true
        unreadCountLabel.widthAnchor.constraint(equalTo: unreadCountLabel.heightAnchor, multiplier: 1.4).isActive=true
        
        unreadCountLabel.roundCorners([.topRight,.bottomLeft], radius: GridCellSizeCalculator.thumbnailCornerRadius)
        unreadCountLabelBackgroundViewForBlur.roundCorners([.topRight,.bottomLeft], radius: GridCellSizeCalculator.thumbnailCornerRadius)
        unreadCountLabelBlurView.roundCorners([.topRight,.bottomLeft], radius: GridCellSizeCalculator.thumbnailCornerRadius)
        
        unreadCountLabelBackgroundViewForBlur.constrainSidesTo(view: unreadCountLabel)
        unreadCountLabelBlurView.constrainSidesTo(view: unreadCountLabel)
        
        let spacing:CGFloat = 5.0
        self.addSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: thumbnailImage.rightAnchor, constant: SeriesDetailHeaderView.horizontalSpacing).isActive=true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -SeriesDetailHeaderView.inset).isActive=true
        titleLabel.topAnchor.constraint(equalTo: thumbnailBackgroundImage.bottomAnchor, constant: SeriesDetailHeaderView.inset).isActive=true
        titleLabel.heightAnchor.constraint(equalToConstant: SeriesDetailHeaderView.titleLabelHeight).isActive=true
        
        
        thumbnailImageContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -SeriesDetailHeaderView.spaceForThumbnailImageContainerLabel).isActive=true
        
        thumbnailImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showLargeViewOfThumbnailImage)))
    }
    
    @objc func showLargeViewOfThumbnailImage(){
        if let thumbnailImage = self.viewModel?.thumbnailImage {
            popUpPresenterDelegate?.presentPopUp(viewController: ThumbnailPopUpViewController(thumbnail:thumbnailImage))
        }
    }
    
    
    
    var didLayoutSubviews:Bool = false
    override func layoutSubviews() {
        super.layoutSubviews()
        if !didLayoutSubviews {
            //frame based layouts
            didLayoutSubviews = true
            print("SeriesInfoHeaderView didLayoutSubviews")
            thumbnailImage.applyshadowWithCorner(containerView: thumbnailImageContainer, cornerRadious: GridCellSizeCalculator.thumbnailCornerRadius, shadowRadius: 2.5)

            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("no xib for SeriesDetailHeaderView")
    }
    
    func setupDisplayOnViewModelDidSet(){
        if let thumbnailImage = self.viewModel?.thumbnailImage {
            removeLoadingSpinnerForDownloadedImage()
            self.thumbnailImage.image = thumbnailImage.withRoundedCorners(radius: GridCellSizeCalculator.thumbnailCornerRadius)
            self.thumbnailBackgroundImage.image = thumbnailImage
        }
        else {
            //show spinner
            self.thumbnailImage.image = UIImage(color: ColorPalette.InTheGray.g2Gray, size: CGSize(width: GridCellSizeCalculator.widthForRatio, height: GridCellSizeCalculator.heightForRatio))?.withRoundedCorners(radius: GridCellSizeCalculator.thumbnailCornerRadius)
            //showLoadingSpinnerForDownloadingImage()
            self.thumbnailBackgroundImage.image = UIImage(color: AppStyleGenerator.getMode().color)
        }
        
        let unreadCount:Double = self.viewModel?.rating ?? 0
        if unreadCount > 0 {
            unreadCountLabel.text = "\(unreadCount)"
            unreadCountLabel.isHidden = false
        }
        else {
            unreadCountLabel.text = ""
            unreadCountLabel.isHidden = true
        }
    }
}
