//
//  WholeFeedTypeGenresCollectionViewCell.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

class WholeFeedTypeGenresCollectionViewCell:UICollectionViewCell {
    
    var viewModel:FeedViewModelType! {
        didSet {
            feedType2View.viewModel = viewModel
        }
    }
    
    weak var navigationDelegate:NavigatorDelegate? {
        didSet {
            feedType2View.navigationDelegate = self.navigationDelegate
        }
    }
    
    let feedType2View:FeedType2View = {
        let feedType2View = FeedType2View()
        feedType2View.translatesAutoresizingMaskIntoConstraints = false
        
        return feedType2View
    }()
    
    func restyle(){
        self.contentView.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        feedType2View.restyle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard Initializer not implemented")
    }
    
    private static let inset:CGFloat = 5.0
    public static let wholeFeedTypeGenresCollectionViewCellWidth:CGFloat = ScreenManager.sharedInstance.width - (WholeFeedTypeGenresCollectionViewCell.inset * 2.0) //calculated here -- the width available to the collectionView

    func setupAutoLayout(){
        self.contentView.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        self.contentView.addSubview(feedType2View)
        
        let inset:CGFloat = 5.0
        
        feedType2View.leftAnchor.constraint(equalTo: leftAnchor, constant: inset).isActive=true
        feedType2View.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset).isActive=true
        feedType2View.topAnchor.constraint(equalTo: topAnchor).isActive=true
        feedType2View.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
}
