//
//  CreateFile.swift
//  TanmayQA
//
//  Created by Tanmay Bakshi on 2016-05-13.
//  Copyright © 2016 Tanmay Bakshi. All rights reserved.
//

import Foundation

class CreateFile {
    
    var filename: String!
    var contents: String!
    
    init(filename: String, contents: String) {
        self.filename = filename
        self.contents = contents
    }
    
    func writeFile() {
        let currentDir = NSFileManager.defaultManager().currentDirectoryPath
        try! contents.writeToFile((currentDir as NSString).stringByAppendingPathComponent(filename), atomically: false, encoding: NSUTF8StringEncoding)
    }
    
}