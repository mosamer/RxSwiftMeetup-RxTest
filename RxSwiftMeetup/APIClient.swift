//
//  APIClient.swift
//  RxSwiftMeetup
//
//  Created by Mostafa Amer on 04.12.17.
//  Copyright © 2017 Mostafa Amer. All rights reserved.
//

import Foundation

/// A type representing URL session to perform network operations necessary for `APIClient`.
protocol URLSessionType {

}

extension URLSession: URLSessionType {}

class APIClient: ZenAPI {
    init(session: URLSessionType) {
        
    }
}
