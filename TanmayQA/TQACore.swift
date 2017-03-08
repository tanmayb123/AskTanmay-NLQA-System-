//
//  TQACore.swift
//  TanmayQA
//
//  Created by Tanmay Bakshi on 2016-05-12.
//  Copyright © 2016 Tanmay Bakshi. All rights reserved.
//

import Foundation

class TQACore {
    
    var userQuery: String = ""
    
    var answers: [(String, Int)] = []
    
    var ATDRes = ""
    
    var SERSERes = ""
    
    init(userQuery: String) {
        print("You asked: \(userQuery)")
        self.userQuery = userQuery.lowercased()
        answers = []
        runATD()
        runSATD()
        runSERSE()
        runCAG()
        runCAFS_Ranking()
        var finalAnswers = [(String, Int)]()
        for i in 1...5 {
            if let _ = answers.first {
                finalAnswers.append(answers.removeFirst())
            }
        }
        var totalPoints = 0
        finalAnswers.map({ totalPoints += $0.1 })
        print("\n")
        print("Done! Final Answers:")
        for i in finalAnswers {
            print("\(i.0) with \(Int(round((Double(i.1) / Double(totalPoints)) * 100)))% Confidence")
        }
    }
    
    func runATD() {
        print("Running ATD...")
        ATDRes = ATDEngine(question: userQuery).runATD()
        print("Done!")
    }
    
    func runSATD() {
        print("Running SATD...")
        let satd = SATDEngine(ATDResult: ATDRes, userQuery: userQuery).runEngine()
        if satd != "" && satd != "Generic" {
            ATDRes = satd
        }
        print("Done!")
    }
    
    func runSERSE() {
        print("Running SERSE...")
        SERSERes = SERSEEngine(query: userQuery).runSERSE()
        print("Done!")
    }
    
    func runCAG() {
        print("Running CAG...")
        answers = CAG(rawmaterial: SERSERes).runCAG()
        print("Done!")
    }
    
    func runCAFS_Ranking() {
        print("Running CAFS & Ranking...")
        answers = Ranker().quicksort(CAFS(userQuery: userQuery, ATDResult: ATDRes, candidateAnswers: answers).runCAFS())
        print("Done!")
    }
    
}
