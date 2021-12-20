//
//  FeedType2CollectionViewDelegate.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

class FeedType2CollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: Properties
    weak var collectionView:UICollectionView? //weak reference to the collectionView this uses, so that this can handle reloads
    weak var navigationDelegate:NavigatorDelegate?
    
    var feedViewModel:FeedViewModelType? {
        didSet {
            if let feedViewModel = self.feedViewModel, let elements = feedViewModel.feed.elements, case .two(let feedType1Elements) = elements{
                self.genres = feedType1Elements
            }
        }
    }
    var genres:[String] = [String]()
    var imageTasks = [Int: ImageTask]()
    
    
    //MARK: Initialization
    init(feedViewModel:FeedViewModelType?, navigationDelegate: NavigatorDelegate?){
        self.feedViewModel = feedViewModel
        self.navigationDelegate = navigationDelegate
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "insetBasicTextCollectionViewCell", for: indexPath) as! InsetBasicTextCollectionViewCell
        
        cell.textLabel.text = genres[indexPath.row]
        cell.textIsSelected = false
        
        cell.heightForCorners = collectionView.frame.height
        return cell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout methods -- for sizing
    let horizontalSpacing:CGFloat = 10.0
    
    static let numberOfColumns:CGFloat = ScreenManager.sharedInstance.width > 600 ? 5.2 : 3.2 //on iPads there will be one more column
    
    var cellTitleFont: UIFont? = UIFont(name: "HelveticaNeue-Bold", size: 8.0)
    var latestCellTitleFont: UIFont? = UIFont(name: "HelveticaNeue-Bold", size: 8.0)
    var collectionViewFrame:CGRect = .zero
    func updateCellFont() {
        cellTitleFont = GridCellSizeCalculator.getSeriesLabelFont(numberOfColumns: FeedType1CollectionViewDelegate.numberOfColumns, collectionViewFrame: collectionViewFrame)
        latestCellTitleFont = GridCellSizeCalculator.getSeriesLabelFont(numberOfColumns: FeedType1CollectionViewDelegate.numberOfColumns, collectionViewFrame: collectionViewFrame, withUpdateAlert: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemSize = genres[indexPath.row].size(withAttributes: [
            NSAttributedString.Key.font : UIFont(name: ViewGenerator.regularFont, size: 20.0)
        ])
        
        var extraHeight:CGFloat = 10.0
        var extraWidth:CGFloat = 40.0
        
        return CGSize(width: itemSize.width + extraWidth, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    /*//FOR HORIZONTAL COLLECTIONVIEW
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return GridCellSizeCalculator.spacing
    }*/
    
    //FOR VERITCAL COLLECTIONVIEW - minimumInteritemSpacingForSectionAt
    
    var fetchingMoviesForGenre:Bool = false
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !fetchingMoviesForGenre {
            fetchingMoviesForGenre = true
            Network.shared.fetchMoviesBy(genre: genres[indexPath.row]) { [weak self] result in
                switch result {
                case .success(let movies):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        let moviesInGenreFeed = JSONFeed(title: self.genres[indexPath.row], elements: .seven(movies))
                        let moviesInGenreFeedViewModel = FeedViewModel(feed: moviesInGenreFeed, showTitlesInsideThumbnails: false)
                        self.navigationDelegate?.navigate(to: PaginatedSeriesListDetailViewController(viewModel: moviesInGenreFeedViewModel, title: self.genres[indexPath.row]), replace: false)
                    }
                case .failure(_):
                    print("failed")
                }
                self?.fetchingMoviesForGenre = false
            }
        }
    }
}
