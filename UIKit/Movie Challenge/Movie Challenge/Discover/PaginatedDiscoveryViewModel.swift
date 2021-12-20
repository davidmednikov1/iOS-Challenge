//
//  PaginatedDiscoveryViewModel.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import Foundation
import UIKit

enum MovieSortOptions:String {
    case title
    case popularity
    case rating
    case releaseDate="release date"
    case runtime
    case budget
    var graphQLSort:String {
        switch self {
        case .title:
            return "title"
        case .popularity:
            return "popularity"
        case .rating:
            return "voteAverage"
        case .releaseDate:
            return "releaseDate"
        case .runtime:
            return "runtime"
        case .budget:
            return "budget"
        }
    }
    var graphQLSortDirection:Sort {
        switch self {
        case .title,.runtime,.budget:
            return .asc
        case .popularity,.rating,.releaseDate:
            return .desc
        }
    }
}

protocol FeedsViewModelType: class {
    var feedViewModels:[FeedViewModelType] { get }
}

enum SearchResult {
    case succeeded
    case failed
}

enum PaginatedDiscoveryViewModelSearchState {
    case searching
    case failed
    case succeeded
    case firstSearching
}
class PaginatedDiscoveryViewModelState {
    var searchState:PaginatedDiscoveryViewModelSearchState
    var lastSearchResult:SearchResult = .succeeded
    init(searchState:PaginatedDiscoveryViewModelSearchState){
        self.searchState = searchState
    }
}

protocol PaginatedSelectSortViewModelType: class {
    var sortOptions:[MovieSortOptions] { get set }
    var selectedSort:MovieSortOptions { get set }
    func selectSort(option:MovieSortOptions) -> ()
    var updateSortOptionsCompletion: (() -> ())? { get set }
}

protocol PaginatedDiscoveryViewModelType: class, PaginatedSelectSortViewModelType, FeedsViewModelType {
    
    var feeds:[JSONFeed] { get set }
    func updateFeeds(completion: @escaping () -> ())
        
    var genres:[String] { get }
    
    var updateFeedsCompletion:(() -> ())? { get set }
    
    var latestUpdates:[MovieModel] { get }
    func getInitialLatestUpdates()
    var initialLatestUpdatesCompletion:((Bool) -> ())? { get set }
    var moreLatestUpdatesCompletion:(() -> ())? { get set }
    func getMoreLatestUpdates(completion: (() -> ())?)
    var latestUpdatesHasNextPage:Bool { get } //use to fetch more if after filtering / resizing we don't have enough content to scroll still
    
    var searchResultsFeedViewModel:FeedViewModel? { get }
    func updateSearch(query: String, completion: (() -> ())?)
    
    var numberOfColumns:CGFloat { get set }
    var cellTitleFont:UIFont? { get }
    var latestCellTitleFont:UIFont? { get }
    var collectionViewFrame:CGRect { get set }
    func updateCellFont()
    
    var state:PaginatedDiscoveryViewModelState { get }
    var stateChangedCompletion:(() -> ())? { get set }
}

class PaginatedDiscoveryViewModel: PaginatedDiscoveryViewModelType {
    var state:PaginatedDiscoveryViewModelState = PaginatedDiscoveryViewModelState(searchState: .firstSearching)
    var stateChangedCompletion:(() -> ())?
    
    var lastRequestSuccess: Bool = true
    var numberOfColumns: CGFloat = 3.0
    
    var cellTitleFont: UIFont? = UIFont(name: ViewGenerator.boldFont, size: 8.0)
    var latestCellTitleFont:UIFont? = UIFont(name: ViewGenerator.boldFont, size: 8.0)
    var collectionViewFrame: CGRect = .zero
    func updateCellFont() {
        cellTitleFont = GridCellSizeCalculator.getRotatableSeriesLabelFont(numberOfColumns: numberOfColumns, collectionViewFrame: collectionViewFrame)
        latestCellTitleFont = GridCellSizeCalculator.getRotatableSeriesLabelFont(numberOfColumns: numberOfColumns, collectionViewFrame: collectionViewFrame, withUpdateAlert: true)
    }
    
    var searchResultsFeedViewModel:FeedViewModel?
    
    func updateSearch(query: String, completion: (() -> ())?){
        self.query = query
        
        if !isSearching {
            isSearching = true
            Network.shared.fetchMoviesBy(search: query) { [weak self] result in
                switch result {
                case .success(let movies):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        let moviesInSearchFeed = JSONFeed(title: query, elements: .seven(movies))
                        let moviesInSearchFeedViewModel = FeedViewModel(feed: moviesInSearchFeed, showTitlesInsideThumbnails: false)
                        self.searchResultsFeedViewModel = moviesInSearchFeedViewModel
                        completion?()
                    }
                case .failure(_):
                    print("failed")
                }
                self?.isSearching = false
            }
        }
    }
    
    var latestUpdates:[MovieModel] = [MovieModel]()
    var currentLatestUpdatesPage:Int = 0
    var latestUpdatesHasNextPage:Bool = true
    var latestUpdatesNextPage:Int = 0
    var initialLatestUpdatesCompletion:((Bool) -> ())?
    var moreLatestUpdatesCompletion:(() -> ())?
    func getInitialLatestUpdates() {
        
        print("getInitialLatestUpdates start currentLatestUpdatesPage -- \(currentLatestUpdatesPage), latestUpdatesNextPage -- \(latestUpdatesNextPage), latestUpdatesHasNextPage -- \(latestUpdatesHasNextPage)")
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            Network.shared.apollo.fetch(query: PagedAllMoviesQuery(limit: 5, offset: 0, orderBy: self.selectedSort.graphQLSort, sort: self.selectedSort.graphQLSortDirection)) { result in
                switch result {
                  case .success(let graphQLResult):
                    print("Found \(graphQLResult.data?.movies?.count ?? 0) movies")
                    if let movies = graphQLResult.data?.movies {
                        self.latestUpdates = movies.map({MovieModel(id: $0?.id ?? 0, title: $0?.title ?? "Untitled", thumbnail: $0?.posterPath, rating: $0?.voteAverage)})
                        self.currentLatestUpdatesPage = 1 //pages start at 1
                        self.latestUpdatesHasNextPage = movies.count > 0
                        self.latestUpdatesNextPage = 2
                        self.initialLatestUpdatesCompletion?(true) //completion with success = true
                    }
                    
                    //if self.feedViewModels.count > 0 && self.feedViewModels[1].feed.type == "7" { //latestUpdates
                        print("call feedResetCompletion from getInitialResults -- \(self.feedViewModels)")
                        self.feedViewModels[2].feed = JSONFeed(title: "All Movies", elements: .seven(self.latestUpdates))
                        self.feedViewModels[2].feedResetCompletion?()
                    //}
                    
                  case .failure(let error):
                    print("Error getting movies: \(error.localizedDescription)")
                    self.getInitialLatestUpdates()
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    /*self.feedViewModels = self.feeds.map({ jsonFeed in
                        FeedViewModel(feed: jsonFeed, showTitlesInsideThumbnails: false)
                    })*/
                    self.updateFeedsCompletion?()
                }
                
            }
        }
    }
    
    var requestInProgress:Bool = false
    var gettingMoreLatestUpdates:Bool = false
    lazy var pagedAllMoviesQuery:PagedAllMoviesQuery = PagedAllMoviesQuery(limit: 5, offset: 0, orderBy: self.selectedSort.graphQLSort, sort: self.selectedSort.graphQLSortDirection)
    func getMoreLatestUpdates(completion: (() -> ())? = nil){
        
        print("getMoreLatestUpdates start gettingMoreLatestUpdates -- \(gettingMoreLatestUpdates), currentLatestUpdatesPage -- \(currentLatestUpdatesPage), latestUpdatesNextPage -- \(latestUpdatesNextPage), latestUpdatesHasNextPage -- \(latestUpdatesHasNextPage)")
        if currentLatestUpdatesPage == 0  || requestInProgress  || !latestUpdatesHasNextPage{
            return //you can't get more results until the initialResults have loaded
            //you also can't get more results if you are already trying to get more results
        }
        
        requestInProgress = true
        pagedAllMoviesQuery = PagedAllMoviesQuery(limit: 5, offset: (self.latestUpdatesNextPage - 1) * 5, orderBy: self.selectedSort.graphQLSort, sort: self.selectedSort.graphQLSortDirection)
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            Network.shared.apollo.fetch(query: self.pagedAllMoviesQuery) { result in
                switch result {
                  case .success(let graphQLResult):
                    print("Found \(graphQLResult.data?.movies?.count ?? 0) movies")
                    if let movies = graphQLResult.data?.movies {
                        self.latestUpdates += movies.map({MovieModel(id: $0?.id ?? 0, title: $0?.title ?? "Untitled", thumbnail: $0?.posterPath, rating: $0?.voteAverage)})
                        self.currentLatestUpdatesPage = self.currentLatestUpdatesPage + 1 //pages start at 1
                        self.latestUpdatesHasNextPage = movies.count > 0
                        self.latestUpdatesNextPage = self.latestUpdatesNextPage + 1
                        self.initialLatestUpdatesCompletion?(true)
                    }
                    
                    if self.feedViewModels.count > 1 && self.feedViewModels[2].feed.type == "7" {
                        print("call feedResetCompletion from getInitialResults")
                        self.feedViewModels[2].feed = JSONFeed(title: "All Movies", elements: .seven(self.latestUpdates))
                        self.feedViewModels[2].setImageTasks()
                    }
                    
                  case .failure(let error):
                    print("Error getting movies: \(error.localizedDescription)")
                    //self.getMoreLatestUpdates(completion: completion)
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    /*self.feedViewModels = self.feeds.map({ jsonFeed in
                        FeedViewModel(feed: jsonFeed, showTitlesInsideThumbnails: false)
                    })*/
                    self.updateFeedsCompletion?()
                    
                    self.requestInProgress = false //whether request failed or not, we are done
                    completion?() //for detail list
                }
                
            }
        }
        
    }
    
    var isSearching:Bool = false
    var all:[MovieModel] = [MovieModel]()
    
    var feeds: [JSONFeed] = [JSONFeed]()
    var feedViewModels: [FeedViewModelType] = {
        
        let initialTopMoviesFeed = JSONFeed(title: "Top Movies", elements: .one([MovieModel]()))
        let initialTopMoviesFeedViewModel = FeedViewModel(feed: initialTopMoviesFeed, showTitlesInsideThumbnails: false)
        
        let initialGenresFeed = JSONFeed(title: "Genres", elements: .two(["Comedy","Ha Ha","Strategy","Tragedy"]))
        let initialGenresFeedViewModel = FeedViewModel(feed: initialGenresFeed, showTitlesInsideThumbnails: false)
        
        let initialLatestUpdatesFeed = JSONFeed(title: "All Movies", elements: .seven([MovieModel]()))
        let initialLatestUpdatesFeedViewModel = FeedViewModel(feed: initialLatestUpdatesFeed, showTitlesInsideThumbnails: false)
        
        return [initialTopMoviesFeedViewModel, initialGenresFeedViewModel, initialLatestUpdatesFeedViewModel]
    }()
    
    var topMovies: [MovieModel] = [MovieModel]()
    var genres:[String] = [String]()
    
    func fetchGenresCompletion(_ result: Result<[String],Error>){
        switch result {
        case .success(let genres):
            self.genres = genres
            self.feedViewModels[1].feed = JSONFeed(title: "Genres", elements: .two(self.genres))
            self.updateFeedsCompletion?()
        case .failure(_):
            //try again?
            Network.shared.fetchGenres(completion: { [weak self] in self?.fetchGenresCompletion($0)})
        }
    }
    
    init(feeds: [JSONFeed]){
        self.feeds = feeds
        Network.shared.fetchGenres(completion: { [weak self] in self?.fetchGenresCompletion($0)})
    }
    
    //[Int: ImageTask]() -- feed 1 - 4 (list/latest/etc -- one image per cell)
    //[Int: [ImageTask]]() -- feed 5 - 6 (list/auth list -- multiple images per cell)
    var topMoviesQuery:TopMoviesQueryQuery = TopMoviesQueryQuery(limit: 5)
    func updateFeeds(completion: @escaping () -> ()) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            let currentSourceLatestUpdatesFeed = JSONFeed(title: "All Movies", elements: .seven(self.latestUpdates))
            let currentSourceLatestUpdatesFeedViewModel = FeedViewModel(feed: currentSourceLatestUpdatesFeed, showTitlesInsideThumbnails: false)
            currentSourceLatestUpdatesFeedViewModel.pagedFeedUpdaterDelegate = LatestUpdatesPagedFeedUpdaterDelegate(paginatedDiscoveryViewModel: self)
            
            Network.shared.apollo.fetch(query: self.topMoviesQuery) { result in
                switch result {
                  case .success(let graphQLResult):
                    print("Found \(graphQLResult.data?.movies?.count ?? 0) movies")
                    if let movies = graphQLResult.data?.movies {
                        self.topMovies = movies.map({MovieModel(id: $0?.id ?? 0, title: $0?.title ?? "Untitled", thumbnail: $0?.posterPath, rating: $0?.voteAverage)})
                    }
                  case .failure(let error):
                    print("Error getting movies: \(error.localizedDescription)")
                    self.updateFeeds(completion: completion)
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.feedViewModels = [FeedViewModel(feed: JSONFeed(title: "Top 5 Movies", elements: .one(self.topMovies)), showTitlesInsideThumbnails: false), self.feedViewModels[1], currentSourceLatestUpdatesFeedViewModel]
                    self.feedViewModels[2].feed = JSONFeed(title: "All Movies", elements: .seven(self.latestUpdates)) //in case it is updated after this
                    self.updateFeedsCompletion?()
                }
            }
            
        }
    }
    
    var updateSortOptionsCompletion: (() -> ())?
    var sortOptions: [MovieSortOptions] = [.title,.popularity,.rating,.releaseDate,.runtime,.budget]
    var selectedSort: MovieSortOptions = .title
    
    func selectSort(option: MovieSortOptions) {
        self.selectedSort = option
        Network.shared.sortPreference = option
        self.getInitialLatestUpdates()
    }
    
    var updateFeedsCompletion: (() -> ())?
    
    private var query:String = ""
    
    var searchInProgress:Bool = false
}



class LatestUpdatesPagedFeedUpdaterDelegate:PagedFeedUpdaterDelegate {
    weak var paginatedDiscoveryViewModel:PaginatedDiscoveryViewModelType?
    
    func getMoreResults(completion: (() -> ())?) {
        self.paginatedDiscoveryViewModel?.getMoreLatestUpdates(completion: completion)
    }
    
    init(paginatedDiscoveryViewModel:PaginatedDiscoveryViewModelType?){
        self.paginatedDiscoveryViewModel = paginatedDiscoveryViewModel
    }
}

