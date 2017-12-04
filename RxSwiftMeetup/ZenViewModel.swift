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
    
    var isLoading: Driver<Bool> {
        return zenRequest.executing.asDriver(onErrorJustReturn: false)
    }
    var canLoad: Driver<Bool> {
        return zenRequest.enabled.asDriver(onErrorJustReturn: false)
    }
    var load: AnyObserver<Void> {
        return zenRequest.inputs.asObserver()
    }
    var content: Driver<String> {
        let errorMessage: Observable<String> = zenRequest.errors.map {
            guard case .underlyingError(let error) = $0,
                let _error = error as? APIClient.Error else {
                    return "Something went wrong. Try again."
            }
            switch _error {
            case .noInternet:
                return "No internet connection. Try to reconnect."
            case .requestTimedOut:
                return "Request timed out. Try again."
            case .unknown:
                return "Something went wrong. Try again."
            }
        }
        return Observable
            .merge([
                zenRequest.elements,
                errorMessage,
                ])
            .asDriver(onErrorJustReturn: "")
    }
    var color:Driver<UIColor> {
        return Observable
            .merge([
                zenRequest.elements.map { _ in .black },
                zenRequest.errors.map { _ in .red},
                ])
            .asDriver(onErrorJustReturn: .black)
    }
}
