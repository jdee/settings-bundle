//
//  ViewController.swift
//  SettingsBundleGroupExample
//
//  Created by Jimmy Dee on 6/8/17.
//  Copyright © 2017 Jimmy Dee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let bundle = Bundle.main
        guard
            let marketingVersion = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            let buildNumber = bundle.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
            else {
                print("Could not find version info in Info.plist")
                return
        }

        let displayVersion = "Version \(marketingVersion) (\(buildNumber))"

        button.setTitle(displayVersion, for: .normal)
        view.setNeedsLayout()
    }

    @IBAction func showSettings() {
        let url = URL(string: UIApplicationOpenSettingsURLString)!
        
        guard UIApplication.shared.canOpenURL(url) else { return }
        
        UIApplication.shared.open(url, options: [:]) { _ in }
    }

}

