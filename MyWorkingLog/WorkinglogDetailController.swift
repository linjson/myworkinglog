//
//  WorkingLogDetailController.swift
//  MyWorkingLog
//
//  Created by linjson on 16/7/26.
//  Copyright © 2016年 linjson. All rights reserved.
//

import Cocoa

class WorkinglogDetailController: NSViewController, NSComboBoxDataSource {

	@IBOutlet weak var puProject: NSPopUpButton!
	@IBOutlet weak var puType: NSPopUpButton!
	@IBOutlet weak var btnAdd: NSButton!
	@IBOutlet weak var btnModify: NSButton!
	@IBOutlet weak var dpDate: NSDatePicker!
	@IBOutlet weak var txtLength: NSTextField!
	@IBOutlet var txtContent: NSTextView!
	var isEdit = false;
	var projectData: [Project]!;
	var working: WorkingLog!;
	var command = "add";
	var selectProjectId: Int64!;
	override func viewDidLoad() {
		resetField();
		registerNotifiction();
	}

	func registerNotifiction() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeProject), name: NOTIFY_DATACHANGE_CHANGEPROJECTSELECT, object: nil);
	}
//
//	func unRegisterNotifiction() {
//		NSNotificationCenter.defaultCenter().removeObserver(self, name: NOTIFY_DATACHANGE_CHANGEPROJECTSELECT, object: nil);
//	}

	func bindPUProjectData() {
		projectData = dbHelper.project.findAll(false);
		puProject.removeAllItems();
		projectData.forEach {
			p in
			puProject.addItemWithTitle(p.projectName)
		};
	}

	override func viewWillAppear() {
		bindPUProjectData();
		btnModify.hidden = working == nil;
		if (working != nil) {
			bindData();
			command = "modify";
		} else {
			selectProject(selectProjectId);
			command = "add";
		}
	}

	override func viewDidDisappear() {
		resetField();
	}

	@IBAction func doAdd(sender: AnyObject) {

		if (command == "add") {

			if (!validateData()) {
				return ;
			}

			let working = WorkingLog();
			working.content = txtContent.string!;
			working.workTime = txtLength.objectValue as! Double;
			working.workType = (puType.selectedItem?.title)!;
			working.createTime = (dpDate.formatter as! NSDateFormatter).stringFromDate(dpDate.dateValue);
			working.pid = projectData[puProject.indexOfSelectedItem].id;

			let r = dbHelper.workinglog.addWorkingLog(modal: working);
			if (r != Int64(ERROR)) {
				NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_POPALERT, object: PopAlertType.Success.rawValue);
				closeWindow();
				NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_DATACHANGE_WORKINGLOG, object: nil);
			} else {
				NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_POPALERT, object: PopAlertType.Error.rawValue);
				log("doAdd error");
			}
		}

	}

	@IBAction func doCancal(sender: AnyObject) {
		closeWindow();
	}

	@IBAction func doModify(sender: AnyObject) {
		if (command == "modify") {
			working.content = txtContent.string!;
			working.workTime = txtLength.objectValue as! Double;
			working.workType = (puType.selectedItem?.title)!;
			working.createTime = (dpDate.formatter as! NSDateFormatter).stringFromDate(dpDate.dateValue);
			working.pid = projectData[puProject.indexOfSelectedItem].id;

			let r = dbHelper.workinglog.updateWorkingLog(modal: working);
			if (r != ERROR) {
				NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_POPALERT, object: PopAlertType.Success.rawValue);
				working = nil;
				closeWindow();
				NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_DATACHANGE_WORKINGLOG, object: nil);
			} else {
				NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_POPALERT, object: PopAlertType.Error.rawValue);
				log("doModify error");
			}
		}
	}

	func changeProject(notify: NSNotification) {
		guard let id = notify.object else { return; }
		self.selectProjectId = Int64(id.integerValue);
	}

	func selectProject(id: Int64) {
		let i = projectData.indexOf({ p -> Bool in p.id == id });
		var index = 0;
		if i != nil {
			index = i!;
		}

		self.puProject.selectItemAtIndex(index);
	}

	func validateData() -> Bool {

		if (txtContent.string == "") {

			Alert.show(self.view.window!, error: "内容不能为空");
			return false;
		}

		return true;
	}

	func resetField() {

		dpDate.dateValue = NSDate.init();
		txtLength.objectValue = 7.5;
		puType.selectItemAtIndex(0);
		txtContent.string = "";
		working = nil;

	}

	func bindData() {
		selectProject(working.pid);
		txtLength.objectValue = working.workTime;
		txtContent.string = working.content;
		dpDate.dateValue = (dpDate.formatter as! NSDateFormatter).dateFromString(working.createTime)!;
		puType.selectItemWithTitle(working.workType);
	}

	func closeWindow() {
		self.view.window?.sheetParent?.endSheet((self.view.window)!);
	}

	func numberOfItemsInComboBox(aComboBox: NSComboBox) -> Int {
		return self.projectData.count;
	}

	func comboBox(aComboBox: NSComboBox, objectValueForItemAtIndex index: Int) -> AnyObject {
		return self.projectData[index].projectName;
	}

}