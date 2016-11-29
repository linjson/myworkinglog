//
//  WorkingLog.swift
//  MyWorkingLog
//
//  Created by linjson on 16/6/17.
//  Copyright © 2016年 linjson. All rights reserved.
//

import Foundation
import SQLite
open class WorkingLogTable {
	let table: Table;
	let id: Expression<Int64>;
	let pid: Expression<Int64>;
	let content: Expression<String>;
	let createTime: Expression<String>;
	let workTime: Expression<Double>;
	let workType: Expression<String>;
	let db: Connection;
	init(db: Connection) {
		self.db = db;
		table = Table("workinglog");
		id = Expression<Int64>("id");
		pid = Expression<Int64>("pid");
		createTime = Expression<String>("createTime");
		content = Expression<String>("content");
		workTime = Expression<Double>("workTime");
		workType = Expression<String>("workType");

		self.createTableSql();
	}

	func createTableSql() {
		let sql = self.table.create(ifNotExists: true) {
			t in
			t.column(self.id, primaryKey: true);
			t.column(self.pid);
			t.column(self.content);
			t.column(self.createTime);
			t.column(self.workTime);
			t.column(self.workType);
		};
		do {
			try db.run(sql);
		} catch {
			log("workinglog table create error");
		}
	}

	func addWorkingLog(_ pid: Int64, content: String, createTime: String, workTime: Double, workType: String) -> Int64 {
		do {
			return try db.run(table.insert(self.pid <- pid, self.content <- content, self.createTime <- createTime, self.workTime <- workTime, self.workType <- workType));
		} catch let e {
			log(e);
		}
		return Int64(ERROR);
	}

	func addWorkingLog(modal working: WorkingLog) -> Int64 {
		return addWorkingLog(working.pid, content: working.content, createTime: working.createTime, workTime: working.workTime, workType: working.workType);
	}

	func deteleById(_ id: [Int64]) -> Int {
		do {
			return try db.run(table.filter(id.contains(self.id)).delete());
		} catch let e {
			log(e);
		}
		return ERROR;
	}

	func deleteByPid(_ pid: Int64) -> Int {
		do {
			return try db.run(table.filter(self.pid == pid).delete());
		} catch let e {
			log(e);
		}

		return ERROR;
	}

	func updateWorkingLog(_ id: Int64, pid: Int64, content: String, workTime: Double, workType: String, createTime: String) -> Int {
		do {
			return try db.run(table.filter(self.id == id).update(self.content <- content, self.workTime <- workTime, self.workType <- workType, self.pid <- pid, self.createTime <- createTime));
		} catch {
			log(error);
		}
		return ERROR;
	}

	func updateWorkingLog(modal working: WorkingLog) -> Int {
		return updateWorkingLog(working.id, pid: working.pid, content: working.content, workTime: working.workTime, workType: working.workType, createTime: working.createTime);
	}

	func moveWorkingLog(_ id: [Int64], pid: Int64) -> Int {
		do {
			return try db.run(table.filter(id.contains(self.id)).update(self.pid <- pid));
		} catch {
			log(error);
		}
		return ERROR;
	}

	func deleteAll() -> Int {
		do {
			return try db.run(table.delete());
		} catch {
			log(error);
		}
		return ERROR;
	}

	func findAll() -> [WorkingLog] {
		return findByPid(-999);
	}

	func findByPid(_ proid: Int64) -> [WorkingLog] {

		var list: [WorkingLog] = [];

		do {
			var table = self.table;
			if (proid != -999) {
				table = table.filter(self.pid == proid)
			}

			try db.prepare(table.order(self.createTime.desc)).forEach { r in
				let w = WorkingLog();
				w.id = r[id];
				w.content = r[content];
				w.pid = r[pid];
				w.createTime = r[createTime].subString(10);
				w.workTime = r[workTime];
				w.workType = r[workType];
				list.append(w);
			};
		} catch let e {
			log(e);
		}

		return list;
	}
}
