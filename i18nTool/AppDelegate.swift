//
//  AppDelegate.swift
//  i18nTool
//
//  Created by yangming on 2019/5/20.
//  Copyright © 2019 AL. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        self.window.contentViewController = MainViewController.init()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

