//
//  SERSE.swift
//  TanmayQA
//
//  Created by Tanmay Bakshi on 2016-05-13.
//  Copyright © 2016 Tanmay Bakshi. All rights reserved.
//

import Foundation

class SERSEEngine {
    
    var query: String!
    
    init(query: String) {
        self.query = query
    }
    
    func runSERSE() -> String {
        let baseURL = "https://www.googleapis.com/customsearch/v1?key=\(SERSE_GOOGLE_KEY)&cx=\(SERSE_GOOGLE_CX)&q=\(query.urlEncoded)&nfpr=1"
        var pagedURLs: [String] = []
        var finalResult = ""
        for i in 0...SERSE_RESULT_PAGES-1 {
            pagedURLs.append(baseURL + "&start=\((i * 10) + 1)")
        }
        for i in pagedURLs {
            let resData = NSData(contentsOfURL: NSURL(string: i)!)
            if let data = resData {
                let json = try! NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! [String: AnyObject]
                let items = json["items"] as! [[String: AnyObject]]
                for j in items {
                    finalResult = finalResult + " \(j["snippet"] as! String)"
                }
            }
        }
        return finalResult
    }
    
}
