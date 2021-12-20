//
//  MovieDetailView.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//


import UIKit

protocol PopUpPresenterDelegate: class {
    func presentPopUp(viewController: UIViewController)
}

class SeriesDetailInfoTabView: UIView {
    var selectedGenre:String?
    
    var index:Int = 0
    weak var navigationDelegate:NavigatorDelegate?
    weak var popUpPresenterDelegate:PopUpPresenterDelegate?
    
    weak var viewModel:MovieDetailViewModelType? {
        didSet {
            setupDisplayOnViewModelDidSet()
        }
    }
    
    //will ticker for long titles
    lazy var titleLabel: MarqueeLabel = {
        let marquee = MarqueeLabel(frame: .zero, rate: 30, fadeLength: 10.0) //rate is pixels per second to scroll
        marquee.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        marquee.textColor = AppStyleGenerator.getMode().oppositeColor
        marquee.textAlignment = .center
        marquee.backgroundColor = UIColor.clear
        //marquee.type = .continuous //this is the default
        marquee.translatesAutoresizingMaskIntoConstraints = false
        return marquee
    }()
    
    //start left labels
    var genresAboveLabel: UILabel = ViewGenerator.getUILabel(appUIElement: .ClearBackgroundLabelAgainstModeColor, text: "Genres", size: .small, border: .normal, align: .left, appFont: .bold)
    //end left labels
    
    //start right labels (actual info)
    lazy var directorLabel: UILabel = ViewGenerator.getUILabel(appUIElement: .ClearBackgroundLabelAgainstModeColor, text: "", size: .small, border: .normal, align: .left)
    lazy var ratingLabel: UILabel = ViewGenerator.getUILabel(appUIElement: .ClearBackgroundLabelAgainstModeColor, text: "", size: .small, border: .normal, align: .left)
    
    var descriptionTextView: UITextView = {
        let biographyTextView:UITextView = UITextView()
        biographyTextView.isEditable = false
        biographyTextView.translatesAutoresizingMaskIntoConstraints = false
        biographyTextView.font = UIFont(name: "HelveticaNeue", size: 15)
        biographyTextView.style(AppStyleGenerator.getLabelStyle(for: .ClearBackgroundLabelAgainstModeColor))
        
        return biographyTextView
    }()

    let readMoreOrLessLabel:UILabel = ViewGenerator.getUILabel(appUIElement: .NewContentBackgroundSubtitleLabel, text: "Expand", size: .small, border: .normal, align: .right, touchable: true, appFont: .regular)
    
    lazy var verticalScrollView:UIScrollView = { //[unowned self] in
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = AppStyleGenerator.getMode().newContentBackgroundColor
        //v.delegate = self
        v.panGestureRecognizer.minimumNumberOfTouches = 1
        v.minimumZoomScale = 1.0
        v.maximumZoomScale = 1.0
        v.isScrollEnabled=true
        v.isPagingEnabled = true
        return v
    }()
    
    let genresHeaderLabel:UILabel = SeriesDetailInfoTabView.headerLabel(text: "Genres")
    var genresCollectionViewLayout:UICollectionViewLayout = ViewGenerator.getUICollectionViewFlowLayout(scrollDirection: .horizontal)
    lazy var genresCollectionViewDataSourceAndDelegate:BasicTextCollectionViewDataSourceAndDelegate = BasicTextCollectionViewDataSourceAndDelegate(viewModel: [String](), basicTextCellSelectedDelegate: nil)
    lazy var genresLabel: UICollectionView = ViewGenerator.getUICollectionView(collectionViewLayout: self.genresCollectionViewLayout, registry: ["insetBasicTextCollectionViewCell":InsetBasicTextCollectionViewCell.self], delegate: self.genresCollectionViewDataSourceAndDelegate, dataSource: self.genresCollectionViewDataSourceAndDelegate, background: .clear)
    
    lazy var aboutTitleHorizontalStackView:UIStackView = ViewGenerator.getUIStackView(subviews: [SeriesDetailInfoTabView.headerLabel(text: "About Series"), self.readMoreOrLessLabel], axis: .horizontal, distribution: .fill, alignment: .fill)
    
    lazy var descriptionLabel:PaddingLabel = { [unowned self] in
        let commentLabel = ViewGenerator.getPaddingLabel(appUIElement: .NewInfoTextBackgroundLabel, textEdgeInsets:  UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15), text: "", size: .small, border: .rounded, align: .left)
        commentLabel.minimumScaleFactor = 0.9
        commentLabel.numberOfLines = 0
        
        return commentLabel
    }()
    
    let directorHeaderLabel:UILabel = SeriesDetailInfoTabView.headerLabel(text: "Director")
    lazy var directorHorizontalStackView:UIStackView = ViewGenerator.getUIStackView(subviews: [self.directorLabel], axis: .horizontal, distribution: .fill, alignment: .fill, spacing: 10.0)
    
    let castHeaderLabel:UILabel = SeriesDetailInfoTabView.headerLabel(text: "Cast")
    var castCollectionViewLayout:UICollectionViewLayout = ViewGenerator.getUICollectionViewFlowLayout(scrollDirection: .horizontal)
    lazy var castCollectionViewDataSourceAndDelegate:BasicTextCollectionViewDataSourceAndDelegate = BasicTextCollectionViewDataSourceAndDelegate(viewModel: [String](), basicTextCellSelectedDelegate: nil)
    lazy var castLabel: UICollectionView = ViewGenerator.getUICollectionView(collectionViewLayout: self.genresCollectionViewLayout, registry: ["insetBasicTextCollectionViewCell":InsetBasicTextCollectionViewCell.self], delegate: self.castCollectionViewDataSourceAndDelegate, dataSource: self.castCollectionViewDataSourceAndDelegate, background: .clear)
    
    let ratingHeaderLabel:UILabel = SeriesDetailInfoTabView.headerLabel(text: "Rating")
    lazy var ratingHorizontalStackView:UIStackView = ViewGenerator.getUIStackView(subviews: [self.ratingLabel], axis: .horizontal, distribution: .fill, alignment: .fill, spacing: 10.0)
    lazy var arrangedSubviews:[UIView] = { [unowned self] in
        var arrangedSubviews:[UIView] = [UIView]()
        arrangedSubviews += [genresHeaderLabel, genresLabel]
        
        arrangedSubviews += [aboutTitleHorizontalStackView, descriptionLabel, directorHeaderLabel, directorHorizontalStackView, castHeaderLabel, castLabel, ratingHeaderLabel, ratingHorizontalStackView]
        
        return arrangedSubviews
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
    
    static func heightForDescription(expanded: Bool) -> CGFloat {
        if expanded {
            return heightForDescriptionTextView
        }
        else {
            return heightForDescriptionLabel
        }
    }
    static let heightForDescriptionLabel:CGFloat = 80.0
    static let heightForDescriptionTextView:CGFloat = 180.0
    static let spaceForDescriptionLabel:CGFloat = 10.0
    
    static let titleLabelHeight:CGFloat = 40.0
    static let spacing:CGFloat = 5.0
    
    public static func totalHeight(descriptionExpanded:Bool, hasSeriesEntity:Bool) -> CGFloat {
        if hasSeriesEntity {
            return SeriesDetailInfoTabView.immutableHeightWithSeriesEntity + SeriesDetailInfoTabView.heightForDescription(expanded: descriptionExpanded) + SeriesDetailInfoTabView.spaceForDescriptionLabel
        }
        else {
            return SeriesDetailInfoTabView.immutableHeight + SeriesDetailInfoTabView.heightForDescription(expanded: descriptionExpanded) + SeriesDetailInfoTabView.spaceForDescriptionLabel
        }
    }
    
    var thumbnailImageContainerDescriptionCollapsedBottomAnchor:NSLayoutConstraint?
    var thumbnailImageContainerDescriptionExpandedBottomAnchor:NSLayoutConstraint?
    
    
    static let verticalInsetWithUpdateBubble:CGFloat = 15.0
    
    static let genresHeight:CGFloat = 42.0
    static let castHeight:CGFloat = 42.0
    
    static let inset:CGFloat = 20.0
    static let thumbnailImageContainerHeight:CGFloat = 110.0
    static let seriesInfoHorizontalStackViewSingleRowHeight:CGFloat = 25.0
    static let spaceBeforeDescription:CGFloat = 5.0
    static let immutableHeightWithSeriesEntity:CGFloat = SeriesDetailInfoTabView.verticalInsetWithUpdateBubble + GridCellSizeCalculator.getThumbnailHeight(width: SeriesDetailInfoTabView.thumbnailImageContainerHeight).height + SeriesDetailInfoTabView.inset /*space between image and genres*/ + SeriesDetailInfoTabView.genresHeight + SeriesDetailInfoTabView.inset + SeriesDetailInfoTabView.castHeight + spaceBeforeDescription
    static let immutableHeight:CGFloat = SeriesDetailInfoTabView.verticalInsetWithUpdateBubble + GridCellSizeCalculator.getThumbnailHeight(width: SeriesDetailInfoTabView.thumbnailImageContainerHeight).height + SeriesDetailInfoTabView.inset /*space between image and genres*/ + SeriesDetailInfoTabView.genresHeight + SeriesDetailInfoTabView.inset + SeriesDetailInfoTabView.castHeight + spaceBeforeDescription
    
    static let heightForCollapsedDescriptionLabel:CGFloat = 80.0

    static func headerLabel(text: String) -> UILabel {
        return ViewGenerator.getUILabel(appUIElement: .NewContentBackgroundLabel, text: text, size: .medium, border: .normal, align: .left, appFont: .bold)
    }
    
    let showTitlesInsideThumbnails = false
    
    func setUpAutoLayout() {
        self.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        
        self.addSubview(verticalScrollView)
        verticalScrollView.constrainSidesTo(view: self)
        
        var verticalStackView:UIStackView = ViewGenerator.getUIStackView(subviews: self.arrangedSubviews, axis: .vertical, distribution: .fill, alignment: .fill, spacing: 15.0)
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let dummyView:UIView = ViewGenerator.getUIView(appUIElement: .NewContentBackground)
        verticalScrollView.addSubview(dummyView)
        
        dummyView.constrainSidesTo(view: verticalScrollView)
        dummyView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive=true
        
        dummyView.addSubview(verticalStackView)
        verticalStackView.constrainLeftAndRightTo(view: dummyView, inset: SeriesDetailInfoTabView.inset)
        verticalStackView.topAnchor.constraint(equalTo: dummyView.topAnchor).isActive=true
        verticalStackView.bottomAnchor.constraint(equalTo: dummyView.bottomAnchor, constant: -SeriesDetailInfoTabView.inset).isActive=true
        
        //simplified
        genresLabel.heightAnchor.constraint(equalToConstant: SeriesDetailInfoTabView.genresHeight).isActive=true
        castLabel.heightAnchor.constraint(equalToConstant: SeriesDetailInfoTabView.genresHeight).isActive=true
        
        descriptionLabelCollapsedHeightConstraint = descriptionLabel.heightAnchor.constraint(equalToConstant: SeriesDetailInfoTabView.heightForCollapsedDescriptionLabel)
        descriptionLabelCollapsedHeightConstraint?.isActive=true
        descriptionLabelExpandedHeightConstraint = descriptionLabel.heightAnchor.constraint(equalToConstant: SeriesDetailInfoTabView.heightForDescriptionTextView)
        
        readMoreOrLessLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(readMoreOrLess)))
    }
    
    var descriptionLabelCollapsedHeightConstraint:NSLayoutConstraint?
    var descriptionLabelExpandedHeightConstraint:NSLayoutConstraint?
    
    @objc func readMoreOrLess(){
        if viewModel?.descriptionExpanded ?? false {
            readLess()
        }
        else {
            readMore()
        }
    }
    @objc func readLess(){
        viewModel?.descriptionExpanded = false
        updateDescriptionConstraints()
    }
    @objc func readMore(){
        viewModel?.descriptionExpanded = true
        updateDescriptionConstraints()
    }
    
    
    func updateDescriptionConstraints(){
        if viewModel?.descriptionExpanded ?? false {
            descriptionLabelCollapsedHeightConstraint?.isActive=false
            descriptionLabelExpandedHeightConstraint?.isActive=true
            readMoreOrLessLabel.text = "Collapse"
        }
        else {
            descriptionLabelCollapsedHeightConstraint?.isActive=true
            descriptionLabelExpandedHeightConstraint?.isActive=false
            readMoreOrLessLabel.text = "Expand"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("no xib for LibrarySeriesDetailHeaderCollectionReusableView")
    }
    
    func setupDisplayOnViewModelDidSet(){
        directorLabel.text = self.viewModel?.director ?? ""
        var rating = self.viewModel?.rating ?? 0.0
        
        ratingLabel.text = rating > 0 ? "\(rating)" : ""
        descriptionLabel.text = self.viewModel?.description ?? ""
        descriptionTextView.text = self.viewModel?.description ?? ""
        
        if viewModel?.descriptionExpanded ?? false {
            descriptionLabelCollapsedHeightConstraint?.isActive=false
            descriptionLabelExpandedHeightConstraint?.isActive=true
            readMoreOrLessLabel.text = "Collapse"
        }
        else {
            descriptionLabelCollapsedHeightConstraint?.isActive=true
            descriptionLabelExpandedHeightConstraint?.isActive=false
            readMoreOrLessLabel.text = "Expand"
        }
        
        genresCollectionViewDataSourceAndDelegate.viewModel = self.viewModel?.genres ?? [String]()
        castCollectionViewDataSourceAndDelegate.viewModel = self.viewModel?.cast ?? [String]()
        
        genresCollectionViewDataSourceAndDelegate.selectedText = ""
        
        genresLabel.reloadData()
        castLabel.reloadData()
        
        if descriptionLabel.text?.isEmpty ?? true {
            aboutTitleHorizontalStackView.isHidden = true
            descriptionLabel.isHidden = true
        }
        else {
            aboutTitleHorizontalStackView.isHidden = false
            descriptionLabel.isHidden = false
        }
            
        if directorLabel.text?.isEmpty ?? true {
            directorLabel.isHidden = true
            directorHeaderLabel.isHidden = true
            directorHorizontalStackView.isHidden = true
        }
        else {
            directorLabel.isHidden = false
            directorHeaderLabel.isHidden = false
            directorHorizontalStackView.isHidden = false
        }
        
        if ratingLabel.text?.isEmpty ?? true {
            ratingLabel.isHidden = true
            ratingHeaderLabel.isHidden = true
            ratingHorizontalStackView.isHidden = true
        }
        else {
            ratingLabel.isHidden = false
            ratingHeaderLabel.isHidden = false
            ratingHorizontalStackView.isHidden = false
        }
    }
}
