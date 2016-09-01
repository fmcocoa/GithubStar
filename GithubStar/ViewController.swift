//
//  ViewController.swift
//  GithubStar
//
//  Created by Yuankun Zhang on 8/31/16.
//  Copyright © 2016 Yuankun Zhang. All rights reserved.
//

import Cocoa

enum ServiceError: ErrorType {
    case NoViewController
    case IncorrectViewControllerClass
}

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let wc = storyboard?.instantiateControllerWithIdentifier("SingleService") as? NSWindowController {
            wc.showWindow(nil)
        }
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

