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

		outlineView.setDataSource(self);
		outlineView.setDelegate(self);

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
		modifyBox.hidden = true;
		addBox.hidden = false;
	}

	func showModifyBox() {
		txtDelete.hidden = true;
		txtModifyName.stringValue = "";
		modifyBox.hidden = false;
		addBox.hidden = true;
	}

	@IBAction func doClose(sender: AnyObject) {
		self.closeWindow();
	}

	@IBAction func doAdd(sender: AnyObject) {
		showAddBox()
	}

	@IBAction func doRemove(sender: AnyObject) {

		if (outlineView.selectedRow == -1) {
			return;
		}

		if (projectData.count == 0) {
			return;
		}

		let p = projectData[outlineView.selectedRow];
		if (p.workinglogCount != 0 && txtDelete.hidden) {
			txtDelete.hidden = false;
			return;
		}
		let r = dbHelper.project.deleteById(p.id);

		if (r != ERROR) {
			NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_POPALERT, object: PopAlertType.Success.rawValue);
			refreshData();
			notifyData();
			showAddBox();
		} else {
			NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_POPALERT, object: PopAlertType.Error.rawValue);
			log("doRemove error");
		}
	}

	@IBAction func doAddApply(sender: AnyObject) {

		if (txtNewName.stringValue == "") {
			Alert.show(self.view.window!, error: "内容不能为空");
			return;
		}

		let date = NSDate.init();

		let format = NSDateFormatter.init();
		format.dateFormat = "yyyy-MM-dd HH:mm:ss";

		let dateString = format.stringFromDate(date);

		let p = Project();
		p.projectName = txtNewName.stringValue;
		p.createTime = dateString;

		let r = dbHelper.project.addProject(modal: p);

		if (r != Int64(ERROR)) {
			NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_POPALERT, object: PopAlertType.Success.rawValue);
			refreshData();
			txtNewName.stringValue = "";
			notifyData();
		} else {
			NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_POPALERT, object: PopAlertType.Error.rawValue);
			log("doAddApply error");
		}

	}

	func notifyData() {
		NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_DATACHANGE_PROJECT, object: nil);
	}

	@IBAction func doModifyApply(sender: AnyObject) {

		if (txtModifyName.stringValue == "") {
			Alert.show(self.view.window!, error: "内容不能为空");
			return;
		}

		guard let m = modifyData else {
			return;
		}

		let r = dbHelper.project.updateProject(m.id, name: txtModifyName.stringValue);

		if (r == ERROR) {
			NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_POPALERT, object: PopAlertType.Error.rawValue);
			log("doModifyApply error");
		} else {
			NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_POPALERT, object: PopAlertType.Success.rawValue);
			refreshData();
			notifyData();
		}
	}
	func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
		return projectData == nil ? 0 : projectData.count;
	}

	func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
		return false;
	}

	func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
		return item;
	}

	func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
		return projectData[index];
	}

	func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
		let row: Project = item as! Project;

		let a = outlineView.makeViewWithIdentifier("DataCell", owner: item) as! NSTableCellView;
		a.textField?.objectValue = "\(row.projectName)(\(row.workinglogCount))";
		return a;
	}

	func outlineViewSelectionDidChange(notification: NSNotification) {
		showModifyBox();
		modifyData = projectData[outlineView.selectedRow];
		txtModifyName.stringValue = modifyData!.projectName;
	}
}
