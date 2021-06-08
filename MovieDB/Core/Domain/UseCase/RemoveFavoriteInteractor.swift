//
//  RemoveFavoriteInteractor.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import Foundation
import RxSwift

protocol RemoveFavoriteUseCase {
  func removeFavorite(movie: Movie) -> Observable<Movie>
}

class RemoveFavoriteInteractor: RemoveFavoriteUseCase {
  private let repository: MovieRepositoryProtocol

  required init(repository: MovieRepositoryProtocol) {
    self.repository = repository
  }

  func removeFavorite(movie: Movie) -> Observable<Movie> {
    repository.removeFavorite(movie: movie)
  }
}
