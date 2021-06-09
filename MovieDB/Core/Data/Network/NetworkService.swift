//
//  NetworkService.swift
//  MovieDB
//
//  Created by Asep Mulyana on 07/06/21.
//

import Foundation
import RxSwift
import ObjectMapper
import Moya

class NetworkService {
  static let shared = NetworkService()
  private let provider = MoyaProvider<API>()

  func connect<T: Mappable>(api: API, responseType: T.Type) -> Observable<T> {
    let subject = ReplaySubject<T>.createUnbounded()
    provider.request(api) { (response) in
      switch response {
      case .success(let response):
        if let result = try? response.mapJSON() as? [String: Any] {
          if let result = responseType.init(JSON: result) {
            subject.onNext(result)
            subject.onCompleted()
          } else {
            subject.onError(ApiError.failedMapping(json: result))
          }
        } else {
          subject.onError(ApiError.invalidResponse(responseString: (try? response.mapString()) ?? ""))
        }
      case .failure(let error):
        subject.onError(ApiError.networkFailure(error: error))
      }
    }
    return subject
  }
}

enum ApiError: Error {
  case networkFailure(error: Error)
  case invalidResponse(responseString: String)
  case failedMapping(json: [String: Any])

  var localizedDescription: String {
    switch self {
    case .networkFailure(let error):
      return error.localizedDescription
    case .invalidResponse(let responseString):
      return "Invalid response: \(responseString)"
    case .failedMapping:
      return "Failed mapping object"
    }
  }
}
