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
    func execcmd(_ cmdname: String) -> NSString
    {
        var outstr = ""
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", cmdname]
        
        var nullFileHandle: FileHandle = FileHandle.nullDevice
        task.standardOutput = nullFileHandle
        task.standardError = nullFileHandle
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            outstr = output as String
        }
        
        task.waitUntilExit()
        let status = task.terminationStatus
        
        return outstr as NSString
    }
    
}
