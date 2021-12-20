// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class PagedAllMoviesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query PagedAllMovies($limit: Int, $offset: Int, $orderBy: String, $sort: Sort, $genre: String, $search: String) {
      movies(
        limit: $limit
        offset: $offset
        orderBy: $orderBy
        sort: $sort
        genre: $genre
        search: $search
      ) {
        __typename
        id
        title
        voteAverage
        posterPath
      }
    }
    """

  public let operationName: String = "PagedAllMovies"

  public var limit: Int?
  public var offset: Int?
  public var orderBy: String?
  public var sort: Sort?
  public var genre: String?
  public var search: String?

  public init(limit: Int? = nil, offset: Int? = nil, orderBy: String? = nil, sort: Sort? = nil, genre: String? = nil, search: String? = nil) {
    self.limit = limit
    self.offset = offset
    self.orderBy = orderBy
    self.sort = sort
    self.genre = genre
    self.search = search
  }

  public var variables: GraphQLMap? {
    return ["limit": limit, "offset": offset, "orderBy": orderBy, "sort": sort, "genre": genre, "search": search]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("movies", arguments: ["limit": GraphQLVariable("limit"), "offset": GraphQLVariable("offset"), "orderBy": GraphQLVariable("orderBy"), "sort": GraphQLVariable("sort"), "genre": GraphQLVariable("genre"), "search": GraphQLVariable("search")], type: .list(.object(Movie.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(movies: [Movie?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "movies": movies.flatMap { (value: [Movie?]) -> [ResultMap?] in value.map { (value: Movie?) -> ResultMap? in value.flatMap { (value: Movie) -> ResultMap in value.resultMap } } }])
    }

    public var movies: [Movie?]? {
      get {
        return (resultMap["movies"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Movie?] in value.map { (value: ResultMap?) -> Movie? in value.flatMap { (value: ResultMap) -> Movie in Movie(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Movie?]) -> [ResultMap?] in value.map { (value: Movie?) -> ResultMap? in value.flatMap { (value: Movie) -> ResultMap in value.resultMap } } }, forKey: "movies")
      }
    }

    public struct Movie: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Movie"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(Int.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("voteAverage", type: .nonNull(.scalar(Double.self))),
          GraphQLField("posterPath", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: Int, title: String, voteAverage: Double, posterPath: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Movie", "id": id, "title": title, "voteAverage": voteAverage, "posterPath": posterPath])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: Int {
        get {
          return resultMap["id"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return resultMap["title"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }

      public var voteAverage: Double {
        get {
          return resultMap["voteAverage"]! as! Double
        }
        set {
          resultMap.updateValue(newValue, forKey: "voteAverage")
        }
      }

      public var posterPath: String? {
        get {
          return resultMap["posterPath"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "posterPath")
        }
      }
    }
  }
}
