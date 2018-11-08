//
//  WindowController.swift
//  MyWorkingLog
//
//  Created by linjson on 16/7/15.
//  Copyright © 2016年 linjson. All rights reserved.
//

import Foundation
import Cocoa
class WindowController: NSWindowController {
    
    @IBOutlet weak var ppSelectYear: NSPopUpButton!
    var workinglogDetailWindow: NSWindowController!;
    var projectManagerWindow: NSWindowController!;
    var dataBaseWindow: NSWindowController!;
    override func windowDidLoad() {
        self.window?.titleVisibility = .hidden;
        
        initSelectYearData();
        
        workinglogDetailWindow = self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("WorkinglogDetailWindow")) as? NSWindowController;
        
        projectManagerWindow = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("ProjectManagerWindow")) as? NSWindowController;
        
        dataBaseWindow = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("DataBaseWindow")) as? NSWindowController;
        
        registerNotifiction();
    }
    
    override func close() {
        unregisterNotifiction();
    }
    
    func initSelectYearData(){
        let startYear=2015;
        let endYear=Calendar.current.component(Calendar.Component.year, from: Date.init());
        let count=endYear-startYear;
        ppSelectYear.addItem(withTitle: SelectYearDefault);
        for i in 0...count{
            ppSelectYear.addItem(withTitle: String(endYear-i));
        }
        
        
    }
    
    func unregisterNotifiction() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFY_EDITWORKINGLOG), object: nil);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFY_POPALERT), object: nil);
    }
    
    func registerNotifiction() {
        NotificationCenter.default.addObserver(self, selector: #selector(openWorkinglogDetail(_:)), name: NSNotification.Name(rawValue: NOTIFY_EDITWORKINGLOG), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(showPopAlert(_:)), name: NSNotification.Name(rawValue: NOTIFY_POPALERT), object: nil);
    }
    
    @objc func showPopAlert(_ notify: Notification) {
        guard let type = notify.object else {
            return ;
        }
        
        let a = type as! Int;
        
        PopAlert.create(self.window, with: PopAlertType(rawValue: a)!);
    }
    
    @objc func openWorkinglogDetail(_ notify: Notification) {
        
        guard let working = notify.object as? WorkingLog else {
            return ;
        }
        
        let controller = workinglogDetailWindow.contentViewController as! WorkinglogDetailController;
        controller.working = working;
        
        self.window?.beginSheet(workinglogDetailWindow.window!, completionHandler: { (NSModalResponse) in
            
        })
        
    }
    
    @IBAction func doAddWorkingLog(_ sender: AnyObject) {
        
        self.window?.beginSheet(workinglogDetailWindow.window!, completionHandler: { (NSModalResponse) in
            
        })
    }
    @IBAction func doOpenDataBaseWindow(_ sender: AnyObject) {
        self.window?.beginSheet(dataBaseWindow.window!, completionHandler: { (NSModalResponse) in
            
        })
        
    }
    
    @IBAction func doProjectManager(_ sender: AnyObject) {
        self.window?.beginSheet(projectManagerWindow.window!, completionHandler: { (NSModalResponse) in
            
        })
    }
    
    @IBAction func searchContent(_ sender: Any) {
        let field=sender as! NSSearchField;
        NotificationCenter.default.post(name:Notification.Name(rawValue: NOTIFY_DATACHANGE_WORKINGLOG), object: SearchData(searchWord: field.stringValue));
        
    }
    @IBAction func doSelectYear(_ sender: Any) {
        let year=ppSelectYear.selectedItem?.title ?? SelectYearDefault;
        NotificationCenter.default.post(name:Notification.Name(rawValue: NOTIFY_DATACHANGE_WORKINGLOG), object: SearchData(selectYear: year));
    }
    var i = 0;
    @IBAction func test(_ sender: AnyObject) {
        i += 1;
        PopAlert.create(self.window, with: i % 2 == 0 ? PopAlertType.error : PopAlertType.info);
        
    }
    
    func test2() -> Any{
        return (name:"b",age:20)
    }
    
    
}
