//
//  main.swift
//  TanmayQA
//
//  Created by Tanmay Bakshi on 2016-05-12.
//  Copyright © 2016 Tanmay Bakshi. All rights reserved.
//

import Foundation

system("clear")

print("+------------------------------------------+")
print("|                                          |")
print("|                Welcome To                |")
print("|               AskTanmay v2               |")
print("|                                          |")
print("|             - Tanmay Bakshi              |")
print("|                                          |")
print("+------------------------------------------+")

TQACore(userQuery: Process.arguments[1])
//print(SATD_CLASSIFIERS[ATDEngine(question: "In which city is Taj Mahal?").runATD()]!)
//print(SATDEngine(ATDResult: ATDEngine(question: "In which city is Taj Mahal?").runATD(), userQuery: "In which city is Taj Mahal?").runEngine())
