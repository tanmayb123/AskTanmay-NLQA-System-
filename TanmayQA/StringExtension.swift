//
//  String.swift
//  TanmayQA
//
//  Created by Tanmay Bakshi on 2016-05-13.
//  Copyright © 2016 Tanmay Bakshi. All rights reserved.
//

import Foundation

extension String {
    
    var urlEncoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var nonIntCharactersStripped: String {
        var newVal = self
        for i in self.characters {
            guard let _ = Int("\(i)") else {
                newVal = newVal.replacingOccurrences(of: "\(i)", with: "")
                continue
            }
        }
        return newVal
    }
    
}
