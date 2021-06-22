//
//  MovieEntity.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

public class MovieResponse: Mappable {
  public var totalResults: Int?
  public var page: Int?
  public var totalPages: Int?
  public var results: [MovieEntity]?

  public required init?(map: Map) {
    mapping(map: map)
  }

  public func mapping(map: Map) {
    totalResults <- map["total_results"]
    page <- map["page"]
    totalPages <- map["total_pages"]
    results <- map["results"]
  }
}

public class MovieEntity: Object, Movie, Mappable {
  @objc dynamic public var identifier: Int = 0
  @objc dynamic public var revenue: Int = 0
  @objc dynamic public var popularity: Double = 0
  @objc dynamic public var overview: String = ""
  @objc dynamic public var releaseDate: String = ""
  @objc dynamic public var budget: Int = 0
  @objc dynamic public var voteAverage: Double = 0
  @objc dynamic public var status: String = ""
  @objc dynamic public var title: String = ""
  @objc dynamic public var video: Bool = false
  @objc dynamic public var adult: Bool = false
  @objc dynamic public var originalTitle: String = ""
  @objc dynamic public var homepage: String = ""
  @objc dynamic public var originalLanguage: String = ""
  @objc dynamic public var runtime: Int = 0
  @objc dynamic public var voteCount: Int = 0
  @objc dynamic public var imdbId: String = ""
  @objc dynamic public var tagline: String = ""
  @objc dynamic public var backdropURLString: String = ""
  @objc dynamic public var posterURLString: String = ""
  public var isFavorite: Bool = false

  dynamic private var dataGenres: List<GenreEntity> = List()
  public var genres: [Genre] {
    dataGenres.map({ $0 })
  }
  private var dataCasts: [CastEntity]?
  public var casts: [Cast]? {
    dataCasts?.map({ $0 })
  }
  private var dataVideos: [VideoEntity]?
  public var videos: [Video]? {
    dataVideos?.map({ $0 })
  }
  public var backdropURL: URL? {
    ImageURLTransform().transformFromJSON(backdropURLString)
  }
  public var posterURL: URL? {
    ImageURLTransform().transformFromJSON(posterURLString)
  }

  public override class func primaryKey() -> String? {
    "identifier"
  }

  public override class func ignoredProperties() -> [String] {
    ["genres", "backdropURL", "posterURL", "isFavorite"]
  }

  public override init() {
    super.init()
  }

  public required init?(map: Map) {
    super.init()
    mapping(map: map)
  }

  public func mapping(map: Map) {
    revenue <- map["revenue"]
    popularity <- map["popularity"]
    overview <- map["overview"]
    posterURLString <- map["poster_path"]
    releaseDate <- map["release_date"]
    budget <- map["budget"]
    voteAverage <- map["vote_average"]
    status <- map["status"]
    dataGenres <- (map["genres"], ListTransform<GenreEntity>())
    title <- map["title"]
    identifier <- map["id"]
    video <- map["video"]
    adult <- map["adult"]
    originalTitle <- map["original_title"]
    backdropURLString <- map["backdrop_path"]
    homepage <- map["homepage"]
    originalLanguage <- map["original_language"]
    runtime <- map["runtime"]
    voteCount <- map["vote_count"]
    imdbId <- map["imdb_id"]
    tagline <- map["tagline"]
    dataVideos <- map["videos.results"]
    dataCasts <- map["casts.cast"]
  }
}
