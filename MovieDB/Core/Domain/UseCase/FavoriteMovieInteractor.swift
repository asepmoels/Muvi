//
//  FavoriteMovieInteractor.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import Foundation
import RxSwift

protocol FavoriteMovieUseCase {
  func getFavorite(keyword: String) -> Observable<[Movie]>
}

class FavoriteMovieInteractor: FavoriteMovieUseCase {
  private let repository: MovieRepositoryProtocol

  required init(repository: MovieRepositoryProtocol) {
    self.repository = repository
  }

  func getFavorite(keyword: String) -> Observable<[Movie]> {
    repository.getFavorites(keyword: keyword)
  }
}
