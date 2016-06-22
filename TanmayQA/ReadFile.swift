//
//  ReadFile.swift
//  TanmayQA
//
//  Created by Tanmay Bakshi on 2016-05-13.
//  Copyright © 2016 Tanmay Bakshi. All rights reserved.
//

import Foundation

class ReadFile {
    
    var filename: String!
    
    init(filename: String) {
        self.filename = filename
    }
    
    func readFile() -> String {
        let currentDir = NSFileManager.defaultManager().currentDirectoryPath
        do {
            let result = try String(contentsOfFile: (currentDir as NSString).stringByAppendingPathComponent(filename))
            RunShell().execcmd("rm \(filename)")
            return result
        } catch {
            return "NON-EXISTENT"
        }
    }
    
}