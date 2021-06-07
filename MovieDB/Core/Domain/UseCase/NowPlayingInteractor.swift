//
//  NowPlayingInteractor.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import RxSwift

protocol NowPlayingUseCase {
  func getNowPlaying() -> Observable<[Movie]>
}

class NowPlayingInteractor: NowPlayingUseCase {
  private let repository: MovieRepositoryProtocol

  required init(repository: MovieRepositoryProtocol) {
    self.repository = repository
  }

  func getNowPlaying() -> Observable<[Movie]> {
    repository.getNowPlaying()
  }
}
