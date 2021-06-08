//
//  AddFavoriteInteractor.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import Foundation
import RxSwift

protocol AddFavoriteUseCase {
  func addFavorite(movie: Movie) -> Observable<Movie>
}

class AddFavoriteInteractor: AddFavoriteUseCase {
  private let repository: MovieRepositoryProtocol

  required init(repository: MovieRepositoryProtocol) {
    self.repository = repository
  }

  func addFavorite(movie: Movie) -> Observable<Movie> {
    repository.addFavorite(movie: movie)
  }
}
