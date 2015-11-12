//
//  AppDelegate.swift
//  Alt
//
//  Created by Francis Chong on 11/08/2015.
//  Copyright (c) 2015 Francis Chong. All rights reserved.
//

import UIKit
import Alt

class App {
    static func isTestTarget() -> Bool {
        return NSProcessInfo.processInfo().environment["XCInjectBundle"] != nil
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return true
    }
}

