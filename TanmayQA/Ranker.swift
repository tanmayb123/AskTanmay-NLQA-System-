//
//  Ranker.swift
//  TanmayQA
//
//  Created by Tanmay Bakshi on 2016-05-21.
//  Copyright © 2016 Tanmay Bakshi. All rights reserved.
//

import Foundation

class Ranker {
    
    func quicksort(toSort: [String: Int]) -> [(String, Int)] {
        var finalValue = [(String, Int)]()
        for (k,v) in (Array(toSort).sort({$0.1 > $1.1})) {
            finalValue.append((k, v))
        }
        return finalValue
    }
    
}