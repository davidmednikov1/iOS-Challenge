//
//  FeedType1View.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

class FeedType1View:UIView {
    
    var viewModel:FeedViewModelType! {
        didSet {
            titleLabel.text = viewModel.feed.title
            subtitleLabel.text = viewModel.feed.subtitle ?? ""
            self.feedType1CollectionViewDelegate.feedViewModel = viewModel
            self.feedType1CollectionView.reloadData()
        }
    }
    
    weak var navigationDelegate:NavigatorDelegate? {
        didSet {
            self.feedType1CollectionViewDelegate.navigationDelegate = self.navigationDelegate
        }
    }
    
    let titleLabel:UILabel = ViewGenerator.getUILabel(appUIElement: .NewContentBackgroundLabel, size: .medium, border: .normal, align: .left, appFont: .bold, scalable: false)
    let subtitleLabel:UILabel = ViewGenerator.getUILabel(appUIElement: .NewContentBackgroundSubtitleLabel, size: .small, border: .normal, align: .left)
    
    var viewAllLabel: UILabel = ViewGenerator.getUILabel(appUIElement: .NewContentBackgroundThemedLabel, text: "View All", size: .small, border: .normal, align: .center, touchable: true)
    
    
    var feedType1CollectionViewDelegate:FeedType1CollectionViewDelegate! = FeedType1CollectionViewDelegate(feedViewModel: nil, navigationDelegate: nil)
    lazy var collectionViewLayout:UICollectionViewLayout = ViewGenerator.getUICollectionViewFlowLayout(scrollDirection: .horizontal)
    lazy var feedType1CollectionView:UICollectionView = ViewGenerator.getUICollectionView(appUIElement: .NewContentBackground, collectionViewLayout: self.collectionViewLayout, registry: ["seriesSearchResultTextUnderCollectionViewCell":SeriesSearchResultTextUnderCollectionViewCell.self], delegate: self.feedType1CollectionViewDelegate, dataSource: self.feedType1CollectionViewDelegate)
    
    func restyle(){
        self.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        titleLabel.style(AppStyleGenerator.getLabelStyle(for: .NewContentBackgroundLabel))
        subtitleLabel.style(AppStyleGenerator.getLabelStyle(for: .NewContentBackgroundSubtitleLabel))
        viewAllLabel.style(AppStyleGenerator.getLabelStyle(for: .NewContentBackgroundThemedLabel))
        
        feedType1CollectionView.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        feedType1CollectionView.reloadData() //will trigger styling in all collectionViewCells
        //feedType1CollectionView.reloadSections(IndexSet(Array(0...0))) //reload all sections -- this doesn't make a difference need to force restyle in cellForRowAt

    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAutoLayout()
        
        feedType1CollectionViewDelegate.collectionView = self.feedType1CollectionView
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard Initializer not implemented")
    }
    
    private static let inset:CGFloat = 5.0
    private static let titleLabelHeight:CGFloat = 25.0

    public static let feedType1CollectionViewWidth:CGFloat = WholeFeedType1CollectionViewCell.wholeFeedType1CollectionViewCellWidth - (FeedType1View.inset * 2.0) //calculated here -- the width available to the collectionView
    
    static let cellTitleFont: UIFont? = GridCellSizeCalculator.getSeriesLabelFont(numberOfColumns: FeedType1CollectionViewDelegate.numberOfColumns, collectionViewFrame: CGRect(x: 0, y: 0, width: feedType1CollectionViewWidth, height: 50.0))
    
    private static func feedType1CollectionViewHeight(showTitlesInsideThumbnails:Bool) -> CGFloat {
        return GridCellSizeCalculator.getSizeForGridCell(numberOfColumns: FeedType1CollectionViewDelegate.numberOfColumns, collectionViewFrame: CGRect(x: 0, y: 0, width: feedType1CollectionViewWidth, height: 0), cellTitleFont: cellTitleFont?.lineHeight ?? 15.0, showTitlesInsideThumbnails: showTitlesInsideThumbnails).height
    }

    public static let verticalSpaceBetweenTitlesAndCollectionView:CGFloat = 15.0
    
    public static func feedType1ViewHeight(showTitlesInsideThumbnails:Bool) -> CGFloat {
        return inset + titleLabelHeight + verticalSpaceBetweenTitlesAndCollectionView + feedType1CollectionViewHeight(showTitlesInsideThumbnails:showTitlesInsideThumbnails)
    }
    
    func setupAutoLayout(){
        self.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        self.addSubview(titleLabel)
        self.addSubview(viewAllLabel)
        self.addSubview(feedType1CollectionView)
        let inset:CGFloat = 5.0
        
        viewAllLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset).isActive=true
        viewAllLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2).isActive=true
        viewAllLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset).isActive=true
        viewAllLabel.heightAnchor.constraint(equalToConstant: FeedType1View.titleLabelHeight).isActive=true
        
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: inset).isActive=true
        titleLabel.rightAnchor.constraint(equalTo: viewAllLabel.leftAnchor, constant: -inset).isActive=true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset).isActive=true
        titleLabel.heightAnchor.constraint(equalToConstant: FeedType1View.titleLabelHeight).isActive=true
        
        feedType1CollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: inset).isActive=true
        feedType1CollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset).isActive=true
        feedType1CollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: FeedType1View.verticalSpaceBetweenTitlesAndCollectionView).isActive=true
        feedType1CollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        
        let viewTapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewSeriesForFeed(_:)))
        viewTapGestureRecognizer.numberOfTapsRequired = 1
        viewAllLabel.addGestureRecognizer(viewTapGestureRecognizer)
        viewAllLabel.isHidden = true
    }
    
    @objc func viewSeriesForFeed(_ tapGesture:UITapGestureRecognizer){
    }
    
    var didLayoutSubviews:Bool = false
    override func layoutSubviews() {
        //super must be called first
        super.layoutSubviews()
        //if !didLayoutSubviews{
            //layouts based on frames
            //do stuff you wanna do
            self.feedType1CollectionViewDelegate.collectionViewFrame = feedType1CollectionView.frame
            self.feedType1CollectionViewDelegate.updateCellFont() // set initial font sizing
            self.feedType1CollectionView.reloadData() //reloading after setting font
            didLayoutSubviews = true
        //}
    }
}
