//
//  Alert.swift
//  MyWorkingLog
//
//  Created by linjson on 16/8/2.
//  Copyright © 2016年 linjson. All rights reserved.
//

import Cocoa

class Alert {
	static func show(window: NSWindow, error: String) {
		let alert = NSAlert()
		alert.messageText = "ERROR:";
		alert.informativeText = error;
		let errorIcon = NSImage.init(named: "NSStopProgressFreestandingTemplate");

		alert.icon = errorIcon;
		alert.beginSheetModalForWindow(window, completionHandler: { (m) -> Void in });

//		alert.runModal();
	}
}