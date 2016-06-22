//
//  CAG.swift
//  TanmayQA
//
//  Created by Tanmay Bakshi on 2016-05-13.
//  Copyright © 2016 Tanmay Bakshi. All rights reserved.
//

import Foundation

class CAG {
    
    var rawmaterial: String!
    
    init(rawmaterial: String) {
        self.rawmaterial = rawmaterial
    }
    
    func runCAG() -> [(String, Int)] {
        var finalResult: [(String, Int)] = []
        CreateFile(filename: CAG_NGRAMMINING_SAVETO, contents: rawmaterial).writeFile()
        PythonBridge(scriptName: CAG_NGRAMMINING_SCRIPTNAME).runScript("\(CAG_NGRAMMINING_SAVETO) \(CAG_NGRAMMINING_LOADFROM)")
        for i in ReadFile(filename: CAG_NGRAMMINING_LOADFROM).readFile().componentsSeparatedByString("\n") where i != "" {
            let parts = i.componentsSeparatedByString("---***---TANMAY-QA-BARRIER---***---")
            finalResult.append((parts[0], Int(parts[1].nonIntCharactersStripped)!))
        }
        return finalResult
    }
    
}