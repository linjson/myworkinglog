//
//  DeleteCellView.swift
//  MyWorkingLog
//
//  Created by linjson on 16/7/22.
//  Copyright © 2016年 linjson. All rights reserved.
//

import Cocoa

public class DeleteCellView: NSTableCellView {

	var data: WorkingLog!;
	@IBOutlet weak var btnDelete: NSButton!

	@IBAction func doDeleteClick(sender: AnyObject) {
		let r = dbHelper.workinglog.deteleById([data.id])
		if (r != ERROR) {
			NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_POPALERT, object: PopAlertType.Success.rawValue);
			NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_DATACHANGE_WORKINGLOG, object: nil);
		} else {
			NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_POPALERT, object: PopAlertType.Error.rawValue);
			log("doDeleteClick error");
		}
	}

}
