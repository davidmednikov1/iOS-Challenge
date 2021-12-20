//
//  ImageTask.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import UIKit

class ImageTask {
    
    let position: Int
    let id:String?
    let url: URL
    let session: URLSession
    weak var delegate: ImageTaskDownloadedDelegate?
    weak var downloadedImageDelegate:ImageTaskDownloadedImageDelegate?
    
    var image: UIImage?
    
    private var task: URLSessionDownloadTask?
    private var resumeData: Data?
    
    private var isDownloading = false
    private var isFinishedDownloading = false
    
    init(position: Int, url: URL, session: URLSession, delegate: ImageTaskDownloadedDelegate?, id:String? = nil) {
        self.position = position
        self.url = url
        self.session = session
        self.delegate = delegate
        self.id = id
    }
    
    func resume() {
        if !isDownloading && !isFinishedDownloading {
            isDownloading = true
            
            if let resumeData = resumeData {
                task = session.downloadTask(withResumeData: resumeData, completionHandler: downloadTaskCompletionHandler)
            } else {
                task = session.downloadTask(with: url, completionHandler: downloadTaskCompletionHandler)
            }
            
            task?.resume()
        }
    }
    
    func pause() {
        if isDownloading && !isFinishedDownloading {
            task?.cancel(byProducingResumeData: { (data) in
                self.resumeData = data
            })
            
            self.isDownloading = false
        }
    }
    
    private func downloadTaskCompletionHandler(url: URL?, response: URLResponse?, error: Error?) {
        if let error = error {
            print("Error downloading: ", error)
            isDownloading = false
            isFinishedDownloading = false
            resumeData = nil
            //self.resume() //uncomment to keep retrying
            
            return
        }
        
        guard let url = url else { return }
        guard let data = FileManager.default.contents(atPath: url.path) else { return }
        guard let image = UIImage(data: data) else { return }
        
        DispatchQueue.main.async {
            self.image = image
            self.delegate?.imageDownloaded(position: self.position) //for use by DataSourceAndDelegate
            self.downloadedImageDelegate?.downloaded(image: image, id: self.id) //for use by CELLS -- //id is optional -- only needed if a position has multiple images and I need to identify them individually (e.g. FeedType5/6 cells)
        }
        
        self.isFinishedDownloading = true
    }
}
