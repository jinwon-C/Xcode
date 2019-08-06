//
//  main.swift
//  command_line
//
//  Created by Jinwon on 06/08/2019.
//  Copyright © 2019 Jinwon. All rights reserved.
//

import Foundation

let format = DateFormatter()
format.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
let currentTime = NSDate()
let curTime = format.string(from: currentTime as Date)

print(curTime)
