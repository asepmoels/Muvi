//
//  SearchMovieInteractor.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import RxSwift

protocol SearchMovieUseCase {
  func searchMovie(keyword: String) -> Observable<[Movie]>
}

class SearchMovieInteractor: SearchMovieUseCase {
  private let repository: MovieRepositoryProtocol

  required init(repository: MovieRepositoryProtocol) {
    self.repository = repository
  }

  func searchMovie(keyword: String) -> Observable<[Movie]> {
    repository.searchMovie(keyword: keyword)
  }
}
