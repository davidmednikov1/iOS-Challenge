//
//  FeedType2View.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//


import UIKit

class FeedType2View:UIView {
    
    var viewModel:FeedViewModelType! {
        didSet {
            titleLabel.text = viewModel.feed.title
            subtitleLabel.text = viewModel.feed.subtitle ?? ""
            self.feedType2CollectionViewDelegate.feedViewModel = viewModel
                self.feedType2CollectionView.reloadData()
        }
    }
    
    weak var navigationDelegate:NavigatorDelegate? {
        didSet {
            self.feedType2CollectionViewDelegate.navigationDelegate = self.navigationDelegate
        }
    }
    
    let titleLabel:UILabel = ViewGenerator.getUILabel(appUIElement: .NewContentBackgroundLabel, size: .medium, border: .normal, align: .left, appFont: .bold, scalable: false)
    let subtitleLabel:UILabel = ViewGenerator.getUILabel(appUIElement: .NewContentBackgroundSubtitleLabel, size: .small, border: .normal, align: .left)
    
    
    var feedType2CollectionViewDelegate:FeedType2CollectionViewDelegate! = FeedType2CollectionViewDelegate(feedViewModel: nil, navigationDelegate: nil)
    lazy var collectionViewLayout:UICollectionViewLayout = ViewGenerator.getUICollectionViewFlowLayout(scrollDirection: .horizontal)
    lazy var feedType2CollectionView:UICollectionView = ViewGenerator.getUICollectionView(appUIElement: .NewContentBackground, collectionViewLayout: self.collectionViewLayout, registry: ["insetBasicTextCollectionViewCell":InsetBasicTextCollectionViewCell.self], delegate: self.feedType2CollectionViewDelegate, dataSource: self.feedType2CollectionViewDelegate)
    
    func restyle(){
        self.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        titleLabel.style(AppStyleGenerator.getLabelStyle(for: .NewContentBackgroundLabel))
        subtitleLabel.style(AppStyleGenerator.getLabelStyle(for: .NewContentBackgroundSubtitleLabel))
        
        feedType2CollectionView.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        feedType2CollectionView.reloadData() //will trigger styling in all collectionViewCells
        //feedType1CollectionView.reloadSections(IndexSet(Array(0...0))) //reload all sections -- this doesn't make a difference need to force restyle in cellForRowAt

    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAutoLayout()
        
        feedType2CollectionViewDelegate.collectionView = self.feedType2CollectionView
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard Initializer not implemented")
    }
    
    private static let inset:CGFloat = 5.0
    private static let titleLabelHeight:CGFloat = 25.0

    public static let feedType2CollectionViewWidth:CGFloat = WholeFeedType1CollectionViewCell.wholeFeedType1CollectionViewCellWidth - (FeedType2View.inset * 2.0) //calculated here -- the width available to the collectionView
    
    static let cellTitleFont: UIFont? = GridCellSizeCalculator.getSeriesLabelFont(numberOfColumns: FeedType2CollectionViewDelegate.numberOfColumns, collectionViewFrame: CGRect(x: 0, y: 0, width: feedType2CollectionViewWidth, height: 50.0)) //IDK if height actually matters..
    
    private static let feedType2CollectionViewHeight:CGFloat = 50.0
    
    public static let verticalSpaceBetweenTitlesAndCollectionView:CGFloat = 15.0
    
    public static let feedType2ViewHeight:CGFloat = inset + titleLabelHeight + verticalSpaceBetweenTitlesAndCollectionView + feedType2CollectionViewHeight
    
    func setupAutoLayout(){
        self.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        self.addSubview(titleLabel)
        self.addSubview(feedType2CollectionView)
        let inset:CGFloat = 5.0
        
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: inset).isActive=true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset).isActive=true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset).isActive=true
        titleLabel.heightAnchor.constraint(equalToConstant: FeedType2View.titleLabelHeight).isActive=true
        
        feedType2CollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: inset).isActive=true
        feedType2CollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset).isActive=true
        feedType2CollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: FeedType2View.verticalSpaceBetweenTitlesAndCollectionView).isActive=true
        feedType2CollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    
    var didLayoutSubviews:Bool = false
    override func layoutSubviews() {
        //super must be called first
        super.layoutSubviews()
        //if !didLayoutSubviews{
            //layouts based on frames
            self.feedType2CollectionViewDelegate.collectionViewFrame = feedType2CollectionView.frame
            self.feedType2CollectionViewDelegate.updateCellFont() // set initial font sizing
            self.feedType2CollectionView.reloadData() //reloading after setting font
            didLayoutSubviews = true
        //}
    }
}
