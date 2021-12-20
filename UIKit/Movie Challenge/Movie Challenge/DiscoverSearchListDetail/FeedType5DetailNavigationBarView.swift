//
//  FeedType5DetailNavigationBarView.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

class FeedType5DetailNavigationBarView: UIView {

    lazy var titleLabel: MarqueeLabel = {
        let marquee = MarqueeLabel(frame: .zero, rate: 30, fadeLength: 10.0) //rate is pixels per second to scroll
        marquee.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        marquee.textAlignment = .center
        marquee.translatesAutoresizingMaskIntoConstraints = false
        
        marquee.style(AppStyleGenerator.getLabelStyle(for: .ClearBackgroundLabelAgainstModeColor))
        return marquee
    }()
    
    let backLabel:UIImageView = {
        let backImageView = ViewGenerator.getUIImageView(appUIElement: .ClearBackgroundImageViewThemedAgainstModeColor, image: UIImage(named: AssetConstants.BACK_NAVIGATION_BUTTON_OUTLINE)?.withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFill)
        backImageView.isUserInteractionEnabled = true
        backImageView.layer.masksToBounds = true
        return backImageView
    }()
    
    weak var navigationController:UINavigationController?
    
    init(title:String, navigationController:UINavigationController?){
        super.init(frame: .zero)
        titleLabel.text = title
        self.navigationController = navigationController
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAutoLayout(){
        let buttonSize:CGFloat = 44.0
        self.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        self.addSubview(backLabel)
        self.addSubview(titleLabel)
        
        let inset:CGFloat = 5.0
        backLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: inset).isActive=true
        backLabel.heightAnchor.constraint(equalToConstant: buttonSize).isActive=true
        backLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive=true
        backLabel.widthAnchor.constraint(equalToConstant: buttonSize).isActive=true
        backLabel.layer.cornerRadius = buttonSize / 2.0 //this is only to hide the white of the background from the corners, but still show it inside the < symbol
        
        let spacing:CGFloat = 10.0
        titleLabel.leftAnchor.constraint(equalTo: backLabel.rightAnchor, constant: spacing).isActive=true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -(spacing+buttonSize+inset)).isActive=true

        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive=true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        
        backLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(popNavigation)))
    }
    
    @objc func popNavigation(_ tapGesture:UITapGestureRecognizer){
        self.navigationController?.popViewController(animated: true)
        
    }
}
