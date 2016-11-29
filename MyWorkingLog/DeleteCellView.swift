//
//  DeleteCellView.swift
//  MyWorkingLog
//
//  Created by linjson on 16/7/22.
//  Copyright © 2016年 linjson. All rights reserved.
//

import Cocoa

open class DeleteCellView: NSTableCellView {

	var data: WorkingLog!;
	@IBOutlet weak var btnDelete: NSButton!

	@IBAction func doDeleteClick(_ sender: AnyObject) {
		let r = dbHelper.workinglog.deteleById([data.id])
		if (r != ERROR) {
			NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_POPALERT), object: PopAlertType.success.rawValue);
			NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_DATACHANGE_WORKINGLOG), object: nil);
		} else {
			NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_POPALERT), object: PopAlertType.error.rawValue);
			log("doDeleteClick error");
		}
	}

}
