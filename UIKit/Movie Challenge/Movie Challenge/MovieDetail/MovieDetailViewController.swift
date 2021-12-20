//
//  MovieDetailViewController.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import Foundation
import UIKit

//MARK: NavigatorDelegate Extension
extension MovieDetailViewController: NavigatorDelegate{
    func navigate(to viewController: UIViewController, replace: Bool) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pop() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: PopUpPresenterDelegate -- used to show larger thumbnail popup
extension MovieDetailViewController: PopUpPresenterDelegate {
    func presentPopUp(viewController: UIViewController) {
        self.addChild(viewController)
        viewController.view.frame = self.view.frame
        self.view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}

class MovieDetailViewController: UIViewController {
    //MARK: Properties
    var viewModel:MovieDetailViewModelType
    
    //MARK: Initialization
    init(viewModel:MovieDetailViewModelType){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        if let thumbnailURL = viewModel.thumbnail {
            print("thumbnail being used to set image - \(thumbnailURL)")
            if let url = URL(string: thumbnailURL){
                downloadImage(from: url)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Views
    let topSafeAreaBackgroundView:UIView = ViewGenerator.getUIView(appUIElement: .ModeViewBackground /*.ThemedViewBackground*/)
    
    lazy var seriesDetailHeaderView:SeriesDetailHeaderView = { [unowned self] in
        let seriesDetailHeaderView:SeriesDetailHeaderView = SeriesDetailHeaderView(viewModel: self.viewModel, popUpPresenterDelegate: self, navigationDelegate: self)
        seriesDetailHeaderView.translatesAutoresizingMaskIntoConstraints = false
        return seriesDetailHeaderView
    }()
    
    lazy var seriesDetailInfoTabView:SeriesDetailInfoTabView = SeriesDetailInfoTabView(viewModel: self.viewModel, popUpPresenterDelegate: self, navigationDelegate: self)
    
    let infoBackgroundView:UIView = ViewGenerator.getUIView(appUIElement: .NewContentBackground, border: .normal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAutoLayout()
    }
    
    func setupAutoLayout(){
        self.view.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        
        self.view.addSubview(topSafeAreaBackgroundView)
        topSafeAreaBackgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive=true
        topSafeAreaBackgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive=true
        topSafeAreaBackgroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive=true
        topSafeAreaBackgroundView.bottomAnchor.constraint(equalTo: self.view.safeTopAnchor).isActive=true
        
        
        self.view.addSubview(seriesDetailHeaderView)
        seriesDetailHeaderView.constrainLeftAndRightTo(view: self.view)
        seriesDetailHeaderView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive=true
        seriesDetailHeaderView.heightAnchor.constraint(equalToConstant: SeriesDetailHeaderView.totalHeight()).isActive=true
        print("SeriesDetailHeaderView.totalHeight() - \(SeriesDetailHeaderView.totalHeight())")
        
        self.view.addSubview(infoBackgroundView)
        infoBackgroundView.constrainLeftAndRightTo(view: self.view)
        infoBackgroundView.topAnchor.constraint(equalTo: seriesDetailHeaderView.bottomAnchor).isActive=true
        infoBackgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive=true
        let ssv = ViewGenerator.getMutatableScrollableStackView(startingViews:[(seriesDetailInfoTabView,SeriesDetailInfoTabView.totalHeight(descriptionExpanded: true, hasSeriesEntity: false))], superview:self.infoBackgroundView)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print("Download Finished")
            DispatchQueue.main.async() { [weak self] in
                guard let self = self else { return }
                self.viewModel.thumbnailImage = UIImage(data: data)
                
                self.seriesDetailHeaderView.viewModel = self.viewModel
                self.seriesDetailHeaderView.removeLoadingSpinnerForDownloadedImage()
            }
        }
    }
}
