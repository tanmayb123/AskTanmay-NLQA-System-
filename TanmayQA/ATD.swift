//
//  ATD.swift
//  TanmayQA
//
//  Created by Tanmay Bakshi on 2016-05-12.
//  Copyright © 2016 Tanmay Bakshi. All rights reserved.
//

import Foundation

class ATDEngine {
    
    var question: String!
    
    init(question: String) {
        self.question = question
    }
    
    func runATD() -> String {
        return NLCHandler(classifierID: ATD_CLASSIFIER_ID, text: question, username: ATD_CLASSIFIER_UN, password: ATD_CLASSIFIER_PW).runHandler().uppercaseString
    }
    
}