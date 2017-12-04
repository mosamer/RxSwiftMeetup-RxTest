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
        scheduler = TestScheduler(initialClock: 0)
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
    // MARK: can load
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
