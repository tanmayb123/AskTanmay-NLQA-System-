//
//  RunShell.swift
//  TanmayQA
//
//  Created by Tanmay Bakshi on 2016-05-14.
//  Copyright © 2016 Tanmay Bakshi. All rights reserved.
//

import Foundation

class RunShell {
    
    // From https://gist.github.com/lmedinas/7963ac1985dba4dc60b5
    func execcmd(cmdname: String) -> NSString
    {
        var outstr = ""
        let task = NSTask()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", cmdname]
        
        var nullFileHandle: NSFileHandle = NSFileHandle.fileHandleWithNullDevice()
        task.standardOutput = nullFileHandle
        task.standardError = nullFileHandle
        
        let pipe = NSPipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = NSString(data: data, encoding: NSUTF8StringEncoding) {
            outstr = output as String
        }
        
        task.waitUntilExit()
        let status = task.terminationStatus
        
        return outstr
    }
    
}