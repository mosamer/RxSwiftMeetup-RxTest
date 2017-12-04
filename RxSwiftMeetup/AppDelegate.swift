//
//  AppDelegate.swift
//  RxSwiftMeetup
//
//  Created by Mostafa Amer on 04.12.17.
//  Copyright © 2017 Mostafa Amer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        guard let zenVC = window?.rootViewController as? ZenViewController else {
            fatalError()
        }

        let apiClient = APIClient(session: URLSession.shared)
        let zenVM = ZenViewModel(api: apiClient)
        zenVC.viewModel = zenVM
        
        return true
    }

}

