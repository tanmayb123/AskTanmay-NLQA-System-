//
//  SATD.swift
//  TanmayQA
//
//  Created by Tanmay Bakshi on 2016-06-02.
//  Copyright © 2016 Tanmay Bakshi. All rights reserved.
//

import Foundation

class SATDEngine {
    
    var ATDResult: String!
    var userQuery: String!
    
    init(ATDResult: String, userQuery: String) {
        self.ATDResult = ATDResult
        self.userQuery = userQuery
    }
    
    func runEngine() -> String {
        if SATD_CLASSIFIERS.keys.contains(ATDResult) {
            return NLCHandler(classifierID: SATD_CLASSIFIERS[ATDResult]!, text: userQuery, username: SATD_CLASSIFIER_UN, password: SATD_CLASSIFIER_PW).runHandler()
        }
        return ""
    }
    
}