//
//  OpenEphyra.swift
//  TanmayQA
//
//  Created by Tanmay Bakshi on 2016-08-26.
//  Copyright © 2016 Tanmay Bakshi. All rights reserved.
//

import Foundation

class OpenEphyra {
    
    var question: String!
    
    init(question: String) {
        self.question = question
    }
    
    func runOE() -> [[String: Int]] {
        return try! NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: NSURL(string: "http://\(OPENEPHYRA_CONNECTION_HOST)/\(OPENEPHYRA_CONNECTION_ENDPOINT)?query=\(question.urlEncoded)")!)!, options: .MutableContainers) as! [[String: Int]]
    }
    
}