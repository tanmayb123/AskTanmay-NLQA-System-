//
//  NLCHandler.swift
//  TanmayQA
//
//  Created by Tanmay Bakshi on 2016-05-12.
//  Copyright © 2016 Tanmay Bakshi. All rights reserved.
//

import Foundation

class NLCHandler {
    
    var classifierID: String = ""
    var text: String = ""
    var username: String = ""
    var password: String = ""
    
    init(classifierID: String, text: String, username: String, password: String) {
        self.classifierID = classifierID
        self.text = text
        self.username = username
        self.password = password
    }
    
    func runHandler() -> String {
        let response = RunShell().execcmd("curl -G -u \"\(username)\":\"\(password)\" \"https://gateway.watsonplatform.net/natural-language-classifier/api/v1/classifiers/\(classifierID)/classify\" --data-urlencode \"text=\(text)\"").data(using: String.Encoding.utf8.rawValue)
        if let responseData = response {
            // !! Assume JSON ( FIX THIS ) !! \\
            let jsonResponse = try! JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as! [String: AnyObject]
            return jsonResponse["top_class"] as! String
        } else {
            print("Error while trying to run NLC Instance.")
            exit(0)
        }
        return ""
    }
    
}
