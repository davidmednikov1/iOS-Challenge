//
//  BasicTextCollectionViewDataSourceAndDelegate.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

protocol BasicTextCellSelectedDelegate: AnyObject {
    func didSelect(text: String)
}
class BasicTextCollectionViewDataSourceAndDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    
    weak var basicTextCellSelectedDelegate:BasicTextCellSelectedDelegate?
    
    var viewModel:[String] = [String]()
    var selectedText:String?
    
    init(viewModel: [String], basicTextCellSelectedDelegate:BasicTextCellSelectedDelegate? = nil){
        self.viewModel = viewModel
        self.basicTextCellSelectedDelegate = basicTextCellSelectedDelegate
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "insetBasicTextCollectionViewCell", for: indexPath) as! InsetBasicTextCollectionViewCell
        
        cell.textLabel.text = viewModel[indexPath.row]
        if viewModel[indexPath.row] == selectedText {
            cell.textIsSelected = true
        }
        else {
            cell.textIsSelected = false
        }
        
        cell.heightForCorners = collectionView.frame.height
        return cell
    }
    
    let horizontalSpacing:CGFloat = 10.0
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemSize = viewModel[indexPath.row].size(withAttributes: [
            NSAttributedString.Key.font : UIFont(name: ViewGenerator.regularFont, size: 20.0) as Any
        ])
        
        let extraWidth:CGFloat = 40.0
        
        return CGSize(width: itemSize.width + extraWidth, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("do nothing in BasicTextCollectionViewDataSourceAndDelegate didSelect for now")
        self.basicTextCellSelectedDelegate?.didSelect(text: self.viewModel[indexPath.row])
        
    }
}
