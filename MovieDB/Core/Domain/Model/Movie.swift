//
//  Movie.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation

protocol Movie {
  var revenue: Int { get }
  var tagline: String { get }
  var imdbId: String { get }
  var homepage: String { get }
  var genres: [Genre] { get }
  var video: Bool { get }
  var identifier: Int { get }
  var originalTitle: String { get }
  var releaseDate: String { get }
  var runtime: Int { get }
  var status: String { get }
  var voteAverage: Double { get }
  var adult: Bool { get }
  var title: String { get }
  var voteCount: Int { get }
  var backdropURL: URL? { get }
  var originalLanguage: String { get }
  var overview: String { get }
  var popularity: Double { get }
  var posterURL: URL? { get }
  var budget: Int { get }
  var isFavorite: Bool { get set }
  var casts: [Cast]? { get }
  var videos: [Video]? { get }
}
