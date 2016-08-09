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

	@IBAction func doClose(sender: AnyObject) {
		close();
	}

	@IBAction func doChangeDataBase(sender: AnyObject) {

		if (txtPath.string == dbHelper.dbPath) {
			close();
			return;
		}

		let props = Properties();
		props.dbPath = pcPath.stringValue;
		dbHelper = DBHelper();

		NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_DATACHANGE_PROJECT, object: nil);
		NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_DATACHANGE_WORKINGLOG, object: nil);
		NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_POPALERT, object: PopAlertType.Success.rawValue);

		close();
	}

	@IBAction func changePath(sender: AnyObject) {

		txtPath.string = pcPath.stringValue;
	}
}
