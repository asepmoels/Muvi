//
//  MovieRepository.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import RxSwift

struct MovieRepository: MovieRepositoryProtocol {
  private let remoteDataSource: RemoteDataSourceProtocol

  init(remoteDataSource: RemoteDataSourceProtocol) {
    self.remoteDataSource = remoteDataSource
  }

  func getNowPlaying() -> Observable<[Movie]> {
    remoteDataSource.getNowPlaying()
  }
}
