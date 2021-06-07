//
//  TopRatedInteractor.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import RxSwift

protocol TopRatedUseCase {
  func getTopRated() -> Observable<[Movie]>
}

class TopRatedInteractor: TopRatedUseCase {
  private let repository: MovieRepositoryProtocol

  required init(repository: MovieRepositoryProtocol) {
    self.repository = repository
  }

  func getTopRated() -> Observable<[Movie]> {
    repository.getTopRated()
  }
}
