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
    // MARK: color
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
