//
//  ViewController.swift
//  MyWorkingLog
//
//  Created by linjson on 16/6/13.
//  Copyright © 2016年 linjson. All rights reserved.
//

import Cocoa

import SQLite

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, NSOutlineViewDelegate, NSOutlineViewDataSource {

	@IBOutlet weak var tableview: NSTableView!
	@IBOutlet weak var listview: NSOutlineView!
	let COL_CONTENT_INDEX = "tContent";
	var colContentWidth: CGFloat = CGFloat(0);
	var projectData: [Project]!;
	var selectPid: Int64!;
	var workingLogData: [WorkingLog]!;
	var selectWorking: [Int64]!;

	override func viewDidLoad() {
		super.viewDidLoad()

		selectPid = Int64(-1);

		resetData();
		// 自动调整大小只有优先列
		tableview.columnAutoresizingStyle = .SequentialColumnAutoresizingStyle;
		// tableview数据绑定
		tableview.setDelegate(self);
		tableview.setDataSource(self);
		tableview.doubleAction = #selector(doTableViewRowDoubleClick);
		tableview.allowsMultipleSelection = true;
		// listview数据绑定
		listview.setDelegate(self);
		listview.setDataSource(self);

		listview.registerForDraggedTypes([DRAG_PROJECTITEM]);

		registerNotifiction();
	}

	override func viewWillDisappear() {
		unRegisterNotifiction();
	}

	override var representedObject: AnyObject? {
		didSet {
			// Update the view, if already loaded.
		}
	}

	func registerNotifiction() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refreshWorkingLogData), name: NOTIFY_DATACHANGE_WORKINGLOG, object: nil);
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(refreshProjectData), name: NOTIFY_DATACHANGE_PROJECT, object: nil);

	}

	func unRegisterNotifiction() {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: NOTIFY_DATACHANGE_WORKINGLOG, object: nil);
		NSNotificationCenter.defaultCenter().removeObserver(self, name: NOTIFY_DATACHANGE_PROJECT, object: nil);
	}

	func refreshProjectData() {
		projectData = dbHelper.project.findAll();
		listview.reloadData();
	}

	func refreshWorkingLogData() {

		if (self.selectPid == -1) {
			workingLogData = dbHelper.workinglog.findAll();
		} else {
			workingLogData = dbHelper.workinglog.findByPid(self.selectPid);
		}
		tableview.reloadData();

	}

	func resetData() {

		workingLogData = dbHelper.workinglog.findAll();
		projectData = dbHelper.project.findAll();
	}

	func doTableViewRowDoubleClick() {
		let row = tableview.selectedRow;

		if (row > -1) {
			NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_EDITWORKINGLOG, object: workingLogData[row]);
		}

	}

	override func keyDown(theEvent: NSEvent) {

		if (tableview.selectedRow == -1) {
			return;
		}

		// copy
		if (NSEvent.modifierFlags() == NSEventModifierFlags.CommandKeyMask && theEvent.keyCode == 8) {
			let c = workingLogData[tableview.selectedRow].content;
			self.writeToPasteboard(c) ;
			NSNotificationCenter.defaultCenter().postNotificationName(NOTIFY_POPALERT, object: PopAlertType.Copy.rawValue);
		}
	}

	func writeToPasteboard(text: String) {
		let pb = NSPasteboard.generalPasteboard()
		pb.clearContents();
		pb.declareTypes([NSStringPboardType], owner: self);
		pb.setString(text, forType: NSStringPboardType);

	}

	// begin bind tableview Data
	func numberOfRowsInTableView(tableView: NSTableView) -> Int {
		return workingLogData == nil ? 0 : workingLogData!.count ;
	}

	func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {

//		log("tableview", tableColumn?.identifier);
		return "test";
	}

	func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let columnId = (tableColumn?.identifier)!;

		guard let o = workingLogData else {
			return nil;
		}

		let working = o[row];
		if (columnId == "tId") {
			let view = tableview.makeViewWithIdentifier(columnId, owner: self) as! NSTableCellView;
			view.textField?.objectValue = row + 1;
			return view;
		} else if (columnId == "tContent") {
			let view = tableview.makeViewWithIdentifier(columnId, owner: self) as! NSTableCellView;
			view.textField?.objectValue = working.content;

			return view;
		} else if (columnId == "tTime") {
			let view = tableview.makeViewWithIdentifier(columnId, owner: self) as! NSTableCellView;
			view.textField?.objectValue = working.createTime;
			return view;
		} else if (columnId == "tLength") {
			let view = tableview.makeViewWithIdentifier(columnId, owner: self) as! NSTableCellView;
			view.textField?.objectValue = working.workTime;

			return view;
		} else if (columnId == "tType") {
			let view = tableview.makeViewWithIdentifier(columnId, owner: self) as! NSTableCellView;
			view.textField?.objectValue = working.workType;

			return view;
		} else if (columnId == "tOp") {
			let view = tableview.makeViewWithIdentifier(columnId, owner: self) as! DeleteCellView;
			view.data = working;
			return view;
		}

		return nil;
	}

	func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {

		if (colContentWidth == 0) {
			return tableView.rowHeight;
		}

		guard let o = workingLogData else {
			return tableView.rowHeight;
		}

		let working = o[row];
		let size = working.content.textSizeWithFont(NSFont.systemFontOfSize(13), constrainedToSize: CGSizeMake(colContentWidth, CGFloat(MAXFLOAT)))

		let height = size.height + 3;
		if (height < tableView.rowHeight) {
			return tableView.rowHeight;
		} else {
			return height;
		}
	}

	func tableViewColumnDidResize(notification: NSNotification) {

		colContentWidth = (tableview.tableColumnWithIdentifier(COL_CONTENT_INDEX)?.width)! - 8;
		tableview.noteHeightOfRowsWithIndexesChanged(NSIndexSet.init(indexesInRange: NSMakeRange(0, tableview.numberOfRows)))
	}

	/// 支持drag
	func tableView(tableView: NSTableView, writeRowsWithIndexes rowIndexes: NSIndexSet, toPasteboard pboard: NSPasteboard) -> Bool {
		pboard.clearContents();

		pboard.declareTypes([DRAG_PROJECTITEM], owner: self);
		self.selectWorking = [];
		rowIndexes.enumerateIndexesUsingBlock({ (a, b) -> Void in
			self.selectWorking.append(self.workingLogData[a].id);
		});

		return true;
	}

//	func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
//		let view = tableview.makeViewWithIdentifier("tRow", owner: self);
//		log("rowview");
//		return nil;
//	}

// end bind

// begin bind outlineview Data
	func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
		return projectData != nil ? projectData!.count : 0;
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

		if (row.id == -1) {
			let a = outlineView.makeViewWithIdentifier("HeaderCell", owner: item) as! NSTableCellView;
			a.textField?.objectValue = row.projectName;
			return a;
		}
		let a = outlineView.makeViewWithIdentifier("Item", owner: item) as! NSTableCellView;
		a.textField?.objectValue = row.projectName;
		return a;
	}
//
//	func outlineView(outlineView: NSOutlineView, shouldSelectItem item: AnyObject) -> Bool {
//		let row = item as! Project;
//		return row.id != -999;
//	}

	func outlineViewSelectionDidChange(notification: NSNotification) {
		let p = self.projectData[listview.selectedRow]
		self.selectPid = p.id;
		refreshWorkingLogData();
	}

	/// 可接收drag
	func outlineView(outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: AnyObject?, proposedChildIndex index: Int) -> NSDragOperation {

		guard let project = item as? Project else {
			return NSDragOperation.None;
		}

		return project.id != -1 ? NSDragOperation.Every : NSDragOperation.None;
	}

	func outlineView(outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: AnyObject?, childIndex index: Int) -> Bool {
		guard let project = item as? Project else {
			return false;
		}
		dbHelper.workinglog.moveWorkingLog(self.selectWorking, pid: project.id);
		refreshWorkingLogData();
		return true;
	}

// end bind

}

