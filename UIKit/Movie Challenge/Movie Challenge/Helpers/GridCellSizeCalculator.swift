//
//  GridCellSizeCalculator.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

class GridCellSizeCalculator {
    static let thumbnailCornerRadius:CGFloat = 5.0 //cornerRadius for thumbnails
    
    static let widthForRatio:CGFloat = 402.0
    static let heightForRatio:CGFloat = 558.0
    static let widthToHeightRatio:CGFloat = widthForRatio / heightForRatio //to specify a widthAnchor
    
    static let heightToWidthRatio:CGFloat = heightForRatio / widthForRatio // to specify a heightAnchor
    
    static let spacing:CGFloat = 10.0 //left space will be 10, right space will be 10, middle space will be 10 between columns, so
    
    //extraSpaceForUpdateLabel passed like so, so that on VerticalCollectionViews e.g. PaginatedLatestUpdatesCollectionViewDelegate we don't use spacing AND spacing for updateLabel to make there be too much spacing
    static func getSizeForGridCell(numberOfColumns: CGFloat, collectionViewFrame: CGRect, withUpdateAlert: Bool = false, cellTitleFont:CGFloat = 10.0, showTitlesInsideThumbnails:Bool = true) -> CGSize {
        if withUpdateAlert { //the corner # updates bubble
            let width:CGFloat = floor((collectionViewFrame.width - (spacing * (numberOfColumns + 1.0))) / numberOfColumns) //this is with spacing on both sides
            let height:CGFloat = (width * heightForRatio) / widthForRatio
            return CGSize(width: floor(width), height: floor(height + spacing)) //the +spacing for the height, is so that the cell will be able to constrict the image up by spacing so there is space between the rows, so the actual height of the image will still be "height" ***
        }
        else {
            if showTitlesInsideThumbnails {
                let width:CGFloat = floor((collectionViewFrame.width - (spacing * (numberOfColumns + 1.0))) / numberOfColumns) //this is with spacing on both sides
                let height:CGFloat = (width * heightForRatio) / widthForRatio
                
                
                return CGSize(width: floor(width), height: floor(height + spacing)) //the +spacing for the height, is so that the cell will be able to constrict the image up by spacing so there is space between the rows, so the actual height of the image will still be "height" ***
            }
            else {
                //cellTitleFont * 2.0 because there are always going to be 2 lines, if you make it one line, then change to 1.0
                let heightForTitle:CGFloat = cellTitleFont * 2.0 + SeriesSearchResultTextUnderCollectionViewCell.totalSpacingHeightForTitleText
                let width:CGFloat = floor((collectionViewFrame.width - (spacing * (numberOfColumns + 1.0))) / numberOfColumns) //this is with spacing on both sides
                let height:CGFloat = (width * heightForRatio) / widthForRatio
                
                return CGSize(width: floor(width), height: floor(height + heightForTitle)) //the +heightForTitle for the height, is so that the cell will be able to constrict the image up by spacing so there is space between the rows, so the actual height of the image will still be "height" ***
            }
        }
    }
    
    static func getSizeForLandscapeGridCell(numberOfRows: CGFloat, collectionViewFrame: CGRect, withUpdateAlert: Bool = false) -> CGSize {
        //landscape, should use heights to layout cells and numberOfColumns will really be number of ROWS
        if withUpdateAlert { //the corner # updates bubble
            let height:CGFloat = floor((collectionViewFrame.height - (spacing * (numberOfRows + 1.0))) / numberOfRows) //this is with spacing on both sides
            let width:CGFloat = (height * widthForRatio) / heightForRatio
            return CGSize(width: width + spacing, height: height) //the +spacing for the height, is so that the cell will be able to constrict the image up by spacing so there is space between the rows, so the actual height of the image will still be "height" ***
        }
        else {
            let height:CGFloat = ((collectionViewFrame.height - (spacing * (numberOfRows + 1.0))) / numberOfRows) //this is with spacing on both sides
            let width:CGFloat = (height * widthForRatio) / heightForRatio
            
            return CGSize(width: width + spacing, height: height) //the +spacing for the height, is so that the cell will be able to constrict the image up by spacing so there is space between the rows, so the actual height of the image will still be "height" ***
        }
    }
    
    static func getThumbnailHeight(width:CGFloat) -> CGSize {
        let height:CGFloat = (width * heightForRatio) / widthForRatio
        return CGSize(width: width, height: height)
    }
    
    struct FeedType4 {
        static let widthForRatio:CGFloat = 1366.0
        static let heightForRatio:CGFloat = 683.0
        static let widthToHeightRatio:CGFloat = widthForRatio / heightForRatio //to specify a widthAnchor
        
        static let heightToWidthRatio:CGFloat = heightForRatio / widthForRatio // to specify a heightAnchor
        
        static func getSizeForGridCell(numberOfColumns: CGFloat, collectionViewFrame: CGRect) -> CGSize {
            let width:CGFloat = floor((collectionViewFrame.width - (spacing * (numberOfColumns + 1.0))) / numberOfColumns) //this is with spacing on both sides
            let height:CGFloat = (width * FeedType4.heightForRatio) / FeedType4.widthForRatio
            
            return CGSize(width: width, height: height + spacing) //the +spacing for the height, is so that the cell will be able to constrict the image up by spacing so there is space between the rows, so the actual height of the image will still be "height" ***
        }
    }
    
    //for font in cells that have a landscape counterpart
    static func getRotatableSeriesLabelFont(numberOfColumns: CGFloat, collectionViewFrame: CGRect, withUpdateAlert: Bool = false) -> UIFont? {
        
        var isLandscape:Bool = false
        if collectionViewFrame.width > collectionViewFrame.height {
            isLandscape = true
        }
        //when in landscape numberOfColumns is really number of rows
        let sizeForGridCell:CGSize = isLandscape ? GridCellSizeCalculator.getSizeForLandscapeGridCell(numberOfRows: numberOfColumns, collectionViewFrame: collectionViewFrame, withUpdateAlert: withUpdateAlert) : GridCellSizeCalculator.getSizeForGridCell(numberOfColumns: numberOfColumns, collectionViewFrame: collectionViewFrame, withUpdateAlert: withUpdateAlert)
        
        let testText:String = "MMMMMMMMMMM"
        var size:CGFloat = 8.0
        var itemSize = testText.size(withAttributes: [
            NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: size)
        ])
        
        let maxWidth:CGFloat = sizeForGridCell.width
        
        if maxWidth <= 0 {
            return UIFont(name: "HelveticaNeue-Bold", size: size)
        }
        
        while itemSize.width.isLess(than: maxWidth) {
            size += 1
            itemSize = testText.size(withAttributes: [
                NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: size)
            ])
        }
        
        size -= 1
        
        return UIFont(name: "HelveticaNeue-Bold", size: size)
    }
    
    static func getSeriesLabelFont(numberOfColumns: CGFloat, collectionViewFrame: CGRect, withUpdateAlert: Bool = false) -> UIFont? {
        
        let sizeForGridCell:CGSize = GridCellSizeCalculator.getSizeForGridCell(numberOfColumns: numberOfColumns, collectionViewFrame: collectionViewFrame, withUpdateAlert: withUpdateAlert)
        
        let testText:String = "MMMMMMMMMMM"
        var size:CGFloat = 8.0
        var itemSize = testText.size(withAttributes: [
            NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: size)
        ])
        
        let maxWidth:CGFloat = sizeForGridCell.width
        
        if maxWidth <= 0 {
            return UIFont(name: "HelveticaNeue-Bold", size: size)
        }
        
        while itemSize.width.isLess(than: maxWidth) {
            size += 1
            itemSize = testText.size(withAttributes: [
                NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Bold", size: size)
            ])
        }
        
        size -= 1
        
        return UIFont(name: "HelveticaNeue-Bold", size: size)
    }
    
    static func getSeriesLabelFont(numberOfColumns: CGFloat) -> UIFont? {
           switch numberOfColumns {
           case 1:
               return UIFont(name: "HelveticaNeue-Bold", size: 25)
           case 2:
               return UIFont(name: "HelveticaNeue-Bold", size: 20)
           case 3:
               return UIFont(name: "HelveticaNeue-Bold", size: 13)
           case 4:
               return UIFont(name: "HelveticaNeue-Bold", size: 10)
           case 5:
               return UIFont(name: "HelveticaNeue-Bold", size: 8)
           default:
               return UIFont(name: "HelveticaNeue-Bold", size: 13)
           }
       }
    
    
}
