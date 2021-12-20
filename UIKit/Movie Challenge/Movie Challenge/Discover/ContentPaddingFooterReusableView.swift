//
//  ContentPaddingFooterReusableView.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

class ContentPaddingFooterReusableView: UICollectionReusableView {
       
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpAutoLayout()
    }
    
    func restyle() {
        self.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
    }
    
    func setUpAutoLayout() {
        self.style(AppStyleGenerator.getViewStyle(for: .NewContentBackground))
    }
    
    var didLayoutSubviews:Bool = false
    override func layoutSubviews() {
        super.layoutSubviews()
        if !didLayoutSubviews {
            //frame based layouts
            didLayoutSubviews = true
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("no xib for LibrarySeriesDetailHeaderCollectionReusableView")
    }
}
