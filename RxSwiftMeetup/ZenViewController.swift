//
//  ViewController.swift
//  RxSwiftMeetup
//
//  Created by Mostafa Amer on 04.12.17.
//  Copyright © 2017 Mostafa Amer. All rights reserved.
//

import UIKit

/// A type representing a view model
protocol ZenViewModelType {

}

class ZenViewController: UIViewController {
    var viewModel: ZenViewModelType!

    @IBOutlet private weak var zen: UILabel!
    @IBOutlet private weak var load: UIButton!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

