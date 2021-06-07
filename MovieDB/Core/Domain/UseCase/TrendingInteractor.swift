//
//  TrendingInteractor.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import RxSwift

protocol TrendingUseCase {
  func getTrending() -> Observable<[Movie]>
}

class TrendingInteractor: TrendingUseCase {
  private let repository: MovieRepositoryProtocol

  required init(repository: MovieRepositoryProtocol) {
    self.repository = repository
  }

  func getTrending() -> Observable<[Movie]> {
    repository.getTrending()
  }
}
