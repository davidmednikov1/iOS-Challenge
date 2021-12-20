//
//  ImageTaskDownloadDelegate.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

protocol ImageTaskDownloadedDelegate: class {
    func imageDownloaded(position: Int)
}

protocol ImageTaskDownloadedImageDelegate: class {
    func downloaded(image: UIImage, id:String?)
}
