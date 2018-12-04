//
//  WorkingLog.swift
//  MyWorkingLog
//
//  Created by linjson on 16/6/17.
//  Copyright © 2016年 linjson. All rights reserved.
//

import Foundation
import SQLite
open class WorkingLogTable {
    let table: Table;
    let id: Expression<Int64>;
    let pid: Expression<Int64>;
    let content: Expression<String>;
    let createTime: Expression<String>;
    let workTime: Expression<Double>;
    let workType: Expression<String>;
    let db: Connection;
    init(db: Connection) {
        self.db = db;
        table = Table("workinglog");
        id = Expression<Int64>("id");
        pid = Expression<Int64>("pid");
        createTime = Expression<String>("createTime");
        content = Expression<String>("content");
        workTime = Expression<Double>("workTime");
        workType = Expression<String>("workType");
        
        self.createTableSql();
    }
    
    func createTableSql() {
        let sql = self.table.create(ifNotExists: true) {
            t in
            t.column(self.id, primaryKey: true);
            t.column(self.pid);
            t.column(self.content);
            t.column(self.createTime);
            t.column(self.workTime);
            t.column(self.workType);
        };
        do {
            try db.run(sql);
        } catch {
            log("workinglog table create error");
        }
    }
    
    func addWorkingLog(_ pid: Int64, content: String, createTime: String, workTime: Double, workType: String) -> Int64 {
        do {
            return try db.run(table.insert(self.pid <- pid, self.content <- content, self.createTime <- createTime, self.workTime <- workTime, self.workType <- workType));
        } catch let e {
            log(e);
        }
        return Int64(ERROR);
    }
    
    func addWorkingLog(modal working: WorkingLog) -> Int64 {
        return addWorkingLog(working.pid, content: working.content, createTime: working.createTime, workTime: working.workTime, workType: working.workType);
    }
    
    func deteleById(_ id: [Int64]) -> Int {
        do {
            return try db.run(table.filter(id.contains(self.id)).delete());
        } catch let e {
            log(e);
        }
        return ERROR;
    }
    
    func deleteByPid(_ pid: Int64) -> Int {
        do {
            return try db.run(table.filter(self.pid == pid).delete());
        } catch let e {
            log(e);
        }
        
        return ERROR;
    }
    
    func updateWorkingLog(_ id: Int64, pid: Int64, content: String, workTime: Double, workType: String, createTime: String) -> Int {
        do {
            return try db.run(table.filter(self.id == id).update(self.content <- content, self.workTime <- workTime, self.workType <- workType, self.pid <- pid, self.createTime <- createTime));
        } catch {
            log(error);
        }
        return ERROR;
    }
    
    func updateWorkingLog(modal working: WorkingLog) -> Int {
        return updateWorkingLog(working.id, pid: working.pid, content: working.content, workTime: working.workTime, workType: working.workType, createTime: working.createTime);
    }
    
    func moveWorkingLog(_ id: [Int64], pid: Int64) -> Int {
        do {
            return try db.run(table.filter(id.contains(self.id)).update(self.pid <- pid));
        } catch {
            log(error);
        }
        return ERROR;
    }
    
    func deleteAll() -> Int {
        do {
            return try db.run(table.delete());
        } catch {
            log(error);
        }
        return ERROR;
    }
    
    private func convertWorkingLogList(_ table:Table)->[WorkingLog]{
        var list: [WorkingLog] = [];
        do {
            try db.prepare(table.order(self.createTime.desc)).forEach { r in
                let w = WorkingLog();
                w.id = r[id];
                w.content = r[content];
                w.pid = r[pid];
                w.createTime = r[createTime].subString(10);
                w.workTime = r[workTime];
                w.workType = r[workType];
                list.append(w);
            };
        }catch let e{
            log(e);
        }
        
        return list;
        
    }
    
    func find() -> [WorkingLog] {
        return find(pid:-999);
    }
    
    func find(pid proid: Int64) -> [WorkingLog] {
        
        
        var table = self.table;
        if (proid != -1) {
            table = table.filter(self.pid == proid)
        }
        
        return convertWorkingLogList(table);
    }
    
    
    
    
    func find(id proid:Int64?,selectYear year:String) -> [WorkingLog] {
        
        var table = self.table;
        
        if(proid != nil){
            let a=proid!;
            if(a>=0){
                table=table.filter(self.pid==a);
            }
        }
        if(!(year == SelectYearDefault)){
            table = table.filter(self.createTime.like("\(year)%"));
        }
        return convertWorkingLogList(table);
    }
    
    func find(id proid:Int64?,content c:String?)->[WorkingLog]{
        var table = self.table;
        
        if(proid != nil){
            let a=proid!;
            if(a>=0){
                table=table.filter(self.pid==a);
            }
        }
        
        
        if((c) != nil) {
            let cc=c!;
            if( cc.count != 0){
                table = table.filter(self.content.like("%\(cc)%"));
            }
        }
        
        
        return convertWorkingLogList(table);
    }
}
