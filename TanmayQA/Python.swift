//
//  Python.swift
//  TanmayQA
//
//  Created by Tanmay Bakshi on 2016-05-13.
//  Copyright © 2016 Tanmay Bakshi. All rights reserved.
//

import Foundation

class PythonBridge {
    
    var scriptName: String = ""
    
    init(scriptName: String) {
        self.scriptName = scriptName
    }
    
    func runScript(_ args: String) -> String {
        return RunShell().execcmd("\(PYTHONBRIDGE_COMMAND) \(scriptName).py \(args)") as String
    }
    
}
