//
//  FeedsCollectionViewDataSourceAndDelegate.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

class FeedsCollectionViewDataSourceAndDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK: Properties
    weak var collectionView:UICollectionView? //weak reference to the collectionView this uses, so that this can handle reloads
    weak var navigationDelegate:NavigatorDelegate?
    
    weak var feedsViewModel:FeedsViewModelType? {
        didSet {
            setFeedResetCompletions()
        }
    }
    
    func setFeedResetCompletions(){
        if let feedsViewModel = feedsViewModel {
            for feedViewModel in feedsViewModel.feedViewModels {
                if let elements = feedViewModel.feed.elements, case .seven(let feedType7Elements) = elements{
                    feedViewModel.feedResetCompletion = { [weak self] in
                        DispatchQueue.main.async { [weak self] in
                            feedViewModel.singeImageTasks = [Int: ImageTask]() //clear them out
                            feedViewModel.setImageTasks()
                            self?.collectionView?.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    //MARK: Initialization
    init(feedsViewModel:FeedsViewModelType, navigationDelegate: NavigatorDelegate? = nil){
        self.feedsViewModel = feedsViewModel
        self.navigationDelegate = navigationDelegate
        
        super.init()
        self.setFeedResetCompletions()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedsViewModel?.feedViewModels.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let feedsViewModel = feedsViewModel, let elements = feedsViewModel.feedViewModels[indexPath.row].feed.elements {
            switch elements {
            case .one(_):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wholeFeedType1CollectionViewCell", for: indexPath) as! WholeFeedType1CollectionViewCell
                cell.viewModel = feedsViewModel.feedViewModels[indexPath.row]
                cell.navigationDelegate = self.navigationDelegate
                cell.restyle()
                return cell
            case .two(_):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wholeFeedTypeGenresCollectionViewCell", for: indexPath) as! WholeFeedTypeGenresCollectionViewCell
                cell.viewModel = feedsViewModel.feedViewModels[indexPath.row]
                cell.navigationDelegate = self.navigationDelegate
                cell.restyle()
                return cell
            case .seven(_):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wholeFeedType7CollectionViewCell", for: indexPath) as! WholeFeedType7CollectionViewCell
                cell.viewModel = feedsViewModel.feedViewModels[indexPath.row]
                cell.navigationDelegate = self.navigationDelegate
                cell.restyle()
                return cell
            default:
                return collectionView.dequeueReusableCell(withReuseIdentifier: "blank", for: indexPath) as! UICollectionViewCell
            }
        }
        return  collectionView.dequeueReusableCell(withReuseIdentifier: "blank", for: indexPath) as! UICollectionViewCell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout methods -- for sizing
    let horizontalSpacing:CGFloat = 10.0
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns:CGFloat = 1.0
        let numberOfRows:CGFloat = 2.0
        
        if let feedsViewModel = feedsViewModel, let elements = feedsViewModel.feedViewModels[indexPath.row].feed.elements {
            switch elements {
            case .one(_):
                return CGSize(width: collectionView.frame.width, height: FeedType1View.feedType1ViewHeight(showTitlesInsideThumbnails:false))
            case .two(_):
                return CGSize(width: collectionView.frame.width, height: FeedType2View.feedType2ViewHeight)
            case .seven(_):
                return CGSize(width: collectionView.frame.width, height: FeedType7View.feedType7ViewHeight(showTitlesInsideThumbnails:false))
            default:
                    break
            }
        }
        
        return CGSize(width: collectionView.frame.width / numberOfColumns, height: collectionView.frame.height / numberOfRows)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
    }
    
    //MARK: for header / footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
                return UICollectionReusableView()
        case UICollectionView.elementKindSectionFooter:
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "contentPaddingFooterReusableView", for: indexPath)
                (footerView as? ContentPaddingFooterReusableView)?.restyle()
                return footerView
        default:
            fatalError("Unexpected element kind")
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: 70.0) //so you can always scroll past the bottom of the last feed to see the shadowy edge
    }
}
