//
//  Network.swift
//  Movie Challenge
//
//  Created by David Mednikov on 12/18/21.
//  Copyright © 2021 David Mednikov. All rights reserved.
//

import Foundation
import Apollo

enum NetworkError: Error {
    case badData
}
class Network {
    static let shared = Network()
    private static let apiEndpoint = "https://podium-fe-challenge-2021.netlify.app/.netlify/functions/graphql"

    private(set) lazy var apollo = ApolloClient(url: URL(string: Self.apiEndpoint)!)
    
    public static let genresQuery = GetGenresQuery()
    
    public func fetchGenres(completion: @escaping (Result<[String],Error>) -> ()){
        Network.shared.apollo.fetch(query: Self.genresQuery) { result in
            switch result {
            case .success(let graphQLResult):
                if let genres = graphQLResult.data?.genres {
                    completion(.success(genres))
                }
                else {
                    completion(.failure(NetworkError.badData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    var sortPreference:MovieSortOptions = .title
    //unpaged -- shouldn't have many results
    public func fetchMoviesBy(genre: String, completion: @escaping (Result<[MovieModel],Error>) -> ()) {
        //genre is case-sensitive -- trigger only by direct tap on genres returned by graphql
        let moviesByGenreQuery:PagedAllMoviesQuery = PagedAllMoviesQuery(limit: nil, offset: nil, orderBy: sortPreference.graphQLSort, sort: sortPreference.graphQLSortDirection, genre: genre, search: nil)
        
        Network.shared.apollo.fetch(query: moviesByGenreQuery) { result in
            switch result {
            case .success(let graphQLResult):
                if let movies = graphQLResult.data?.movies {
                    completion(.success(movies.map({MovieModel(id: $0?.id ?? 0, title: $0?.title ?? "Untitled", thumbnail: $0?.posterPath, rating: $0?.voteAverage)})))
                }
                else {
                    completion(.failure(NetworkError.badData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    //unpaged -- shouldn't have many results
    public func fetchMoviesBy(search: String, completion: @escaping (Result<[MovieModel],Error>) -> ()) {
        //search is not case-sensitive
        let moviesBySearchQuery:PagedAllMoviesQuery = PagedAllMoviesQuery(limit: nil, offset: nil, orderBy: "voteAverage", sort: Sort.desc, genre: nil, search: search)
        
        Network.shared.apollo.fetch(query: moviesBySearchQuery) { result in
            switch result {
            case .success(let graphQLResult):
                if let movies = graphQLResult.data?.movies {
                    completion(.success(movies.map({MovieModel(id: $0?.id ?? 0, title: $0?.title ?? "Untitled", thumbnail: $0?.posterPath, rating: $0?.voteAverage)})))
                }
                else {
                    completion(.failure(NetworkError.badData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func fetchMovieDetailBy(id: Int, completion: @escaping (Result<MovieDetailViewModelType,Error>) -> ()) {
        let movieByIdQuery:MovieDetailQuery = MovieDetailQuery(identifier: id)

        Network.shared.apollo.fetch(query: movieByIdQuery, cachePolicy: .fetchIgnoringCacheCompletely) { result in
            switch result {
            case .success(let graphQLResult):
                if let movie = graphQLResult.data?.movie {
                    completion(.success(MovieDetailViewModel(id: id, title: movie.title, thumbnail: movie.posterPath, rating: movie.voteAverage, description: movie.overview, genres: movie.genres, director: movie.director.name, cast: movie.cast.map({$0.name}))))
                }
                else {
                    completion(.failure(NetworkError.badData))
                }
            case .failure(let error):
                if let irc = error as? Apollo.ResponseCodeInterceptor.ResponseCodeError {
                    switch irc {
                    case Apollo.ResponseCodeInterceptor.ResponseCodeError.invalidResponseCode(let response, let rawData):
                        if let rawData = rawData, let stringData = String(data: rawData, encoding: .utf8) {
                            print("irc.stringData -- \(stringData)")
                            /*
                             irc.stringData -- {"errors":[{"message":"Variable \"$identifier\" of type \"Int\" used in position expecting type \"Int!\".","locations":[{"line":1,"column":17},{"line":2,"column":13}],"extensions":{"code":"GRAPHQL_VALIDATION_FAILED"}}]}
                             */
                        }
                    default:
                        break
                    }
                }
                completion(.failure(error))
            }
        }
    }
}
