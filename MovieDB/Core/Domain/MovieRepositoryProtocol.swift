//
//  MovieRepositoryProtocol.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import RxSwift

protocol MovieRepositoryProtocol {
  func getNowPlaying() -> Observable<[Movie]>
}
