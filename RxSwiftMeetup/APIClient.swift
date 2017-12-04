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
    private let session: URLSessionType
    init(session: URLSessionType) {
        self.session = session
    }

    func zen() -> Observable<String> {
        return Observable.empty()
    }
}
