//
//  MyWorkingLogTests.swift
//  MyWorkingLogTests
//
//  Created by linjson on 16/6/13.
//  Copyright © 2016年 linjson. All rights reserved.
//

import XCTest

@testable import MyWorkingLog

class MyWorkingLogTests: XCTestCase {

//	var db: DBHelper ;
	override func setUp() {
		super.setUp()
//		db = DBHelper();
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testExample() {
		// This is an example of a functional test case.
//		Use XCTAssert and related functions to verify your tests produce the correct results.
	}

	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}

	func testDB() {
//        let db = DBHelper();

//		let a = db.project?.addProject("test", time: "ss");
//		let a = db.project?.updateProject(2000, name: "test1");
//		let a = db.project?.deleteById(100);

//		let a = db.workinglog?.addWorkingLog(1, content: "tset", createTime: "ss", workTime: 4.0, workType: "ss");
//		var b = [Int64(11)];
//		b.append(3);
//
//		db.workinglog?.deteleById(b);

//		let a = db.workinglog?.updateWorkingLog(2, content: "dddd", workTime: 3, workType: "");
//		var b = [Int64()];
//		b.append(2);
//		let a = db.workinglog?.moveWorkingLog(b, pid: 20);
//
//		log(a)
//		XCTAssert(a >= 0, "成功");

	}

	func testlist() {
//		let db = DBHelper();
//		let list = db.project?.findAll();
//		if let data = list {
//			for i in data {
//				log(i[(db.project?.id)!], i[(db.project?.projectName)!]);
//			}
//		}
	}

	func testData() {
		let db = DBHelper();
//		let id = db.project?.addProject("s", time: "s");

//		for _ in 0...10 {
//			db.workinglog?.addWorkingLog(id!, content: "test", createTime: "ss", workTime: 3, workType: "");
//		}

		let list = db.project?.findAll();

		list?.forEach { r in log(r.projectName) };
	}

	func testAddData() {
//		let db = DBHelper();
//		db.deleteAll();
//		let date = Date.init();
//
//		let format = DateFormatter.init();
//		format.dateFormat = "yyyy-MM-dd HH:mm:ss";
//
//		let dateString = format.string(from: date);
//
//		for i in 0...2 {
//			let name = "pro";
//			let n = name + String(i);
//			guard let pid = db.project?.addProject(n, time: dateString) else {
//				continue;
//			}
//			if (Int(pid) != ERROR) {
//				for x in 0...10 {
//					let content = n + ("-item" + String(x))
//					let s = 2.4;
//
//					db.workinglog?.addWorkingLog(pid, content: content, createTime: dateString, workTime: s, workType: "其他");
//				}
//			}
//		}
//
//		db.project?.addProject("pro1", time: "");
	}

	func testString() {
        
        let date="2010-10-10 33:33:33";
        NSLog("==>%@", date.subString(13));
        
        
//
//        let db=DBHelper();
//        let data=db.workinglog.find(pid: "s");
//        log(data.count);

	}
}
