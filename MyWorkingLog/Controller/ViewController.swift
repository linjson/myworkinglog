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
    var search:String?;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectPid = Int64(-1);
        
        resetData();
        // 自动调整大小只有优先列
        tableview.columnAutoresizingStyle = .sequentialColumnAutoresizingStyle;
        // tableview数据绑定
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.doubleAction = #selector(doTableViewRowDoubleClick);
        tableview.allowsMultipleSelection = true;
        // listview数据绑定
        listview.delegate = self;
        listview.dataSource = self;
        
        listview.registerForDraggedTypes([NSPasteboard.PasteboardType(rawValue: DRAG_PROJECTITEM)]);
        
        registerNotifiction();
    }
    
    override func viewWillDisappear() {
        unRegisterNotifiction();
    }
    
    //	override var representedObject: AnyObject? {
    //		didSet {
    //			// Update the view, if already loaded.
    //		}
    //	}
    
    func registerNotifiction() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshWorkingLogData(_:)), name: NSNotification.Name(rawValue: NOTIFY_DATACHANGE_WORKINGLOG), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(refreshProjectData), name: NSNotification.Name(rawValue: NOTIFY_DATACHANGE_PROJECT), object: nil);
        
    }
    
    func unRegisterNotifiction() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFY_DATACHANGE_WORKINGLOG), object: nil);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFY_DATACHANGE_PROJECT), object: nil);
    }
    
    @objc func refreshProjectData() {
        projectData = dbHelper.project.findAll();
        listview.reloadData();
    }
    
    @objc func refreshWorkingLogData(_ notify:Notification?=nil) {
        
        if(notify != nil && notify?.object != nil){
            search=notify?.object as? String;
        }
        
        workingLogData=dbHelper.workinglog.find(id:self.selectPid,content: search);
        
        tableview.reloadData();
        
    }
    
    
    func resetData() {
        
        workingLogData = dbHelper.workinglog.find();
        projectData = dbHelper.project.findAll();
    }
    
    @objc func doTableViewRowDoubleClick() {
        let row = tableview.selectedRow;
        
        if (row > -1) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_EDITWORKINGLOG), object: workingLogData[row]);
        }
        
    }
    
    override func keyDown(with theEvent: NSEvent) {
        
        if (tableview.selectedRow == -1) {
            return;
        }
        
        // copy
        if ((NSEvent.modifierFlags == NSEvent.ModifierFlags.command) && (theEvent.keyCode == 8)) {
            let c = copySelectContent();
            self.writeToPasteboard(c) ;
            NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_POPALERT), object: PopAlertType.copy.rawValue);
        }
    }
    
    func copySelectContent() -> String {
        var list: [String] = [];
        (self.tableview.selectedRowIndexes as NSIndexSet).enumerate({ (a, b) -> Void in
            let c = self.workingLogData[a].content;
            list.append(c);
        })
        return list.joined(separator: "\n");
    }
    
    func writeToPasteboard(_ text: String) {
        
        
        
        let pb = NSPasteboard.general
        pb.clearContents();
        
        pb.declareTypes([NSPasteboard.PasteboardType.string], owner: self);
        pb.setString(text, forType: NSPasteboard.PasteboardType.string);
        
    }
    
    // begin bind tableview Data
    func numberOfRows(in tableView: NSTableView) -> Int {
        return workingLogData == nil ? 0 : workingLogData!.count ;
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        //		log("tableview", tableColumn?.identifier);
        return "test";
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let columnId = (tableColumn?.identifier)!;
        
        guard let o = workingLogData else {
            return nil;
        }
        
        let working = o[row];
        if (columnId.rawValue == "tId") {
            let view = tableview.makeView(withIdentifier: columnId, owner: self) as! NSTableCellView;
            view.textField?.objectValue = row + 1;
            return view;
        } else if (columnId.rawValue == "tContent") {
            let view = tableview.makeView(withIdentifier: columnId, owner: self) as! NSTableCellView;
            view.textField?.objectValue = working.content;
            
            return view;
        } else if (columnId.rawValue == "tTime") {
            let view = tableview.makeView(withIdentifier: columnId, owner: self) as! NSTableCellView;
            view.textField?.objectValue = working.createTime;
            return view;
        } else if (columnId.rawValue == "tLength") {
            let view = tableview.makeView(withIdentifier: columnId, owner: self) as! NSTableCellView;
            view.textField?.objectValue = working.workTime;
            
            return view;
        } else if (columnId.rawValue == "tType") {
            let view = tableview.makeView(withIdentifier: columnId, owner: self) as! NSTableCellView;
            view.textField?.objectValue = working.workType;
            
            return view;
        } else if (columnId.rawValue == "tOp") {
            let view = tableview.makeView(withIdentifier: columnId, owner: self) as! DeleteCellView;
            view.data = working;
            return view;
        }
        
        return nil;
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        
        if (colContentWidth == 0) {
            return tableView.rowHeight;
        }
        
        guard let o = workingLogData else {
            return tableView.rowHeight;
        }
        
        let working = o[row];
        let size = working.content.textSizeWithFont(NSFont.systemFont(ofSize: 13), constrainedToSize: CGSize(width: colContentWidth, height: CGFloat(MAXFLOAT)))
        
        let height = size.height + 3;
        if (height < tableView.rowHeight) {
            return tableView.rowHeight;
        } else {
            return height;
        }
    }
    
    func tableViewColumnDidResize(_ notification: Notification) {
        
        colContentWidth = (tableview.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: COL_CONTENT_INDEX))?.width)! - 8;
        tableview.noteHeightOfRows(withIndexesChanged: IndexSet.init(integersIn: Range.init(NSMakeRange(0, tableview.numberOfRows))!))
    }
    
    /// 支持drag
    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
        pboard.clearContents();
        
        pboard.declareTypes([NSPasteboard.PasteboardType(rawValue: DRAG_PROJECTITEM)], owner: self);
        self.selectWorking = [];
        (rowIndexes as NSIndexSet).enumerate({ (a, b) -> Void in
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
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return projectData != nil ? projectData!.count : 0;
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
        
        if (row.id == -1) {
            let a = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderCell"), owner: item) as! NSTableCellView;
            a.textField?.objectValue = row.projectName;
            return a;
        }
        let a = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "Item"), owner: item) as! NSTableCellView;
        a.textField?.objectValue = row.projectName;
        return a;
    }
    //
    //	func outlineView(outlineView: NSOutlineView, shouldSelectItem item: AnyObject) -> Bool {
    //		let row = item as! Project;
    //		return row.id != -999;
    //	}
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        let p = self.projectData[listview.selectedRow]
        self.selectPid = p.id;
        refreshWorkingLogData();
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFY_DATACHANGE_CHANGEPROJECTSELECT), object: NSNumber.init(value: p.id as Int64));
        
    }
    
    /// 可接收drag
    func outlineView(_ outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: Any?, proposedChildIndex index: Int) -> NSDragOperation {
        
        guard let project = item as? Project else {
            return NSDragOperation();
        }
        
        return project.id != -1 ? NSDragOperation.every : NSDragOperation();
    }
    
    func outlineView(_ outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: Any?, childIndex index: Int) -> Bool {
        guard let project = item as? Project else {
            return false;
        }
        _=dbHelper.workinglog.moveWorkingLog(self.selectWorking, pid: project.id);
        refreshWorkingLogData();
        return true;
    }
    
    // end bind
    
}

