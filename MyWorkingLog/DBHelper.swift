//
//  WorkingLog.swift
//  MyWorkingLog
//
//  Created by linjson on 16/6/14.
//  Copyright © 2016年 linjson. All rights reserved.
//

import Foundation
import SQLite

open class DBHelper {

	var dbPath: String!;

	var db: Connection!;
	var project: ProjectTable!;
	var workinglog: WorkingLogTable!;
	init() {
		let prop = Properties();
		dbPath = prop.dbPath;
		self.createTables();
	}

//	private func createDBFile() {
//		let fileManger = NSFileManager.defaultManager();
//		guard !fileManger.fileExistsAtPath(dbPath) else {
////			log("\(DBPath) is exists");
//			return;
//		}
//
//		fileManger.createFileAtPath(dbPath, contents: nil, attributes: nil);
//		log("\(dbPath) is created");
//
//	}

	fileprivate func createTables() {
		do {
			self.db = try Connection(dbPath);
			assert(self.db != nil);
			self.workinglog = WorkingLogTable(db: self.db!);
			self.project = ProjectTable(db: self.db!, workingLog: self.workinglog!)

//
//			try db!.run(.createTableSql());
//			try db!.run(.createTableSql());

		}
		catch let err {
			log("sqlite error is", err);
		}
	}

	open func deleteAll() {
		self.project.deleteAll();
		self.workinglog.deleteAll();
	}

}
