//
//  DetailMovieInteractor.swift
//  MovieDB
//
//  Created by Asep Mulyana on 08/06/21.
//

import Foundation
import RxSwift

protocol DetailMovieUseCase {
  func getDetail(movieId: String) -> Observable<Movie>
}

class DetailMovieInteractor: DetailMovieUseCase {
  private let repository: MovieRepositoryProtocol

  required init(repository: MovieRepositoryProtocol) {
    self.repository = repository
  }

  func getDetail(movieId: String) -> Observable<Movie> {
    repository.getDetailMovie(movieId: movieId)
  }
}
