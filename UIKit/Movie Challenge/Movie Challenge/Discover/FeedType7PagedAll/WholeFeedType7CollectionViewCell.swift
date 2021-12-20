//
//  WholeFeedType7CollectionViewCell.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

class WholeFeedType7CollectionViewCell:UICollectionViewCell {
    
    var viewModel:FeedViewModelType! {
        didSet {
            feedType7View.viewModel = viewModel
        }
    }
    
    weak var navigationDelegate:NavigatorDelegate? {
        didSet {
            feedType7View.navigationDelegate = self.navigationDelegate
        }
    }
    
    let feedType7View:FeedType7View = {
        let feedType7View = FeedType7View()
        feedType7View.translatesAutoresizingMaskIntoConstraints = false
        
        return feedType7View
    }()
    
    func restyle(){
        self.contentView.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        feedType7View.restyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard Initializer not implemented")
    }
    
    private static let inset:CGFloat = 5.0
    public static let wholeFeedType7CollectionViewCellWidth:CGFloat = ScreenManager.sharedInstance.width - (WholeFeedType7CollectionViewCell.inset * 2.0) //calculated here -- the width available to the collectionView

    func setupAutoLayout(){
        self.contentView.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        self.contentView.addSubview(feedType7View)
        
        let inset:CGFloat = 5.0
        
        feedType7View.leftAnchor.constraint(equalTo: leftAnchor, constant: inset).isActive=true
        feedType7View.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset).isActive=true
        feedType7View.topAnchor.constraint(equalTo: topAnchor).isActive=true
        feedType7View.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
}
