//
//  SearchData.swift
//  MyWorkingLog
//
//  Created by linjson on 2018/11/8.
//  Copyright © 2018 linjson. All rights reserved.
//

import Foundation

class SearchData:NSObject{
    var searchWord:String="";
    var selectYear:String="";
    
    init(searchWord:String="",selectYear:String=""){
        self.selectYear=selectYear;
        self.searchWord=searchWord;
    }
}
