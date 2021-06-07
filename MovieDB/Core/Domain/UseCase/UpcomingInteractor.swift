//
//  UpcomingInteractor.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import RxSwift

protocol UpcomingUseCase {
  func getUpcoming() -> Observable<[Movie]>
}

class UpcomingInteractor: UpcomingUseCase {
  private let repository: MovieRepositoryProtocol

  required init(repository: MovieRepositoryProtocol) {
    self.repository = repository
  }

  func getUpcoming() -> Observable<[Movie]> {
    repository.getUpcoming()
  }
}
