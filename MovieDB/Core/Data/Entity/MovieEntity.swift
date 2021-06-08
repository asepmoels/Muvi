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

class MovieResponse: Mappable {
  var totalResults: Int?
  var page: Int?
  var totalPages: Int?
  var results: [MovieEntity]?

  required init?(map: Map) {
    mapping(map: map)
  }

  func mapping(map: Map) {
    totalResults <- map["total_results"]
    page <- map["page"]
    totalPages <- map["total_pages"]
    results <- map["results"]
  }
}

class MovieEntity: Object, Movie, Mappable {
  @objc dynamic var identifier: Int = 0
  dynamic var revenue: Int = 0
  dynamic var popularity: Double = 0
  dynamic var overview: String = ""
  dynamic var releaseDate: String = ""
  dynamic var budget: Int = 0
  dynamic var voteAverage: Double = 0
  dynamic var status: String = ""
  dynamic var title: String = ""
  dynamic var video: Bool = false
  dynamic var adult: Bool = false
  dynamic var originalTitle: String = ""
  dynamic var homepage: String = ""
  dynamic var originalLanguage: String = ""
  dynamic var runtime: Int = 0
  dynamic var voteCount: Int = 0
  dynamic var imdbId: String = ""
  dynamic var tagline: String = ""
  dynamic var backdropURLString: String = ""
  dynamic var posterURLString: String = ""
  var isFavorite: Bool = false

  dynamic private var dataGenres: List<GenreEntity> = List()
  var genres: [Genre] {
    dataGenres.map({ $0 })
  }
  private var dataCasts: [CastEntity]?
  var casts: [Cast]? {
    dataCasts?.map({ $0 })
  }
  private var dataVideos: [VideoEntity]?
  var videos: [Video]? {
    dataVideos?.map({ $0 })
  }
  var backdropURL: URL?
  var posterURL: URL?

  override class func primaryKey() -> String? {
    "identifier"
  }

  override class func ignoredProperties() -> [String] {
    ["genres", "backdropURL", "posterURL", "isFavorite"]
  }

  override init() {
    super.init()
  }

  required init?(map: Map) {
    super.init()
    mapping(map: map)
  }

  func mapping(map: Map) {
    revenue <- map["revenue"]
    popularity <- map["popularity"]
    overview <- map["overview"]
    posterURLString <- map["poster_path"]
    posterURL <- (map["poster_path"], ImageURLTransform())
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
    backdropURL <- (map["backdrop_path"], ImageURLTransform())
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
