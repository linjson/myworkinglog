//
//  AppDelegate.swift
//  MyWorkingLog
//
//  Created by linjson on 16/6/13.
//  Copyright © 2016年 linjson. All rights reserved.
//

import Cocoa

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {

    var mainWindow:WindowController?=nil;
    
	func applicationDidFinishLaunching(_ aNotification: Notification) {
        
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        NSApp.activate(ignoringOtherApps: false);
        mainWindow?.window?.makeKeyAndOrderFront(self);
        return true;
    }
}

