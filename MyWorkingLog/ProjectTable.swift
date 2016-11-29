//
//  Project.swift
//  MyWorkingLog
//
//  Created by linjson on 16/6/15.
//  Copyright © 2016年 linjson. All rights reserved.
//

import Foundation
import SQLite
open class ProjectTable {
	let table: Table;
	let id: Expression<Int64>;
	let projectName: Expression<String>;
	let createTime: Expression<String>;
	let db: Connection;
	let workingLog: WorkingLogTable;
	public init(db: Connection, workingLog: WorkingLogTable) {
		self.db = db;
		self.workingLog = workingLog;
		table = Table("project");
		id = Expression<Int64>("id");
		projectName = Expression<String>("projectName");
		createTime = Expression<String>("createTime");

		self.createTableSql();
	}

	fileprivate func createTableSql() {

		let sql = self.table.create(ifNotExists: true) {
			t in
			t.column(self.id, primaryKey: true);
			t.column(self.projectName);
//			t.column(self.createTime, null: true);
            t.column(self.createTime);
		};

//		log(sql);

		do {
			try db.run(sql);
		}
		catch {
			log("project table create error");
		}
	}

	open func addProject(_ name: String, time: String) -> Int64 {
		do {
			return try db.run(self.table.insert(projectName <- name, createTime <- time));
		} catch let e {
			log(e)
		}

		return Int64(ERROR);
	}

	open func addProject(modal p: Project) -> Int64 {
		return addProject(p.projectName, time: p.createTime);
	}

	open func updateProject(_ id: Int64, name: String) -> Int {
		let sql = self.table.filter(self.id == id).update(self.projectName <- name);
		do {
			return try db.run(sql);
		} catch let e {
			log(e);
		}
		return ERROR;
	}

	open func findAll(_ hasAll: Bool = true) -> [Project] {

		var list: [Project] = [];

		if (hasAll) {
			let all = Project();
			all.id = -1;
			all.projectName = "全部";
			list.append(all);
		}

		do {
			try db.prepare(self.table.order(self.createTime.asc)).forEach { r in
				let p = Project();
				p.id = r[id];
				p.projectName = r[projectName];
				p.createTime = r[createTime];
				list.append(p);
			};
		} catch let e {
			log(e);
		}

		return list;
	}

	open func deleteById(_ id: Int64) -> Int {
		do {

			try db.transaction {
				try self.db.run(self.table.filter(self.id == id).delete())
				self.workingLog.deleteByPid(id);
			}
			return 1;
		} catch let e {
			log(e);
		}
		return ERROR;
	}

	open func findAllCount() -> [Project] {

		var list: [Project] = [];

		do {
			let statement = try db.prepare("select a.id,a.projectname,count(b.pid) num from project a left join workinglog b on a.id=b.pid group by a.id order by a.createtime");

			statement.forEach { i -> Void in
				let p = Project();
				p.id = i[0] as! Int64;
				p.projectName = i[1] as! String;
				p.workinglogCount = Int(i[2] as! Int64);
				list.append(p);
			}

		} catch let e {
			log(e);
		}
		return list;
	}

	func deleteAll() -> Int {
		do {
			return try db.run(table.delete());
		} catch {
			log(error);
		}
		return ERROR;
	}

}
