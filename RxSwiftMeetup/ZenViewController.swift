//
//  ViewController.swift
//  RxSwiftMeetup
//
//  Created by Mostafa Amer on 04.12.17.
//  Copyright © 2017 Mostafa Amer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
/// A type representing a view model
protocol ZenViewModelType {
    var isLoading: Driver<Bool> { get }
    var canLoad: Driver<Bool> { get }
    var load: AnyObserver<Void> { get }
    var content: Driver<String> { get }
    var color: Driver<UIColor> { get }
}

class ZenViewController: UIViewController {
    var viewModel: ZenViewModelType!
    let bag = DisposeBag()

    @IBOutlet private weak var zen: UILabel!
    @IBOutlet private weak var load: UIButton!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.isLoading.drive(spinner.rx.isAnimating).disposed(by: bag)
        viewModel.canLoad.drive(load.rx.isEnabled).disposed(by: bag)
        viewModel.isLoading.drive(zen.rx.isHidden).disposed(by: bag)
        load.rx.tap.bind(to: viewModel.load).disposed(by: bag)
        viewModel.content.drive(zen.rx.text).disposed(by: bag)
        viewModel.color.drive(zen.rx.textColor).disposed(by: bag)
    }
}

extension Reactive where Base: UILabel {
    var textColor: Binder<UIColor> {
        return Binder(base) {label, color in
            label.textColor = color
        }
    }
}
