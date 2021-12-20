//
//  FeedType7CollectionViewDelegate.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

extension FeedType7CollectionViewDelegate: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) { //horizontal scrolling logic (left to right)
        let width = scrollView.frame.width
        let contentSizeWidth = scrollView.contentSize.width
        let offset = scrollView.contentOffset.x
        
        let prefetchFactor:CGFloat = 0.8 //start getting more results before getting all the way to the bottom of current results --> much smoother with this - 0.5 for vertical scroll
        let reachedOffsetRight = (offset + width >= contentSizeWidth * prefetchFactor)
        
        if reachedOffsetRight {
            self.feedViewModel?.getMoreResults(completion: { [weak self] in
                self?.setAsDelegateForImageTasks()
                self?.collectionView?.reloadData()
            })
        }
        
        let reachedRight = (offset + width == contentSizeWidth)

        if reachedRight {
            self.feedViewModel?.getMoreResults(completion: { [weak self] in
                self?.setAsDelegateForImageTasks()
                self?.collectionView?.reloadData()
            })
        }
    }
}

class FeedType7CollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ImageTaskDownloadedDelegate {
    
    //MARK: Properties
    weak var collectionView:UICollectionView? //weak reference to the collectionView this uses, so that this can handle reloads
    weak var navigationDelegate:NavigatorDelegate?
    
    var feedViewModel:FeedViewModelType? { //feed needs to be type 7
        didSet {
            if let feedViewModel = self.feedViewModel, let elements = feedViewModel.feed.elements, case .seven(let feedType7Elements) = elements{
                self.movies = feedType7Elements
            }
        }
    }
    
    var imageTasks = [Int: ImageTask]()
    
    var movies:[MovieModel] {
        didSet {
            setAsDelegateForImageTasks()
        }
    }
    
    //MARK: Initialization
    init(feedViewModel:FeedViewModelType?, navigationDelegate: NavigatorDelegate?){
        self.feedViewModel = feedViewModel
        
        if let feedViewModel = self.feedViewModel, let elements = feedViewModel.feed.elements, case .seven(let feedType7Elements) = elements{
            self.movies = feedType7Elements
        }
        else {
            self.movies = [MovieModel]()
        }
        
        self.navigationDelegate = navigationDelegate
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seriesSearchResultTextUnderCollectionViewCell", for: indexPath) as! SeriesSearchResultTextUnderCollectionViewCell
            
            cell.seriesViewModel = movies[indexPath.row]
            cell.seriesNameLabel.font = self.latestCellTitleFont
            
            feedViewModel?.singeImageTasks[indexPath.row]?.downloadedImageDelegate = cell //cell will handle updating it's image on download completion (this only needs to happen when the cell has already been loaded and is displayed before the image has downloaded) -- this way the PaginatedAllSeriesCollectionViewDelegate doesn't need to be the delegate for the image tasks

            if let image = feedViewModel?.singeImageTasks[indexPath.row]?.image {
                cell.thumbnailImage.image = image.withRoundedCorners(radius: 5.0)
                
                cell.thumbnailImage.backgroundColor = UIColor.random(close:AppStyleGenerator.getTheme().palette.mainColor, by: 0.20)
                cell.thumbnailImage.contentMode = .scaleAspectFill
            }
            else {
                cell.thumbnailImage.image = nil
                cell.thumbnailImage.backgroundColor = UIColor.random(close:AppStyleGenerator.getTheme().palette.mainColor, by: 0.20)
                cell.thumbnailImage.contentMode = .scaleAspectFill
            }
            
            cell.restyle()
            return cell
    }
    
    //MARK: UICollectionViewDelegateFlowLayout methods -- for sizing
    let horizontalSpacing:CGFloat = 10.0
    
    static let numberOfColumns:CGFloat = ScreenManager.sharedInstance.width > 600 ? 5.2 : 3.2 //on iPads there will be one more column
    
    var cellTitleFont: UIFont? = UIFont(name: "HelveticaNeue-Bold", size: 8.0)
    var latestCellTitleFont: UIFont? = UIFont(name: "HelveticaNeue-Bold", size: 8.0)
    var collectionViewFrame:CGRect = .zero
    func updateCellFont() {
        cellTitleFont = GridCellSizeCalculator.getSeriesLabelFont(numberOfColumns: FeedType7CollectionViewDelegate.numberOfColumns, collectionViewFrame: collectionViewFrame)
        latestCellTitleFont = GridCellSizeCalculator.getSeriesLabelFont(numberOfColumns: FeedType7CollectionViewDelegate.numberOfColumns, collectionViewFrame: collectionViewFrame, withUpdateAlert: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns:CGFloat = 3.5
        let numberOfRows:CGFloat = 1.0
        
        let portraitSize = GridCellSizeCalculator.getSizeForGridCell(numberOfColumns: FeedType7CollectionViewDelegate.numberOfColumns, collectionViewFrame: collectionView.frame, cellTitleFont: cellTitleFont?.lineHeight ?? 15.0, showTitlesInsideThumbnails: feedViewModel?.showTitlesInsideThumbnails ?? false)
        return portraitSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    //FOR HORIZONTAL COLLECTIONVIEW
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return GridCellSizeCalculator.spacing
    }
    
    var fetchingMovieById:Bool = false
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !fetchingMovieById {
            fetchingMovieById = true
            Network.shared.fetchMovieDetailBy(id: movies[indexPath.row].id) { [weak self] result in
                switch result {
                case .success(let movie):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
                        self.navigationDelegate?.navigate(to: MovieDetailViewController(viewModel: movie), replace: false)
                    }
                case .failure(let error):
                    print("failed -- \(error)")
                }
                self?.fetchingMovieById = false
            }
        }
    }
    
    //MARK: Delegate methods for managing image downloading
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        feedViewModel?.singeImageTasks[indexPath.row]?.resume()
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        feedViewModel?.singeImageTasks[indexPath.row]?.pause()
        feedViewModel?.singeImageTasks[indexPath.row]?.downloadedImageDelegate = nil //clear out the delegate so cell is never populated with wrong image on reuse
    }
    
    //no longer used
    private func setImageTasks() {
        imageTasks = [Int: ImageTask]()
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        for index in 0..<movies.count {
            if let thumbnailURL = movies[index].thumbnail, let url = URL(string: thumbnailURL) {
                let imageTask = ImageTask(position: index, url: url, session: session, delegate: self)
                imageTasks[index] = imageTask
            }
        }
    }
    
    private func setAsDelegateForImageTasks(){
        if let feedViewModel = self.feedViewModel {
            for imageTask in feedViewModel.singeImageTasks.values {
                imageTask.delegate = self
            }
        }
    }
    
    //Don't use this anymore, the cell will act as it's own ImageTaskDownloadedDelegate to update the image after download, reloadItems can cause a crash
    func imageDownloaded(position: Int) {
        //self.collectionView?.reloadItems(at: [IndexPath(row: position, section: 0)])
    }
}
