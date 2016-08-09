//
//  Const.swift
//  MyWorkingLog
//
//  Created by linjson on 16/7/25.
//  Copyright © 2016年 linjson. All rights reserved.
//

import Foundation

let NOTIFY_DATACHANGE_PROJECT = "NOTIFY_DATACHANGE_PROJECT";
let NOTIFY_DATACHANGE_WORKINGLOG = "NOTIFY_DATACHANGE_WORKINGLOG";
let NOTIFY_EDITWORKINGLOG = "NOTIFY_EDITWORKINGLOG";
let NOTIFY_POPALERT = "NOTIFY_POPALERT";
let NOTIFY_DATACHANGE_CHANGEPROJECTSELECT = "NOTIFY_DATACHANGE_CHANGEPROJECTSELECT";
let DRAG_PROJECTITEM = "DGAG_PROJECTITEM";

let ERROR = 0;

var dbHelper = DBHelper();

func log(items: Any...) {
	let debug = true;
	if (debug) {
		print("==>", items);
	}
}

