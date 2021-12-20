//
//  WholeFeedType1CollectionViewCell.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

class WholeFeedType1CollectionViewCell:UICollectionViewCell {
    
    var viewModel:FeedViewModelType! {
        didSet {
            feedType1View.viewModel = viewModel
        }
    }
    
    weak var navigationDelegate:NavigatorDelegate? {
        didSet {
            feedType1View.navigationDelegate = self.navigationDelegate
        }
    }
    
    let feedType1View:FeedType1View = {
        let feedType1View = FeedType1View()
        feedType1View.translatesAutoresizingMaskIntoConstraints = false
        
        return feedType1View
    }()
    
    func restyle(){
        self.contentView.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        feedType1View.restyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard Initializer not implemented")
    }
    
    private static let inset:CGFloat = 5.0
    public static let wholeFeedType1CollectionViewCellWidth:CGFloat = ScreenManager.sharedInstance.width - (WholeFeedType1CollectionViewCell.inset * 2.0) //calculated here -- the width available to the collectionView

    func setupAutoLayout(){
        self.contentView.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        self.contentView.addSubview(feedType1View)
        
        let inset:CGFloat = 5.0
        
        feedType1View.leftAnchor.constraint(equalTo: leftAnchor, constant: inset).isActive=true
        feedType1View.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset).isActive=true
        feedType1View.topAnchor.constraint(equalTo: topAnchor).isActive=true
        feedType1View.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
}
