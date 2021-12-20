//
//  DiscoverViewController.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

//MARK: NavigatorDelegate Extension
extension DiscoverViewController: NavigatorDelegate {
    func navigate(to viewController: UIViewController, replace: Bool = false) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: UITextFieldDelegate Extension for FilterSearchHoverBarView
extension DiscoverViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchHoverBarView.searchTextField.resignFirstResponder()
        let searchText = searchHoverBarView.searchTextField.text ?? ""
        
        DispatchQueue.global(qos: .background).async { [unowned self] in
            self.viewModel.updateSearch(query: searchText){
                DispatchQueue.main.async { [weak self] in
                    if let searchResultsFeedViewModel = self?.viewModel.searchResultsFeedViewModel {
                        self?.navigate(to: PaginatedSeriesListDetailViewController(viewModel: searchResultsFeedViewModel, title: searchResultsFeedViewModel.feed.title), replace: false)
                    }
                }

            }
        }
        return true
    }
}

class DiscoverViewController: UIViewController {
    //MARK: Properties
    var fetchingMoviesForSearch:Bool = false
    var viewModel:PaginatedDiscoveryViewModelType!
    lazy var keyboardViewModel:KeyboardViewModel = KeyboardViewModel(willShow: nil, willHide: nil, viewController: self)
    
    lazy var searchHoverBarView:FilterSearchHoverBarView = { [unowned self] in
        let searchHoverBarView:FilterSearchHoverBarView = FilterSearchHoverBarView(keyboardViewModel: self.keyboardViewModel, searchBarTextDelegate: self, placeholder: "Search...")
        searchHoverBarView.translatesAutoresizingMaskIntoConstraints = false
        return searchHoverBarView
    }()
    
    //MARK: Views
    var feedsCollectionViewDataSourceAndDelegate:FeedsCollectionViewDataSourceAndDelegate!
    var feedsCollectionViewLayout:UICollectionViewFlowLayout = ViewGenerator.getUICollectionViewFlowLayout(scrollDirection: .vertical)
    lazy var feedsCollectionView:UICollectionView = ViewGenerator.getUICollectionView(appUIElement: .NewContentBackground, collectionViewLayout: self.feedsCollectionViewLayout, registry: ["wholeFeedType1CollectionViewCell":WholeFeedType1CollectionViewCell.self,"wholeFeedTypeGenresCollectionViewCell":WholeFeedTypeGenresCollectionViewCell.self,"wholeFeedType7CollectionViewCell":WholeFeedType7CollectionViewCell.self,"blank":UICollectionViewCell.self], delegate: self.feedsCollectionViewDataSourceAndDelegate, dataSource: self.feedsCollectionViewDataSourceAndDelegate, footerRegistry: ["contentPaddingFooterReusableView":ContentPaddingFooterReusableView.self])
    
    var sortOptionsCollectionViewLayout:UICollectionViewLayout = ViewGenerator.getUICollectionViewFlowLayout(scrollDirection: .horizontal)
    lazy var sortOptionsCollectionViewDataSourceAndDelegate:BasicTextCollectionViewDataSourceAndDelegate = BasicTextCollectionViewDataSourceAndDelegate(viewModel: self.viewModel.sortOptions.map({$0.rawValue}), basicTextCellSelectedDelegate: self)
    lazy var sortOptionsCollectionView: UICollectionView = ViewGenerator.getUICollectionView(collectionViewLayout: self.sortOptionsCollectionViewLayout, registry: ["insetBasicTextCollectionViewCell":InsetBasicTextCollectionViewCell.self], delegate: self.sortOptionsCollectionViewDataSourceAndDelegate, dataSource: self.sortOptionsCollectionViewDataSourceAndDelegate, background: .clear)
    
    //MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
      setupAutoLayout()
  }
    
    //MARK: Autolayout
    func setupAutoLayout() {
        self.view.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        
        self.view.addSubview(feedsCollectionView)
        self.view.addSubview(sortOptionsCollectionView)
        self.view.addSubview(searchHoverBarView)
        
        self.feedsCollectionView.isHidden = false
        
        let spacing:CGFloat = 5.0
        
        sortOptionsCollectionView.bottomAnchor.constraint(equalTo: self.view.safeBottomAnchor).isActive=true
        sortOptionsCollectionView.heightAnchor.constraint(equalToConstant: 42.0).isActive=true
        sortOptionsCollectionView.constrainLeftAndRightTo(view: self.view)
        
        feedsCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive=true
        feedsCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive=true
        feedsCollectionViewTopAnchorWhileKeyboardIsHidden = feedsCollectionView.topAnchor.constraint(equalTo: searchHoverBarView.bottomAnchor, constant: spacing)
        feedsCollectionViewTopAnchorWhileKeyboardIsHidden?.isActive=true
        feedsCollectionViewTopAnchorWhileKeyboardIsShowing = feedsCollectionView.topAnchor.constraint(equalTo: safeTopAnchor)
        feedsCollectionView.bottomAnchor.constraint(equalTo: sortOptionsCollectionView.topAnchor).isActive=true
        
        searchHoverBarView.constrainLeftAndRightTo(view: self.view)
        searchHoverBarView.heightAnchor.constraint(equalToConstant: FilterSearchHoverBarView.height).isActive=true
        
        searchBarBottomAnchorWhileKeyboardIsHidden = searchHoverBarView.bottomAnchor.constraint(equalTo: safeTopAnchor, constant: FilterSearchHoverBarView.height)
        searchBarBottomAnchorWhileKeyboardIsHidden?.isActive=true
        
        keyboardViewModel.keyboardDismissileViewTopAnchorConstraint = keyboardViewModel.keyboardDismissileView.topAnchor.constraint(equalTo: self.view.topAnchor)
        keyboardViewModel.keyboardDismissileViewBottomAnchorConstraint = keyboardViewModel.keyboardDismissileView.bottomAnchor.constraint(equalTo: self.searchHoverBarView.topAnchor)
    }
    
    var feedsCollectionViewTopAnchorWhileKeyboardIsHidden:NSLayoutConstraint?
    var feedsCollectionViewTopAnchorWhileKeyboardIsShowing:NSLayoutConstraint?
    
    var searchBarBottomAnchorWhileKeyboardIsHidden:NSLayoutConstraint?
    var searchBarBottomAnchorWhileKeyboardIsShowing:NSLayoutConstraint?
    func willShowKeyboard(keyboardFrame:CGRect){
        searchBarBottomAnchorWhileKeyboardIsShowing?.isActive=false
        searchBarBottomAnchorWhileKeyboardIsShowing = searchHoverBarView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(keyboardFrame.height))
        searchBarBottomAnchorWhileKeyboardIsHidden?.isActive=false
        searchBarBottomAnchorWhileKeyboardIsShowing?.isActive=true
        feedsCollectionViewTopAnchorWhileKeyboardIsHidden?.isActive=false
        feedsCollectionViewTopAnchorWhileKeyboardIsShowing?.isActive=true
        searchHoverBarView.switchToKeyboardShowingMode()
    }
    func willHideKeyboard(){
        searchBarBottomAnchorWhileKeyboardIsShowing?.isActive=false
        searchBarBottomAnchorWhileKeyboardIsHidden?.isActive=true
        feedsCollectionViewTopAnchorWhileKeyboardIsShowing?.isActive=false
        feedsCollectionViewTopAnchorWhileKeyboardIsHidden?.isActive=true
        searchHoverBarView.switchToKeyboardHiddenMode()
    }
    
    //MARK: Initialization
    init(viewModel: PaginatedDiscoveryViewModelType) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        feedsCollectionViewDataSourceAndDelegate = FeedsCollectionViewDataSourceAndDelegate(feedsViewModel: self.viewModel, navigationDelegate: self)
        self.feedsCollectionViewDataSourceAndDelegate.collectionView = feedsCollectionView
        
        self.viewModel.updateFeedsCompletion = updateFeedsCompletion
        self.viewModel.updateFeeds(completion: updateFeedsCompletion)
        
        self.viewModel.getInitialLatestUpdates()

        self.keyboardViewModel.willShow = self.willShowKeyboard(keyboardFrame:)
        self.keyboardViewModel.willHide = self.willHideKeyboard
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    func updateFeedsCompletion(){
        DispatchQueue.main.async { [unowned self] in
            self.feedsCollectionViewDataSourceAndDelegate.setFeedResetCompletions()
            self.feedsCollectionViewLayout.invalidateLayout()
            self.feedsCollectionView.reloadData()
        }
    }
}

extension DiscoverViewController:BasicTextCellSelectedDelegate {
    func didSelect(text: String) {
        if let movieSortOption = MovieSortOptions(rawValue: text){
            self.viewModel.selectSort(option: movieSortOption)
            self.sortOptionsCollectionViewDataSourceAndDelegate.selectedText = text
            self.sortOptionsCollectionView.reloadData()
        }
    }
}
