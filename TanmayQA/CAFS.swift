//
//  CAFS.swift
//  TanmayQA
//
//  Created by Tanmay Bakshi on 2016-05-15.
//  Copyright © 2016 Tanmay Bakshi. All rights reserved.
//

import Foundation

class CAFS {
    
    var userQuery: String = ""
    
    var ATDResult: String = ""
    
    var candidateAnswers: [(String, Int)] = []
    
    init(userQuery: String, ATDResult: String, candidateAnswers: [(String, Int)]) {
        self.userQuery = userQuery
        self.ATDResult = ATDResult
        self.candidateAnswers = candidateAnswers
    }
    
    func runCAFS() -> [String: Int] {
        candidateAnswers = runNERFNS()
        candidateAnswers = runDCM()
        candidateAnswers = runQAR()
        var finalValue: [String: Int] = [:]
        for i in candidateAnswers {
            finalValue[i.0] = i.1
        }
        return finalValue
    }
    
    func runNERFNS() -> [(String, Int)] {
        var arguments = "\(ATDResult)"
        var arguments2 = "\(ATDResult)"
        let zeroTo = ((candidateAnswers.count % 2 == 0 ? candidateAnswers.count : candidateAnswers.count - 1) / 2) - 1
        for i in candidateAnswers[0...zeroTo] {
            var alnum: NSMutableCharacterSet = NSMutableCharacterSet(charactersIn: " ")
            alnum.formUnion(with: CharacterSet.alphanumerics)
            let strippedReplacement: String = i.0.components(separatedBy: alnum.inverted).joined(separator: "")
            arguments += " \"\(strippedReplacement)\" \(i.1)"
        }
        for i in candidateAnswers[zeroTo + 1...candidateAnswers.count - 1] {
            var alnum: NSMutableCharacterSet = NSMutableCharacterSet(charactersIn: " ")
            alnum.formUnion(with: CharacterSet.alphanumerics)
            let strippedReplacement: String = i.0.components(separatedBy: alnum.inverted).joined(separator: "")
            arguments2 += " \"\(strippedReplacement)\" \(i.1)"
        }
        var finalValue = [(String, Int)]()
        let result = JavaBridge(classpath: CAFS_NERFNS_DEPENDENCY_JAR, className: CAFS_NERFNS_CLASSNAME).runJar(arguments)
        let resfinal = JavaBridge(classpath: CAFS_NERFNS_DEPENDENCY_JAR, className: CAFS_NERFNS_CLASSNAME).runJar(arguments2) + result
        var resultSplit = resfinal.components(separatedBy: "\n")
        resultSplit.removeLast()
        for (ind, val) in resultSplit.enumerated() where ind % 2 == 0 {
            finalValue.append((val, Int(resultSplit[ind+1])!))
        }
        return finalValue
    }
    
    func runDCM() -> [(String, Int)] {
        var finalValue = [(String, Int)]()
        for i in candidateAnswers {
            var push = true
            var updateInd = 0
            for (ind, val) in finalValue.enumerated() where val.0 == i.0 {
                push = false
                updateInd = ind
            }
            if push {
                finalValue.append(i)
            } else {
                finalValue[updateInd].1 += i.1
            }
        }
        return finalValue
    }
    
    func runQAR() -> [(String, Int)] {
        var finalValue = [(String, Int)]()
        for i in candidateAnswers {
            if !(userQuery.contains(i.0.lowercased())) {
                finalValue.append(i)
            }
        }
        return finalValue
    }
    
}
