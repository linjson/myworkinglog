//
//  DataBaseViewController.swift
//  MyWorkingLog
//
//  Created by linjson on 16/8/8.
//  Copyright © 2016年 linjson. All rights reserved.
//

import Cocoa

class DataBaseViewController: NSViewController {

	@IBOutlet weak var pcPath: NSPathControl!
	@IBOutlet var txtPath: NSTextView!
	override func viewWillAppear() {
		txtPath.string = dbHelper.dbPath;
	}

	func close() {
		self.view.window?.sheetParent?.endSheet((self.view.window)!);
	}

	@IBAction func doClose(_ sender: AnyObject) {
		close();
	}

	@IBAction func doChangeDataBase(_ sender: AnyObject) {

		if (txtPath.string == dbHelper.dbPath) {
			close();
			return;
		}

		let props = Properties();
		props.dbPath = pcPath.stringValue;
		dbHelper = DBHelper();

		NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_DATACHANGE_PROJECT), object: nil);
		NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_DATACHANGE_WORKINGLOG), object: nil);
		NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_POPALERT), object: PopAlertType.success.rawValue);

		close();
	}

	@IBAction func changePath(_ sender: AnyObject) {

		txtPath.string = pcPath.stringValue;
	}
}
