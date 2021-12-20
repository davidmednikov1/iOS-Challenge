//
//  InsetBasicTextCollectionViewCell.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

class InsetBasicTextCollectionViewCell: UICollectionViewCell {
    var heightForCorners:CGFloat! {
        didSet {
            textLabel.layer.cornerRadius = (heightForCorners - InsetBasicTextCollectionViewCell.inset ) / 2.0
        }
    }
    var useGradientBackground:Bool = false
    var textIsSelected:Bool!{
        didSet{
            if textIsSelected {
                textLabel.style(AppStyleGenerator.getLabelStyle(for: .ThemedBackgroundLabel))
            }
            else {
                textLabel.style(AppStyleGenerator.getLabelStyle(for: .NewInfoTextBackgroundSubtitleLabel))
            }
        }
    }
    
    var selectedGradientBackgroundView:UIView = {
        let selectedGradientBackgroundView = UIView()
        selectedGradientBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        selectedGradientBackgroundView.backgroundColor = UIColor.clear
        selectedGradientBackgroundView.isHidden = true
        return selectedGradientBackgroundView
    }()
    
    
    let roundShadowBackgroundView:RoundShadowView = {
        let roundShadowView = RoundShadowView()
        roundShadowView.translatesAutoresizingMaskIntoConstraints = false
        
        roundShadowView.style(AppStyleGenerator.getRoundShadowViewStyle(for: .RoundShadowViewAgainstModeBackground))
        roundShadowView.backgroundColor = UIColor.clear
        
        roundShadowView.roundView.layer.cornerRadius = 11.04
        
        roundShadowView.shadowView.layer.shadowRadius = 1.0
        roundShadowView.shadowView.layer.shadowOpacity = 0.6
        return roundShadowView
    }()
    
    let textLabel:UILabel = ViewGenerator.getUILabel(appUIElement: .NewInfoTextBackgroundSubtitleLabel, size: .small, border: .rounded, align: .center)
    
    func restyle() {
        //self.style(AppStyleGenerator.getViewStyle(for: .ModeViewBackground))
        //everything else is done by didSet reload..
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    static let inset:CGFloat = 5.0
    static let textInset:CGFloat = 2.0
    
    private func setupLayout() {
        self.backgroundColor = UIColor.clear
        
        self.addSubview(textLabel)
        textLabel.constrainSidesTo(view: self, inset: InsetBasicTextCollectionViewCell.textInset)
        
        roundShadowBackgroundView.roundView.backgroundColor = AppStyleGenerator.getTheme().palette.mainColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var gradientLayer:CAGradientLayer?
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor, view:UIView, cornerRadius:CGFloat = 8.0){
        gradientLayer?.removeFromSuperlayer()
             gradientLayer = CAGradientLayer()
        guard let gradientLayer = gradientLayer else { return }
            gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.locations = [0, 1]
        gradientLayer.frame = view.bounds
        gradientLayer.cornerRadius = cornerRadius
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
