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
		NotificationCenter.default.addObserver(self, selector: #selector(changeProject), name: NSNotification.Name(rawValue: NOTIFY_DATACHANGE_CHANGEPROJECTSELECT), object: nil);
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
			puProject.addItem(withTitle: p.projectName)
		};
	}

	override func viewWillAppear() {
		bindPUProjectData();
		btnModify.isHidden = working == nil;
		if (working != nil) {
			bindData();
			command = "modify";
		} else {
			var pid: Int64 = 0;
			if (selectProjectId != nil) {
				pid = selectProjectId;
			}
			selectProject(pid);
			command = "add";
		}
	}

	override func viewDidDisappear() {
		resetField();
	}

	@IBAction func doAdd(_ sender: AnyObject) {

		if (command == "add") {

			if (!validateData()) {
				return ;
			}

			let working = WorkingLog();
			working.content = txtContent.string!;
			working.workTime = txtLength.objectValue as! Double;
			working.workType = (puType.selectedItem?.title)!;
			working.createTime = (dpDate.formatter as! DateFormatter).string(from: dpDate.dateValue);
			working.pid = projectData[puProject.indexOfSelectedItem].id;

			let r = dbHelper.workinglog.addWorkingLog(modal: working);
			if (r != Int64(ERROR)) {
				NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_POPALERT), object: PopAlertType.success.rawValue);
				closeWindow();
				NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_DATACHANGE_WORKINGLOG), object: nil);
			} else {
				NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_POPALERT), object: PopAlertType.error.rawValue);
				log("doAdd error");
			}
		}

	}

	@IBAction func doCancal(_ sender: AnyObject) {
		closeWindow();
	}

	@IBAction func doModify(_ sender: AnyObject) {
		if (command == "modify") {
			working.content = txtContent.string!;
			working.workTime = txtLength.objectValue as! Double;
			working.workType = (puType.selectedItem?.title)!;
			working.createTime = (dpDate.formatter as! DateFormatter).string(from: dpDate.dateValue);
			working.pid = projectData[puProject.indexOfSelectedItem].id;

			let r = dbHelper.workinglog.updateWorkingLog(modal: working);
			if (r != ERROR) {
				NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_POPALERT), object: PopAlertType.success.rawValue);
				working = nil;
				closeWindow();
				NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_DATACHANGE_WORKINGLOG), object: nil);
			} else {
				NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_POPALERT), object: PopAlertType.error.rawValue);
				log("doModify error");
			}
		}
	}

	func changeProject(_ notify: Notification) {
		guard let id = notify.object else { return; }
        self.selectProjectId = id as! Int64;
	}

	func selectProject(_ id: Int64) {
		let i = projectData.index(where: { p -> Bool in p.id == id });
		var index = 0;
		if i != nil {
			index = i!;
		}

		self.puProject.selectItem(at: index);
	}

	func validateData() -> Bool {

		if (txtContent.string == "") {

			Alert.show(self.view.window!, error: "内容不能为空");
			return false;
		}

		return true;
	}

	func resetField() {

		dpDate.dateValue = Date.init();
		txtLength.objectValue = 7.5;
		puType.selectItem(at: 0);
		txtContent.string = "";
		working = nil;

	}

	func bindData() {
		selectProject(working.pid);
		txtLength.objectValue = working.workTime;
		txtContent.string = working.content;
		dpDate.dateValue = (dpDate.formatter as! DateFormatter).date(from: working.createTime)!;
		puType.selectItem(withTitle: working.workType);
	}

	func closeWindow() {
		self.view.window?.sheetParent?.endSheet((self.view.window)!);
	}

	func numberOfItems(in aComboBox: NSComboBox) -> Int {
		return self.projectData.count;
	}

	func comboBox(_ aComboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
		return self.projectData[index].projectName;
	}

}
