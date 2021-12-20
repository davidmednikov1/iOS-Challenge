//
//  SeriesSearchResultTextUnderCollectionViewCell.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

extension SeriesSearchResultTextUnderCollectionViewCell: ImageTaskDownloadedImageDelegate {
    func downloaded(image: UIImage, id:String?) {
        thumbnailImage.backgroundColor = UIColor.random(close:AppStyleGenerator.getTheme().palette.mainColor, by: 0.20)
        thumbnailImage.contentMode = .scaleAspectFill
        
        UIView.transition(with: self.thumbnailImage,
        duration: 0.75,
        options: .transitionCrossDissolve,
        animations: { self.thumbnailImage.image = image },
        completion: nil)
    }
}
class SeriesSearchResultTextUnderCollectionViewCell: UICollectionViewCell {
    var seriesViewModel:MovieModel!{
        didSet{
            var title = seriesViewModel.title
            title = "\(title)\n"
            seriesNameLabel.text = title
            selectedOverlayView.isHidden = true
            
            if let rating = seriesViewModel.rating {
                sourceNameLabel.isHidden = false
                sourceNameLabelBackgroundGradientView.isHidden = false
                sourceNameLabel.text = "\(rating)"
            }
            else {
                sourceNameLabel.isHidden = true
                sourceNameLabelBackgroundGradientView.isHidden = true
                sourceNameLabel.text = ""
            }
        }
    }
    
    func updateImageContentMode(size:CGSize) {
        let imageRatio = size.width / size.height
        if imageRatio < 0.6 || imageRatio > 0.8 {
            thumbnailImage.contentMode = .scaleAspectFill
            thumbnailImage.layer.masksToBounds = true;
        }
        else {
            thumbnailImage.contentMode = .scaleAspectFit
        }
    }
    
    var selectedOverlayView:UIView = ViewGenerator.getUIView(appUIElement: .ThemedViewBackground, border: .rounded, isOpaque: true, alpha: 0.5)
    
    var gradientView: GradientView = {
        let topColor:CGColor = UIColor.black.withAlphaComponent(0.01).cgColor
        let bottomColor:CGColor = UIColor.black.withAlphaComponent(0.45).cgColor
        let gradientView:GradientView = GradientView(gradientColors:[topColor,bottomColor], gradientDirection: .TopToBottom)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        gradientView.layer.cornerRadius = GridCellSizeCalculator.thumbnailCornerRadius
        gradientView.layer.masksToBounds = true //corners won't should up rounded without this
        return gradientView
    }()
    
    var seriesNameLabel: VerticalAlignLabel = {
        let seriesNameLabel = VerticalAlignLabel()
        seriesNameLabel.style(AppStyleGenerator.getLabelStyle(for: .NewContentBackgroundLabel))
        seriesNameLabel.numberOfLines = 2
        seriesNameLabel.font = UIFont(name: ViewGenerator.regularFont, size: 20)
        seriesNameLabel.adjustsFontSizeToFitWidth = false
        seriesNameLabel.minimumScaleFactor = 0.9
        seriesNameLabel.textAlignment = .left
        seriesNameLabel.lineBreakMode = .byClipping //don't show ... ellipses
        
        seriesNameLabel.verticalAlignment = .top
        seriesNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return seriesNameLabel
    }()
    
    var sourceNameLabelBackgroundGradientView:GradientView = {
        let continueToBackgroundGradientView = GradientView(gradientColors: [AppStyleGenerator.getTheme().palette.mainColor.cgColor,AppStyleGenerator.getTheme().palette.lightMainColor.cgColor], gradientDirection: .LeftToRight)
        continueToBackgroundGradientView.translatesAutoresizingMaskIntoConstraints = false
        continueToBackgroundGradientView.layer.cornerRadius = updateLabelSize / 2.0
        continueToBackgroundGradientView.layer.masksToBounds = true
        return continueToBackgroundGradientView
    }()
    
    lazy var sourceNameLabel:UILabel = {
        let sourceNameLabel = ViewGenerator.getUILabel(appUIElement: .ClearBackgroundTextVisibleAgainstThemedLabel, size: .medium, border: .normal, align: .center, touchable: true, appFont: .regular)
        //this makes the text centers veritcally in the label's frame
        sourceNameLabel.baselineAdjustment = .alignCenters
        sourceNameLabel.lineBreakMode = .byClipping
        return sourceNameLabel
    }()

    lazy var thumbnailImage:UIImageView = { [unowned self] in
        let albumImage = UIImageView()
        
        albumImage.contentMode = .scaleAspectFill
        albumImage.layer.masksToBounds = true;
        
        albumImage.translatesAutoresizingMaskIntoConstraints = false
        
        albumImage.backgroundColor = UIColor.random(close:AppStyleGenerator.getTheme().palette.mainColor, by: 0.20)
        albumImage.layer.cornerRadius = GridCellSizeCalculator.thumbnailCornerRadius
        albumImage.layer.masksToBounds = true //corners won't should up rounded without this
        return albumImage
        }()
    
    func restyle(){
        self.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        self.selectedOverlayView.style(AppStyleGenerator.getViewStyle(for: .ThemedViewBackground))
        seriesNameLabel.style(AppStyleGenerator.getLabelStyle(for: .NewContentBackgroundLabel))
        sourceNameLabelBackgroundGradientView.gradientColors = [AppStyleGenerator.getTheme().palette.mainColor.cgColor,AppStyleGenerator.getTheme().palette.lightMainColor.cgColor]
        sourceNameLabelBackgroundGradientView.layer.borderWidth = 2.0
        sourceNameLabelBackgroundGradientView.layer.borderColor = AppStyleGenerator.getMode().contentBackgroundColor.cgColor
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private static let updateLabelSize:CGFloat = 23.0
    public static let updateLabelPartOutsideImage:CGFloat = 7.0
    
    public static let itemSpacing:CGFloat = 5.0 //space between image and title
    public static let bottomSpacing:CGFloat = 10.0
    public static let totalHeightForTitleTextWithSpacing:CGFloat = SeriesSearchResultTextUnderCollectionViewCell.itemSpacing + SeriesSearchResultTextUnderCollectionViewCell.bottomSpacing + SeriesSearchResultTextUnderCollectionViewCell.heightForTitleText
    public static let heightForTitleText:CGFloat = 30.0
    public static let totalSpacingHeightForTitleText:CGFloat = SeriesSearchResultTextUnderCollectionViewCell.itemSpacing + SeriesSearchResultTextUnderCollectionViewCell.bottomSpacing
    
    private func setupLayout() {
        self.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
        
        self.addSubview(thumbnailImage)
        self.addSubview(seriesNameLabel)
        self.addSubview(sourceNameLabelBackgroundGradientView)
        self.addSubview(sourceNameLabel)
        self.addSubview(selectedOverlayView)
        
        let inset:CGFloat = 5.0
        
        let labelInset:CGFloat = 10.0
        let spacing:CGFloat = 10.0
        NSLayoutConstraint.activate([
            thumbnailImage.leftAnchor.constraint(equalTo: leftAnchor),
            thumbnailImage.rightAnchor.constraint(equalTo: rightAnchor),
            thumbnailImage.topAnchor.constraint(equalTo: topAnchor),
            thumbnailImage.bottomAnchor.constraint(equalTo: seriesNameLabel.topAnchor, constant: -SeriesSearchResultTextUnderCollectionViewCell.itemSpacing),
            
            seriesNameLabel.leftAnchor.constraint(equalTo: thumbnailImage.leftAnchor, constant: labelInset),
            seriesNameLabel.rightAnchor.constraint(equalTo: thumbnailImage.rightAnchor, constant: -labelInset),
            seriesNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SeriesSearchResultTextUnderCollectionViewCell.bottomSpacing), //could actual use the height
            
            selectedOverlayView.leftAnchor.constraint(equalTo: thumbnailImage.leftAnchor),
            selectedOverlayView.rightAnchor.constraint(equalTo: thumbnailImage.rightAnchor),
            selectedOverlayView.topAnchor.constraint(equalTo: thumbnailImage.topAnchor),
            selectedOverlayView.bottomAnchor.constraint(equalTo: thumbnailImage.bottomAnchor),
            
            sourceNameLabelBackgroundGradientView.rightAnchor.constraint(equalTo: thumbnailImage.rightAnchor, constant: -3.0),
            sourceNameLabelBackgroundGradientView.topAnchor.constraint(equalTo: thumbnailImage.topAnchor, constant: 3.0),
            sourceNameLabelBackgroundGradientView.heightAnchor.constraint(equalToConstant: SeriesSearchResultTextUnderCollectionViewCell.updateLabelSize),
            sourceNameLabelBackgroundGradientView.widthAnchor.constraint(equalTo: thumbnailImage.widthAnchor, multiplier: 0.5),
            
            sourceNameLabel.centerXAnchor.constraint(equalTo: sourceNameLabelBackgroundGradientView.centerXAnchor),
            sourceNameLabel.topAnchor.constraint(equalTo: sourceNameLabelBackgroundGradientView.topAnchor, constant: 3),
            sourceNameLabel.bottomAnchor.constraint(equalTo: sourceNameLabelBackgroundGradientView.bottomAnchor, constant: -3),
            sourceNameLabel.widthAnchor.constraint(equalTo: sourceNameLabelBackgroundGradientView.widthAnchor, constant: -12)
            
        ])
        

    }
    
    let visibleFrameBorder:UIView = {
        let visibleFrameBorder = UIView()
        visibleFrameBorder.translatesAutoresizingMaskIntoConstraints = false
        visibleFrameBorder.backgroundColor = UIColor.clear
        visibleFrameBorder.layer.borderColor = UIColor.red.cgColor
        visibleFrameBorder.layer.borderWidth = 1.0
        
        return visibleFrameBorder
    }()
}

