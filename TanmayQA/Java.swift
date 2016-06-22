//
//  Java.swift
//  TanmayQA
//
//  Created by Tanmay Bakshi on 2016-05-19.
//  Copyright © 2016 Tanmay Bakshi. All rights reserved.
//

import Foundation

class JavaBridge {
    
    var className: String!
    
    var classPath: String? = nil
    
    init(className: String) {
        self.className = className
    }
    
    convenience init(classpath cpArg: String, className cnArg: String) {
        self.init(className: cnArg)
        self.classPath = "-cp \(cpArg):."
    }
    
    func runJar(arguments: String) -> String {
        return RunShell().execcmd("\(JAVABRIDGE_COMMAND)\(classPath == nil ? "" : " \(classPath!)") \(className)\(arguments == "" ? "" : " \(arguments)")") as String
    }
    
}