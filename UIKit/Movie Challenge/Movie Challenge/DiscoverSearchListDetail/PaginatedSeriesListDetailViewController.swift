//
//  PaginatedSeriesListDetailViewController.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

//MARK: NavigatorDelegate Extension
extension PaginatedSeriesListDetailViewController: NavigatorDelegate {
    func navigate(to viewController: UIViewController, replace: Bool = false) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
}

class PaginatedSeriesListDetailViewController: UIViewController {
    
    func addFeedDetailNavigationBar(){
           self.navigationItem.setHidesBackButton(true, animated: true);
           if let navigationController = self.navigationController, let movieNavigationController = navigationController as? MovieNavigationController {
               let feedType5DetailNavigationBarView = FeedType5DetailNavigationBarView(title: self.detailTitle, navigationController: self.navigationController)
               feedType5DetailNavigationBarView.translatesAutoresizingMaskIntoConstraints = false
               movieNavigationController.setCustomBarView(feedType5DetailNavigationBarView)
           }
    }
    
    //MARK: View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAutoLayout()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if paginatedSeriesCollectionView.frame != .zero {
            paginatedSeriesCollectionViewDelegate.updateCellFont()
        }
        fetchMoreToFillContentIfNecessary()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: Properties
    var viewModel:FeedViewModelType!
    var detailTitle:String
    
    //MARK: Views
    var paginatedSeriesCollectionViewDelegate:PaginatedSeriesCollectionViewDelegate!
    var paginatedSeriesCollectionViewLayout:UICollectionViewFlowLayout = ViewGenerator.getUICollectionViewFlowLayout(scrollDirection: .vertical)
    lazy var paginatedSeriesCollectionView:UICollectionView = ViewGenerator.getUICollectionView(appUIElement:.NewContentBackground, collectionViewLayout: self.paginatedSeriesCollectionViewLayout, registry: ["seriesSearchResultTextUnderCollectionViewCell":SeriesSearchResultTextUnderCollectionViewCell.self], delegate: self.paginatedSeriesCollectionViewDelegate, dataSource: self.paginatedSeriesCollectionViewDelegate)
    
    lazy var feedType5DetailNavigationBarView:FeedType5DetailNavigationBarView = {
        let feedType5DetailNavigationBarView = FeedType5DetailNavigationBarView(title: self.detailTitle, navigationController: self.navigationController)
        feedType5DetailNavigationBarView.translatesAutoresizingMaskIntoConstraints = false
        return feedType5DetailNavigationBarView
    }()
    
    //MARK: Initialization
    init(viewModel:FeedViewModelType?, title:String) {
        self.viewModel = viewModel
        self.detailTitle = title
        
        super.init(nibName: nil, bundle: nil)
        
        paginatedSeriesCollectionViewDelegate = PaginatedSeriesCollectionViewDelegate(feedViewModel: self.viewModel, navigationDelegate: self)
        paginatedSeriesCollectionViewDelegate.collectionView = self.paginatedSeriesCollectionView //collectionView needed for image refresh on finish downloading
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Storyboard not supported")
    }
    
    //MARK: AutoLayout
    func setupAutoLayout() {
        self.view.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        self.view.addSubview(feedType5DetailNavigationBarView)
        self.view.addSubview(paginatedSeriesCollectionView)
        
        let spacing:CGFloat = 0.0
        
        feedType5DetailNavigationBarView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        feedType5DetailNavigationBarView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        feedType5DetailNavigationBarView.topAnchor.constraint(equalTo: safeTopAnchor).isActive=true
        feedType5DetailNavigationBarView.heightAnchor.constraint(equalToConstant: 44.0).isActive=true
        
        paginatedSeriesCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive=true
        paginatedSeriesCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive=true
        paginatedSeriesCollectionView.topAnchor.constraint(equalTo: feedType5DetailNavigationBarView.bottomAnchor, constant: spacing).isActive=true
        
        paginatedSeriesCollectionView.bottomAnchor.constraint(equalTo: self.view.safeBottomAnchor).isActive=true
    }
    
    
    func fetchMoreToFillContentIfNecessary(){
        //this logic does not get called when resizing the grid, so need to make sure it does then as well, but it seems to work
        //only potential problem is what if there are just no results in your search, so getting more won't help..
        let paginatedSeriesCollectionViewHeight = paginatedSeriesCollectionView.frame.height
        let contentSizeHeight = paginatedSeriesCollectionView.contentSize.height
        let offset:CGFloat = 0.0 //allSeriesCollectionView.contentOffset.y
        
        let notEnoughContentToScroll = offset + contentSizeHeight < paginatedSeriesCollectionViewHeight
        
        if notEnoughContentToScroll /*&& self.viewModel.latestUpdatesHasNextPage && self.onTab*/{
            self.viewModel.getMoreResults(completion: { [weak self] in
                self?.paginatedSeriesCollectionViewDelegate.updateJSONSeries()
                self?.paginatedSeriesCollectionView.reloadData()
                self?.fetchMoreToFillContentIfNecessary()
            })
        }
    }
}
