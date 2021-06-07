//
//  RemoteDataSource.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import RxSwift

protocol RemoteDataSourceProtocol {
  func getNowPlaying() -> Observable<[Movie]>
}

struct RemoteDataSource: RemoteDataSourceProtocol {
  func getNowPlaying() -> Observable<[Movie]> {
    NetworkService.shared
      .connect(api: .nowPlaying, responseType: MovieResponse.self)
      .compactMap({ $0.results })
  }
}
