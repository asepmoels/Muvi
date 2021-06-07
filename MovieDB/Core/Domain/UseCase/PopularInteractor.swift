//
//  PopularInteractor.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import RxSwift

protocol PopularUseCase {
  func getPopular() -> Observable<[Movie]>
}

class PopularInteractor: PopularUseCase {
  private let repository: MovieRepositoryProtocol

  required init(repository: MovieRepositoryProtocol) {
    self.repository = repository
  }

  func getPopular() -> Observable<[Movie]> {
    repository.getPopular()
  }
}
