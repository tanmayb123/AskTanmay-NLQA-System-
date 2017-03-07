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
    
    var NERFNSResults: [(String, Int)] = []
    
    var group = AsyncGroup()
    
    init(userQuery: String, ATDResult: String, candidateAnswers: [(String, Int)]) {
        self.userQuery = userQuery
        self.ATDResult = ATDResult
        self.candidateAnswers = candidateAnswers
    }
    
    func runCAFS(completion: @escaping (([String: Int]) -> Void)) {
        runNERFNS(completionHandler: { (a) in
            self.candidateAnswers = a
            self.candidateAnswers = self.runDCM()
            self.candidateAnswers = self.runQAR()
            var finalValue: [String: Int] = [:]
            for i in self.candidateAnswers {
                finalValue[i.0] = i.1
            }
            completion(finalValue)
        })
    }
    
    func runNERFNS(completionHandler: @escaping (([(String, Int)]) -> Void)) {
        let ORGS = ["Organization", "Company", "Facility"]
        let PERS = ["Person"]
        let LOCS = ["City", "Continent", "Country", "GeographicFeature", "StateOrCounty"]
        for i in candidateAnswers {
            group.background {
                var alnum: NSMutableCharacterSet = NSMutableCharacterSet(charactersIn: " ")
                alnum.formUnion(with: CharacterSet.alphanumerics)
                let strippedReplacement: String = i.0.components(separatedBy: alnum.inverted).joined(separator: "")
                let cURL_cmd = "curl -X POST -d \"outputMode=json\" -d \"url=http://tanmaybakshi.com/echo.php?toEcho=\(strippedReplacement)\" \"https://gateway-a.watsonplatform.net/calls/url/URLGetRankedNamedEntities?apikey=\(CAFS_NERFNS_ALCHEMYAPIKEY)\""
                let result = (try! JSONSerialization.jsonObject(with: RunShell().execcmd(cURL_cmd).data(using: String.Encoding.utf8.rawValue)!, options: .mutableContainers) as! [String: AnyObject])["entities"] as! [[String: AnyObject]]
                var parsedResult = ""
                var parsedScore = 0
                for k in result {
                    if self.ATDResult == "ORGANIZATION" && ORGS.contains(k["type"] as! String) {
                        parsedResult = k["text"] as! String
                        parsedScore = i.1
                    } else if self.ATDResult == "PERSON" && PERS.contains(k["type"] as! String) {
                        parsedResult = k["text"] as! String
                        parsedScore = i.1
                    } else if self.ATDResult == "GPE" && LOCS.contains(k["type"] as! String) {
                        parsedResult = k["text"] as! String
                        parsedScore = i.1
                    } else {
                        if self.ATDResult == (k["type"] as! String) {
                            parsedResult = k["text"] as! String
                            parsedScore = i.1
                        }
                    }
                    break
                }
                if parsedResult != "" {
                    if self.ATDResult == "PERSON" {
                        if parsedResult.contains(" ") {
                            parsedScore *= 10
                        }
                        if parsedResult.lowercased() != parsedResult {
                            parsedScore *= 5
                        }
                    }
                    self.NERFNSResults.append((parsedResult, parsedScore))
                }
            }
        }
        group.wait()
        completionHandler(self.NERFNSResults)
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
