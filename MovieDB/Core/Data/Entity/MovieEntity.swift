//
//  MovieEntity.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import ObjectMapper

struct MovieResponse: Mappable {
  var totalResults: Int?
  var page: Int?
  var totalPages: Int?
  var results: [MovieEntity]?

  init?(map: Map) {
    mapping(map: map)
  }

  mutating func mapping(map: Map) {
    totalResults <- map["total_results"]
    page <- map["page"]
    totalPages <- map["total_pages"]
    results <- map["results"]
  }
}

struct MovieEntity: Movie, Mappable {
  var revenue: Int?
  var popularity: Double?
  var overview: String?
  var posterURL: URL?
  var releaseDate: String?
  var budget: Int?
  var voteAverage: Double?
  var status: String?
  private var dataGenres: [GenreEntity]?
  var title: String?
  var identifier: Int?
  var video: Bool?
  var adult: Bool?
  var originalTitle: String?
  var backdropURL: URL?
  var homepage: String?
  var originalLanguage: String?
  var runtime: Int?
  var voteCount: Int?
  var imdbId: String?
  var tagline: String?
  var belongsToCollection: Any?
  var genres: [Genre]? {
    dataGenres
  }

  init?(map: Map) {
    mapping(map: map)
  }

  mutating func mapping(map: Map) {
    revenue <- map["revenue"]
    popularity <- map["popularity"]
    overview <- map["overview"]
    posterURL <- (map["poster_path"], ImageURLTransform())
    releaseDate <- map["release_date"]
    budget <- map["budget"]
    voteAverage <- map["vote_average"]
    status <- map["status"]
    dataGenres <- map["genres"]
    title <- map["title"]
    identifier <- map["id"]
    video <- map["video"]
    adult <- map["adult"]
    originalTitle <- map["original_title"]
    backdropURL <- (map["backdrop_path"], ImageURLTransform())
    homepage <- map["homepage"]
    originalLanguage <- map["original_language"]
    runtime <- map["runtime"]
    voteCount <- map["vote_count"]
    imdbId <- map["imdb_id"]
    tagline <- map["tagline"]
    belongsToCollection <- map["belongs_to_collection"]
  }
}
