//
//  JSONFeedRename.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import Foundation
import UIKit

protocol MovieDetailViewModelType:AnyObject {
    var title:String { get }
    var thumbnail:String? { get }
    var rating:Double? { get }
    var description:String { get }
    var descriptionExpanded:Bool { get set }
    var thumbnailImage:UIImage? { get set }
    var genres:[String] { get set }
    var director:String? { get set }
    var cast:[String] { get set }
    
}

class MovieDetailViewModel:MovieDetailViewModelType {
    let id:Int
    let title:String
    let thumbnail:String?
    let rating:Double?
    let description:String
    var descriptionExpanded: Bool = false
    var thumbnailImage: UIImage? = nil
    var genres:[String] = [String]()
    var director: String?
    var cast: [String] = [String]()
    
    init(id:Int, title:String, thumbnail:String?, rating:Double, description:String, genres:[String]?, director: String?, cast: [String]?){
        self.id = id
        self.title = title
        self.thumbnail = thumbnail
        self.rating = rating
        self.description = description
        self.genres = genres ?? [String]()
        self.director = director
        self.cast = cast ?? [String]()
    }
}

struct MovieModel:Codable {
    let id:Int
    let title:String
    let thumbnail:String?
    let rating:Double?
}

struct JSONFeed : Codable {
    enum JSONFeedElementTypes { case one([MovieModel]), two([String]), seven([MovieModel]) }
    
    let type: String
    let title: String
    let subtitle: String?
    var elements: JSONFeedElementTypes?
    
    enum CodingKeys : CodingKey {
        case type, title, subtitle, elements
    }
    
    //Decodable
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        subtitle = try? values.decode(String.self, forKey: .subtitle) //without ? if decoding fails, init with throw (and fail), even though subtitle is optional
        type = try values.decode(String.self, forKey: .type)
        
        switch type {
        case "1":
            elements = try .one(values.decode([MovieModel].self, forKey: .elements))
        case "2":
            elements = try .two(values.decode([String].self, forKey: .elements))
        case "7":
            elements = try .seven(values.decode([MovieModel].self, forKey: .elements))
        default:
            elements = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        
        try values.encode(title, forKey: .title)
        try values.encode(subtitle, forKey: .subtitle)
        try values.encode(type, forKey: .type)
        
        switch type {
        case "1":
            guard case let .one(feedType1Elements) = elements else { return }
            try values.encode(feedType1Elements, forKey: .elements)
        case "2":
            guard case let .two(feedType2Elements) = elements else { return }
            try values.encode(feedType2Elements, forKey: .elements)
        case "7":
            guard case let .seven(feedType7Elements) = elements else { return }
            try values.encode(feedType7Elements, forKey: .elements)
        default:
            break
        }
    }
    
    init(title: String, elements: JSONFeedElementTypes){
        self.title = title
        self.subtitle = nil
        switch elements {
        case .one(let movies):
            self.type = "1"
            self.elements = .one(movies)
        case .two(let genres):
            self.type = "2"
            self.elements = .two(genres)
        case .seven(let movies):
            self.type = "7"
            self.elements = .seven(movies)
            
        }
    }
}

protocol PagedFeedUpdaterDelegate:class {
    func getMoreResults(completion: (() -> ())?)
}

protocol FeedViewModelType:PagedFeedUpdaterDelegate {
    var feed:JSONFeed { get set }
    var singeImageTasks:[Int: ImageTask] { get set }
    var multipleImageTasks:[Int: [ImageTask]] { get set }
    var pagedFeedUpdaterDelegate:PagedFeedUpdaterDelegate? { get set }
    var feedResetCompletion:(()->())? { get set}
    func setImageTasks()
    var showTitlesInsideThumbnails:Bool { get set }
}

class FeedViewModel:FeedViewModelType {
    var feedResetCompletion: (() -> ())?
    var feed:JSONFeed
    var singeImageTasks:[Int: ImageTask] = [Int: ImageTask]()
    var multipleImageTasks:[Int : [ImageTask]] = [Int: [ImageTask]]()
    
    var pagedFeedUpdaterDelegate:PagedFeedUpdaterDelegate?
    var showTitlesInsideThumbnails:Bool = false
    
    func getMoreResults(completion: (() -> ())?) {
        self.pagedFeedUpdaterDelegate?.getMoreResults(completion: { [weak self] in
            self?.setImageTasks() //only update new ones
            completion?() //this completion comes from the FeedTypeXCollectionViewDelegate to set the delegate to the imageTasks
        })
    }
    
    init(feed:JSONFeed, showTitlesInsideThumbnails:Bool){
        self.feed = feed
        self.showTitlesInsideThumbnails = showTitlesInsideThumbnails
        setImageTasks()
    }
    
    func setImageTasks(){
        if let elements = feed.elements {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            switch elements {
            case .one(let type1Elements):
                singeImageTasks = [Int: ImageTask]()
                
                for index in 0..<type1Elements.count {
                    if let thumbnailURL = type1Elements[index].thumbnail, let url = URL(string: thumbnailURL) {
                        let imageTask = ImageTask(position: index, url: url, session: session, delegate: nil)
                        singeImageTasks[index] = imageTask
                    }
                }
            case .two(let type2Elements):
                singeImageTasks = [Int: ImageTask]()
            case .seven(let type7Elements):
                for index in 0..<type7Elements.count {
                    if singeImageTasks[index] == nil {
                        if let thumbnailURL = type7Elements[index].thumbnail, let url = URL(string: thumbnailURL) {
                            let imageTask = ImageTask(position: index, url: url, session: session, delegate: nil)
                            singeImageTasks[index] = imageTask
                        }
                    }
                }
            }
        }
    }
    
}
