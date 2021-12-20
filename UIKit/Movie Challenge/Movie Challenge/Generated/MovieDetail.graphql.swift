// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class MovieDetailQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query MovieDetail($identifier: Int!) {
      movie(id: $identifier) {
        __typename
        title
        voteAverage
        posterPath
        overview
        genres
        cast {
          __typename
          name
        }
        director {
          __typename
          name
        }
      }
    }
    """

  public let operationName: String = "MovieDetail"

  public var identifier: Int

  public init(identifier: Int) {
    self.identifier = identifier
  }

  public var variables: GraphQLMap? {
    return ["identifier": identifier]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("movie", arguments: ["id": GraphQLVariable("identifier")], type: .object(Movie.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(movie: Movie? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "movie": movie.flatMap { (value: Movie) -> ResultMap in value.resultMap }])
    }

    public var movie: Movie? {
      get {
        return (resultMap["movie"] as? ResultMap).flatMap { Movie(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "movie")
      }
    }

    public struct Movie: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Movie"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("voteAverage", type: .nonNull(.scalar(Double.self))),
          GraphQLField("posterPath", type: .scalar(String.self)),
          GraphQLField("overview", type: .nonNull(.scalar(String.self))),
          GraphQLField("genres", type: .nonNull(.list(.nonNull(.scalar(String.self))))),
          GraphQLField("cast", type: .nonNull(.list(.nonNull(.object(Cast.selections))))),
          GraphQLField("director", type: .nonNull(.object(Director.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(title: String, voteAverage: Double, posterPath: String? = nil, overview: String, genres: [String], cast: [Cast], director: Director) {
        self.init(unsafeResultMap: ["__typename": "Movie", "title": title, "voteAverage": voteAverage, "posterPath": posterPath, "overview": overview, "genres": genres, "cast": cast.map { (value: Cast) -> ResultMap in value.resultMap }, "director": director.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
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

      public var overview: String {
        get {
          return resultMap["overview"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "overview")
        }
      }

      public var genres: [String] {
        get {
          return resultMap["genres"]! as! [String]
        }
        set {
          resultMap.updateValue(newValue, forKey: "genres")
        }
      }

      public var cast: [Cast] {
        get {
          return (resultMap["cast"] as! [ResultMap]).map { (value: ResultMap) -> Cast in Cast(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Cast) -> ResultMap in value.resultMap }, forKey: "cast")
        }
      }

      public var director: Director {
        get {
          return Director(unsafeResultMap: resultMap["director"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "director")
        }
      }

      public struct Cast: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Cast"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(name: String) {
          self.init(unsafeResultMap: ["__typename": "Cast", "name": name])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }

      public struct Director: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Director"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(name: String) {
          self.init(unsafeResultMap: ["__typename": "Director", "name": name])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }
    }
  }
}
