//
//  Properties.swift
//  MyWorkingLog
//
//  Created by linjson on 16/8/8.
//  Copyright © 2016年 linjson. All rights reserved.
//

import Cocoa

class Properties {

	var table: NSMutableDictionary!;
	var path: String!;
	var dbPath: String {
		set {
			table.setValue(newValue, forKey: "dbPath");
			table.write(toFile: path, atomically: true);
		}
		get {

			let defaultPath = Bundle.main.path(forResource: "data", ofType: "db")!
			guard let path = table.value(forKey: "dbPath") else {
				return defaultPath;
			}

			let temp = path as! String;

			return temp.isNotNull() ? temp : defaultPath;
		}
	}

	init() {
		path = Bundle.main.path(forResource: "properties", ofType: "plist");
		table = NSMutableDictionary.init(contentsOfFile: path);
	}

}

