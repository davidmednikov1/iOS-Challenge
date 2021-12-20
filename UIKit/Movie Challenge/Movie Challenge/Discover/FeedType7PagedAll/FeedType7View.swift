//
//  FeedType7View.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

class FeedType7View:UIView {
    
    var viewModel:FeedViewModelType! {
        didSet {
            titleLabel.text = viewModel.feed.title.capitalized
            subtitleLabel.text = viewModel.feed.subtitle ?? ""
                self.feedType7CollectionViewDelegate.feedViewModel = viewModel
                self.feedType7CollectionViewDelegate.collectionView = self.feedType7CollectionView //to allow reloads
                self.feedType7CollectionView.reloadData()
        }
    }
    
    weak var navigationDelegate:NavigatorDelegate? {
        didSet {
            self.feedType7CollectionViewDelegate.navigationDelegate = self.navigationDelegate
        }
    }
    
    let titleLabel:UILabel = ViewGenerator.getUILabel(appUIElement: .NewContentBackgroundLabel, size: .medium, border: .normal, align: .left, appFont: .bold, scalable: false)
    let subtitleLabel:UILabel = ViewGenerator.getUILabel(appUIElement: .NewContentBackgroundSubtitleLabel, size: .small, border: .normal, align: .left)
    
    let viewAllCenteringView:UIView = ViewGenerator.getUIView(appUIElement: .NewContentBackground)
    
    var viewAllLabel: UILabel = ViewGenerator.getUILabel(appUIElement: .NewContentBackgroundThemedLabel, text: "View All", size: .small, border: .normal, align: .center, touchable: true)
    
    var feedType7CollectionViewDelegate:FeedType7CollectionViewDelegate! = FeedType7CollectionViewDelegate(feedViewModel: nil/*, viewModel: [FeedType7ViewModel]()*/, navigationDelegate: nil)
    lazy var collectionViewLayout:UICollectionViewLayout = ViewGenerator.getUICollectionViewFlowLayout(scrollDirection: .horizontal)
    lazy var feedType7CollectionView:UICollectionView = ViewGenerator.getUICollectionView(appUIElement: .NewContentBackground, collectionViewLayout: self.collectionViewLayout, registry: ["seriesSearchResultTextUnderCollectionViewCell":SeriesSearchResultTextUnderCollectionViewCell.self], delegate: self.feedType7CollectionViewDelegate, dataSource: self.feedType7CollectionViewDelegate)
    
    func restyle(){
        self.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        titleLabel.style(AppStyleGenerator.getLabelStyle(for: .NewContentBackgroundLabel))
        subtitleLabel.style(AppStyleGenerator.getLabelStyle(for: .NewContentBackgroundSubtitleLabel))
        viewAllLabel.style(AppStyleGenerator.getLabelStyle(for: .NewContentBackgroundThemedLabel))
        viewAllCenteringView.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        
        feedType7CollectionView.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        feedType7CollectionView.reloadData() //will trigger styling in all collectionViewCells
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAutoLayout()
        
        feedType7CollectionViewDelegate.collectionView = self.feedType7CollectionView
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard Initializer not implemented")
    }
    
    private static let inset:CGFloat = 5.0
    private static let subtitleLabelHeight:CGFloat = 15.0
    private static let titleLabelHeight:CGFloat = 25.0

    public static let feedType7CollectionViewWidth:CGFloat = WholeFeedType7CollectionViewCell.wholeFeedType7CollectionViewCellWidth - (FeedType7View.inset * 2.0) //calculated here -- the width available to the collectionView
    
    static let cellTitleFont: UIFont? = GridCellSizeCalculator.getSeriesLabelFont(numberOfColumns: FeedType7CollectionViewDelegate.numberOfColumns, collectionViewFrame: CGRect(x: 0, y: 0, width: feedType7CollectionViewWidth, height: 50.0)) //IDK if height actually matters..
    
    private static func feedType7CollectionViewHeight(showTitlesInsideThumbnails:Bool) -> CGFloat {
        return GridCellSizeCalculator.getSizeForGridCell(numberOfColumns: FeedType7CollectionViewDelegate.numberOfColumns, collectionViewFrame: CGRect(x: 0, y: 0, width: feedType7CollectionViewWidth, height: 0), cellTitleFont: cellTitleFont?.lineHeight ?? 15.0, showTitlesInsideThumbnails: showTitlesInsideThumbnails).height
    }
    
    public static let verticalSpaceBetweenTitlesAndCollectionView:CGFloat = 15.0
    
    public static func feedType7ViewHeight(showTitlesInsideThumbnails:Bool) -> CGFloat {
        return inset + subtitleLabelHeight + titleLabelHeight + verticalSpaceBetweenTitlesAndCollectionView + feedType7CollectionViewHeight(showTitlesInsideThumbnails:showTitlesInsideThumbnails) + inset
    }
    
    func setupAutoLayout(){
        
        self.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        self.addSubview(viewAllCenteringView)
        self.addSubview(titleLabel)
        self.addSubview(viewAllLabel)
        self.addSubview(subtitleLabel)
        self.addSubview(feedType7CollectionView)
        let inset:CGFloat = 5.0
        
        viewAllCenteringView.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive=true
        viewAllCenteringView.bottomAnchor.constraint(equalTo: subtitleLabel.bottomAnchor).isActive=true
        viewAllCenteringView.constrainLeftAndRightTo(view: titleLabel)
        
        viewAllLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -FeedType7View.inset).isActive=true
        viewAllLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive=true
        viewAllLabel.centerYAnchor.constraint(equalTo: viewAllCenteringView.centerYAnchor).isActive=true
        viewAllLabel.heightAnchor.constraint(equalToConstant: FeedType7View.titleLabelHeight).isActive=true
        
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: FeedType7View.inset).isActive=true
        titleLabel.rightAnchor.constraint(equalTo: viewAllLabel.leftAnchor, constant: -FeedType7View.inset).isActive=true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: FeedType7View.inset).isActive=true
        titleLabel.heightAnchor.constraint(equalToConstant: FeedType7View.titleLabelHeight).isActive=true
        
        subtitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: FeedType7View.inset).isActive=true
        //subtitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset).isActive=true
        subtitleLabel.rightAnchor.constraint(equalTo: viewAllLabel.leftAnchor, constant: -FeedType7View.inset).isActive=true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive=true
        subtitleLabel.heightAnchor.constraint(equalToConstant: FeedType7View.subtitleLabelHeight).isActive=true
        
        feedType7CollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: FeedType7View.inset).isActive=true
        feedType7CollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -FeedType7View.inset).isActive=true
        feedType7CollectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: FeedType7View.verticalSpaceBetweenTitlesAndCollectionView).isActive=true
        feedType7CollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -FeedType7View.inset).isActive=true
        
        let viewTapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewSeriesForFeed(_:)))
        viewTapGestureRecognizer.numberOfTapsRequired = 1
        viewAllLabel.addGestureRecognizer(viewTapGestureRecognizer)
    }
    
    @objc func viewSeriesForFeed(_ tapGesture:UITapGestureRecognizer){
        self.navigationDelegate?.navigate(to: PaginatedSeriesListDetailViewController(viewModel: self.viewModel, title: "\(viewModel?.feed.title.capitalized ?? "Untitled")"), replace: false)
    }
    
    var didLayoutSubviews:Bool = false
    override func layoutSubviews() {
        //super must be called first
        super.layoutSubviews()
        //if !didLayoutSubviews{
            //layouts based on frames
            //do stuff you wanna do
            self.feedType7CollectionViewDelegate.collectionViewFrame = feedType7CollectionView.frame
            self.feedType7CollectionViewDelegate.updateCellFont() // set initial font sizing
            self.feedType7CollectionView.reloadData() //reloading after setting font
            didLayoutSubviews = true
        //}
    }
}
