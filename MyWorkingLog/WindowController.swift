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
    
    var workinglogDetailWindow: NSWindowController!;
    var projectManagerWindow: NSWindowController!;
    var dataBaseWindow: NSWindowController!;
    override func windowDidLoad() {
        self.window?.titleVisibility = .hidden;
        workinglogDetailWindow = self.storyboard!.instantiateController(withIdentifier: "WorkinglogDetailWindow") as! NSWindowController;
        
        projectManagerWindow = self.storyboard?.instantiateController(withIdentifier: "ProjectManagerWindow") as! NSWindowController;
        
        dataBaseWindow = self.storyboard?.instantiateController(withIdentifier: "DataBaseWindow") as! NSWindowController;
        
        registerNotifiction();
    }
    
    override func close() {
        unregisterNotifiction();
    }
    
    func unregisterNotifiction() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFY_EDITWORKINGLOG), object: nil);
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFY_POPALERT), object: nil);
    }
    
    func registerNotifiction() {
        NotificationCenter.default.addObserver(self, selector: #selector(openWorkinglogDetail(_:)), name: NSNotification.Name(rawValue: NOTIFY_EDITWORKINGLOG), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(showPopAlert(_:)), name: NSNotification.Name(rawValue: NOTIFY_POPALERT), object: nil);
    }
    
    func showPopAlert(_ notify: Notification) {
        guard let type = notify.object else {
            return ;
        }
        
        let a = type as! Int;
        
        PopAlert.create(self.window, with: PopAlertType(rawValue: a)!);
    }
    
    func openWorkinglogDetail(_ notify: Notification) {
        
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
        
        NotificationCenter.default.post(name:Notification.Name(rawValue: NOTIFY_DATACHANGE_WORKINGLOG), object: field.stringValue);
        
    }
    var i = 0;
    @IBAction func test(_ sender: AnyObject) {
        i += 1;
        PopAlert.create(self.window, with: i % 2 == 0 ? PopAlertType.error : PopAlertType.info);
        
    }
}
