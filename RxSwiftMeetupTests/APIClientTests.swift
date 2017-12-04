//
//  APIClientTests.swift
//  RxSwiftMeetupTests
//
//  Created by Mostafa Amer on 04.12.17.
//  Copyright © 2017 Mostafa Amer. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import RxTestExt
@testable import RxSwiftMeetup

class APIClientTests: XCTestCase {
    var scheduler: TestScheduler!
    var mockSession: MockURLSession!
    var sut: APIClient!
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        mockSession = MockURLSession(scheduler)
        sut = APIClient(session: mockSession)
    }
    
    override func tearDown() {
        sut = nil
        mockSession = nil
        scheduler = nil
        super.tearDown()
    }

    func testRequestCorrectURL() {
        _ = scheduler.record(source: sut.zen())
        scheduler.start()
        XCTAssertEqual(mockSession.requestedURL, "https://api.github.com/zen")
    }

    class MockURLSession: URLSessionType {
        private let scheduler: TestScheduler
        init(_ scheduler: TestScheduler) {
            self.scheduler = scheduler
        }

        var requestEvents: [Recorded<Event<Data>>] = []
        var requestedURL: String?
        func request(url: URL) -> Observable<Data> {
            requestedURL = url.absoluteString
            return scheduler.createColdObservable(requestEvents).asObservable()
        }
    }
}
