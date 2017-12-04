//
//  ZenViewModelTests.swift
//  RxSwiftMeetupTests
//
//  Created by Mostafa Amer on 04.12.17.
//  Copyright © 2017 Mostafa Amer. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxTestExt
@testable import RxSwiftMeetup

class ZenViewModelTests: XCTestCase {
    var scheduler: TestScheduler!
    var mockAPI: MockAPIClient!
    var sut: ZenViewModel!

    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)
        mockAPI = MockAPIClient(scheduler)
        sut = ZenViewModel(api: mockAPI)
    }
    
    override func tearDown() {
        sut = nil
        mockAPI = nil
        scheduler = nil
        super.tearDown()
    }
    // MARK: is loading
    func testLoadingStateFollowsRequest() {
        mockAPI.zenEvents = [next(10, "Hello, world!"), completed(10)]
        scheduler.bind([next(5, ())], to: sut.load)
        SharingScheduler.mock(scheduler: scheduler) {
            let loading = scheduler.record(source: sut.isLoading)
            scheduler.start()
            XCTAssertEqual(loading.events, [
                next(0, false),
                next(5, true),
                next(15, false),
                ])
        }
    }
    // MARK: can load
    func testDisableLoadWhileRequest() {
        mockAPI.zenEvents = [next(10, "Hello, world!"), completed(10)]
        scheduler.bind([next(5, ())], to: sut.load)
        SharingScheduler.mock(scheduler: scheduler) {
            let enabled = scheduler.record(source: sut.canLoad)
            scheduler.start()
            XCTAssertEqual(enabled.events, [
                next(0, true),
                next(5, false),
                next(15, true),
                ])
        }
    }
    // MARK: load request
    func testCallAPIWhenRequested() {
        scheduler.bind([next(10, ())], to: sut.load)
        scheduler.start()
        XCTAssertEqual(mockAPI.zenCalled, 1)
    }
    // MARK: content
    func testShowResultsAsContent() {
        mockAPI.zenEvents = [next(10, "Hello, world!"), completed(10)]
        scheduler.bind([next(0, ())], to: sut.load)
        SharingScheduler.mock(scheduler: scheduler) {
            let content = scheduler.record(source: sut.content)
            scheduler.start()
            assert(content) == "Hello, world!"
        }
    }
    func testShowNoInternetError() {
        mockAPI.zenEvents = [error(10, APIClient.Error.noInternet)]
        scheduler.bind([next(0, ())], to: sut.load)
        SharingScheduler.mock(scheduler: scheduler) {
            let content = scheduler.record(source: sut.content)
            scheduler.start()
            assert(content) == "No internet connection. Try to reconnect."
        }
    }
    func testShowRequestTimeoutError() {
        mockAPI.zenEvents = [error(10, APIClient.Error.requestTimedOut)]
        scheduler.bind([next(0, ())], to: sut.load)
        SharingScheduler.mock(scheduler: scheduler) {
            let content = scheduler.record(source: sut.content)
            scheduler.start()
            assert(content) == "Request timed out. Try again."
        }
    }
    func testShowUnknownError() {
        mockAPI.zenEvents = [error(10, APIClient.Error.unknown)]
        scheduler.bind([next(0, ())], to: sut.load)
        SharingScheduler.mock(scheduler: scheduler) {
            let content = scheduler.record(source: sut.content)
            scheduler.start()
            assert(content) == "Something went wrong. Try again."
        }
    }
    func testShowOtherError() {
        mockAPI.zenEvents = [error(10, TestError)]
        scheduler.bind([next(0, ())], to: sut.load)
        SharingScheduler.mock(scheduler: scheduler) {
            let content = scheduler.record(source: sut.content)
            scheduler.start()
            assert(content) == "Something went wrong. Try again."
        }
    }
    // MARK: color
    func testShowResultsAsBlack() {
        mockAPI.zenEvents = [next(10, "Hello, world!"), completed(10)]
        scheduler.bind([next(0, ())], to: sut.load)
        SharingScheduler.mock(scheduler: scheduler) {
            let color = scheduler.record(source: sut.color)
            scheduler.start()
            assert(color) == .black
        }
    }
    func testShowErrorsAsRed() {
        mockAPI.zenEvents = [error(10, TestError)]
        scheduler.bind([next(0, ())], to: sut.load)
        SharingScheduler.mock(scheduler: scheduler) {
            let color = scheduler.record(source: sut.color)
            scheduler.start()
            assert(color) == .red
        }
    }
    // MARK:- Mock API
    class MockAPIClient: ZenAPI {
        private let scheduler: TestScheduler
        init(_ scheduler: TestScheduler) {
            self.scheduler = scheduler
        }

        var zenEvents: [Recorded<Event<String>>] = []
        var zenCalled: Int = 0
        func zen() -> Observable<String> {
            zenCalled += 1
            return scheduler.createColdObservable(zenEvents).asObservable()
        }
    }
}
extension Assertion {
    func next(time: TestTime, equal: T) {
        
    }
}
