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
  func getPopular() -> Observable<[Movie]>
  func getTopRated() -> Observable<[Movie]>
  func getUpcoming() -> Observable<[Movie]>
  func getTrending() -> Observable<[Movie]>
}
