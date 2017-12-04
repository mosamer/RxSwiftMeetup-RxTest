//
//  APIClient.swift
//  RxSwiftMeetup
//
//  Created by Mostafa Amer on 04.12.17.
//  Copyright © 2017 Mostafa Amer. All rights reserved.
//

import Foundation
import RxSwift
/// A type representing URL session to perform network operations necessary for `APIClient`.
protocol URLSessionType {
    func request(url: URL) -> Observable<Data>
}

extension URLSession: URLSessionType {
    func request(url: URL) -> Observable<Data> {
        return rx.data(request: URLRequest(url: url))
    }
}

class APIClient: ZenAPI {
    enum Error: Swift.Error {
        case noInternet
        case requestTimedOut
        case unknown
    }

    private let session: URLSessionType
    init(session: URLSessionType) {
        self.session = session
    }

    func zen() -> Observable<String> {
        return Observable
            .deferred {
                Observable.just("https://api.github.com/zen")
            }
            .flatMap {[unowned self] url -> Observable<Data> in
                return self.session.request(url: URL(string: url)!)
            }
            .map {
                String(data: $0, encoding: .utf8)!
        }
            .catchError {
                let error = $0 as NSError
                guard error.domain == NSURLErrorDomain else { throw Error.unknown }
                switch error.code {
                case NSURLErrorTimedOut:
                    throw Error.requestTimedOut
                case NSURLErrorNotConnectedToInternet:
                    throw Error.noInternet
                default:
                    throw Error.unknown
                }
        }
    }
}
