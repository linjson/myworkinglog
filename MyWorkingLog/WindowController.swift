//
//  WindowController.swift
//  MyWorkingLog
//
//  Created by linjson on 16/7/15.
//  Copyright © 2016年 linjson. All rights reserved.
//

import Foundation
import Cocoa
class WindowController: NSWindowController {

	var workinglogDetailWindow: NSWindowController!;
	var projectManagerWindow: NSWindowController!;
	var dataBaseWindow: NSWindowController!;
	override func windowDidLoad() {
		self.window?.titleVisibility = .Hidden;
		workinglogDetailWindow = self.storyboard!.instantiateControllerWithIdentifier("WorkinglogDetailWindow") as! NSWindowController;

		projectManagerWindow = self.storyboard?.instantiateControllerWithIdentifier("ProjectManagerWindow") as! NSWindowController;

		dataBaseWindow = self.storyboard?.instantiateControllerWithIdentifier("DataBaseWindow") as! NSWindowController;

		registerNotifiction();
	}

	override func close() {
		unregisterNotifiction();
	}

	func unregisterNotifiction() {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: NOTIFY_EDITWORKINGLOG, object: nil);
		NSNotificationCenter.defaultCenter().removeObserver(self, name: NOTIFY_POPALERT, object: nil);
	}

	func registerNotifiction() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(openWorkinglogDetail(_:)), name: NOTIFY_EDITWORKINGLOG, object: nil);
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showPopAlert(_:)), name: NOTIFY_POPALERT, object: nil);
	}

	func showPopAlert(notify: NSNotification) {
		guard let type = notify.object else {
			return ;
		}

		let a = type.integerValue;

		PopAlert.create(self.window, with: PopAlertType(rawValue: a)!);
	}

	func openWorkinglogDetail(notify: NSNotification) {

		guard let working = notify.object as? WorkingLog else {
			return ;
		}

		let controller = workinglogDetailWindow.contentViewController as! WorkinglogDetailController;
		controller.working = working;

		self.window?.beginSheet(workinglogDetailWindow.window!, completionHandler: { (NSModalResponse) in

		})

	}

	@IBAction func doAddWorkingLog(sender: AnyObject) {

		self.window?.beginSheet(workinglogDetailWindow.window!, completionHandler: { (NSModalResponse) in

		})
	}
	@IBAction func doOpenDataBaseWindow(sender: AnyObject) {
		self.window?.beginSheet(dataBaseWindow.window!, completionHandler: { (NSModalResponse) in

		})

	}

	@IBAction func doProjectManager(sender: AnyObject) {
		self.window?.beginSheet(projectManagerWindow.window!, completionHandler: { (NSModalResponse) in

		})
	}

	var i = 0;
	@IBAction func test(sender: AnyObject) {
		i += 1;
		PopAlert.create(self.window, with: i % 2 == 0 ? PopAlertType.Error : PopAlertType.Info);

	}
}