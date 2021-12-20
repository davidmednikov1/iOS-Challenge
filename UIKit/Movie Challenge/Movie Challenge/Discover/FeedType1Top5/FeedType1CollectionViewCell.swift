//
//  FeedType1CollectionViewCell.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

protocol FeedType1ViewModelType:class {
    var title: String { get }
    var element: MovieModel { get set }
}

class FeedType1ViewModel: FeedType1ViewModelType {
    var element: MovieModel
    var title: String
    
    init(feedType1: MovieModel){
        self.element = feedType1
        self.title = feedType1.title
    }
}

class FeedType1CollectionViewCell: UICollectionViewCell {
    var feedType1ViewModel:FeedType1ViewModelType!{
        didSet{
            //Image set by delegate
            titleLabel.text = feedType1ViewModel.title
        }
    }
        
    lazy var thumbnailImage:UIImageView = { [unowned self] in
        let thumbnailImage = UIImageView()
        thumbnailImage.contentMode = .scaleAspectFit
        thumbnailImage.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImage.backgroundColor = UIColor.white
        
        thumbnailImage.layer.borderWidth = 1.0
        thumbnailImage.layer.borderColor = UIColor.black.cgColor
        
        thumbnailImage.layer.cornerRadius = GridCellSizeCalculator.thumbnailCornerRadius
        thumbnailImage.layer.masksToBounds = true //corners won't should up rounded without this
        return thumbnailImage
        }()
    
    var titleLabel: UILabel = ViewGenerator.getUILabel(text: "", size: .medium, border: .normal, background: .light, theme: .light, align: .left)
    
    let roundShadowView:RoundShadowView = {
        let roundShadowView = RoundShadowView()
        roundShadowView.translatesAutoresizingMaskIntoConstraints = false
        
        roundShadowView.viewBackgroundColor = UIColor.white
        
        roundShadowView.roundView.layer.cornerRadius =  GridCellSizeCalculator.thumbnailCornerRadius
        roundShadowView.roundView.layer.masksToBounds = true //corners won't should up rounded without this
        return roundShadowView
    }()
    
    lazy var mainView:UIStackView = {
        let mainView:UIStackView = UIStackView(arrangedSubviews: [thumbnailImage,titleLabel])
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.backgroundColor = UIColor.clear
        mainView.axis = .vertical
        mainView.distribution = .fill
        mainView.alignment = .fill
        mainView.spacing = 0
        
        return mainView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    func setupLayout() {
        self.backgroundColor = UIColor.white
        
        self.contentView.addSubview(roundShadowView)
        let inset:CGFloat = 5.0
        roundShadowView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: inset).isActive=true
        roundShadowView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -inset).isActive=true
        roundShadowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset).isActive=true
        roundShadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset).isActive=true
        
        roundShadowView.addSubview(mainView)
        
        
        mainView.leftAnchor.constraint(equalTo: roundShadowView.leftAnchor, constant: inset).isActive=true
        mainView.rightAnchor.constraint(equalTo: roundShadowView.rightAnchor, constant: -inset).isActive=true
        mainView.topAnchor.constraint(equalTo: roundShadowView.topAnchor, constant: inset).isActive=true
        mainView.bottomAnchor.constraint(equalTo: roundShadowView.bottomAnchor, constant: -inset).isActive=true
        
        titleLabel.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.15).isActive=true
        thumbnailImage.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.75).isActive=true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
