//
//  ZenViewModel.swift
//  RxSwiftMeetup
//
//  Created by Mostafa Amer on 04.12.17.
//  Copyright © 2017 Mostafa Amer. All rights reserved.
//

import RxSwift
import RxCocoa
import Action

/// A type representing API client for `ZenViewModel`
protocol ZenAPI {
    func zen() -> Observable<String>
}
class ZenViewModel: ZenViewModelType {
    private let zenRequest: Action<Void, String>
    init(api: ZenAPI) {
        zenRequest = Action {
            api.zen()
        }
    }

    var isLoading: Driver<Bool> { return Driver.empty() }
    var canLoad: Driver<Bool> { return Driver.empty() }
    var load: AnyObserver<Void> {
        return zenRequest.inputs.asObserver()
    }
    var content: Driver<String> { return Driver.empty() }
    var color:Driver<UIColor> { return Driver.empty() }
}
