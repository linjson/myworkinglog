//
//  WorkingLog.swift
//  MyWorkingLog
//
//  Created by linjson on 16/7/21.
//  Copyright © 2016年 linjson. All rights reserved.
//

import Cocoa

open class WorkingLog: NSObject {
	var id: Int64 = -1;
	var pid: Int64 = -1;
	var content: String = "";
	var createTime: String = "";
	var workTime: Double = -1;
	var workType: String = "";

}

//extension WorkingLog: NSPasteboardWriting {
//	public func writableTypesForPasteboard(pasteboard: NSPasteboard) -> [String] {
//		return ["ss"];
//	}
//
//	public func pasteboardPropertyListForType(type: String) -> AnyObject? {
//		return ["ss"];
//	}
//
//	public func writingOptionsForType(type: String, pasteboard: NSPasteboard) -> NSPasteboardWritingOptions {
//		return NSPasteboardWritingOptions.Promised;
//	}
//
//}
