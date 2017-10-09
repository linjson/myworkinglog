//
//  ProjectManagerViewController.swift
//  MyWorkingLog
//
//  Created by linjson on 16/8/2.
//  Copyright © 2016年 linjson. All rights reserved.
//

import Cocoa

class ProjectManagerViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate
{

	@IBOutlet weak var txtDelete: NSTextField!
	@IBOutlet weak var txtModifyName: NSTextField!
	@IBOutlet weak var modifyBox: NSBox!
	@IBOutlet weak var txtNewName: NSTextField!
	@IBOutlet weak var addBox: NSBox!
	@IBOutlet weak var outlineView: NSOutlineView!
	var projectData: [Project]!;
	var modifyData: Project?;

	override func viewDidLoad() {

		outlineView.dataSource = self;
		outlineView.delegate = self;

	}

	override func viewWillAppear() {

		showAddBox();

		refreshData();
	}

	func closeWindow() {
		self.view.window?.sheetParent?.endSheet((self.view.window)!);
	}

	func refreshData() {
		projectData = dbHelper.project.findAllCount();
		outlineView.reloadData();
	}

	func showAddBox() {
		txtNewName.objectValue = "";
		modifyBox.isHidden = true;
		addBox.isHidden = false;
	}

	func showModifyBox() {
		txtDelete.isHidden = true;
		txtModifyName.stringValue = "";
		modifyBox.isHidden = false;
		addBox.isHidden = true;
	}

	@IBAction func doClose(_ sender: AnyObject) {
		self.closeWindow();
	}

	@IBAction func doAdd(_ sender: AnyObject) {
		showAddBox()
	}

	@IBAction func doRemove(_ sender: AnyObject) {

		if (outlineView.selectedRow == -1) {
			return;
		}

		if (projectData.count == 0) {
			return;
		}

		let p = projectData[outlineView.selectedRow];
		if (p.workinglogCount != 0 && txtDelete.isHidden) {
			txtDelete.isHidden = false;
			return;
		}
		let r = dbHelper.project.deleteById(p.id);

		if (r != ERROR) {
			NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_POPALERT), object: PopAlertType.success.rawValue);
			refreshData();
			notifyData();
			showAddBox();
		} else {
			NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_POPALERT), object: PopAlertType.error.rawValue);
			log("doRemove error");
		}
	}

	@IBAction func doAddApply(_ sender: AnyObject) {

		if (txtNewName.stringValue == "") {
			Alert.show(self.view.window!, error: "内容不能为空");
			return;
		}

		let date = Date.init();

		let format = DateFormatter.init();
		format.dateFormat = "yyyy-MM-dd HH:mm:ss";

		let dateString = format.string(from: date);

		let p = Project();
		p.projectName = txtNewName.stringValue;
		p.createTime = dateString;

		let r = dbHelper.project.addProject(modal: p);

		if (r != Int64(ERROR)) {
			NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_POPALERT), object: PopAlertType.success.rawValue);
			refreshData();
			txtNewName.stringValue = "";
			notifyData();
		} else {
			NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_POPALERT), object: PopAlertType.error.rawValue);
			log("doAddApply error");
		}

	}

	func notifyData() {
		NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_DATACHANGE_PROJECT), object: nil);
	}

	@IBAction func doModifyApply(_ sender: AnyObject) {

		if (txtModifyName.stringValue == "") {
			Alert.show(self.view.window!, error: "内容不能为空");
			return;
		}

		guard let m = modifyData else {
			return;
		}

		let r = dbHelper.project.updateProject(m.id, name: txtModifyName.stringValue);

		if (r == ERROR) {
			NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_POPALERT), object: PopAlertType.error.rawValue);
			log("doModifyApply error");
		} else {
			NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_POPALERT), object: PopAlertType.success.rawValue);
			refreshData();
			notifyData();
		}
	}
	func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
		return projectData == nil ? 0 : projectData.count;
	}

	func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
		return false;
	}

	func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
		return item;
	}

	func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
		return projectData[index];
	}

	func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
		let row: Project = item as! Project;

		let a = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DataCell"), owner: item) as! NSTableCellView;
		a.textField?.objectValue = "\(row.projectName)(\(row.workinglogCount))";
		return a;
	}

	func outlineViewSelectionDidChange(_ notification: Notification) {
		showModifyBox();
		modifyData = projectData[outlineView.selectedRow];
		txtModifyName.stringValue = modifyData!.projectName;
	}
}
