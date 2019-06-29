//
//  Time.swift
//  Synesthesia
//
//  Created by Zsombor Rajki on 2019. 04. 21..
//  Copyright © 2019. Razeware. All rights reserved.
//

import Foundation


enum TimeConstant {
    static let secsPerMin = 60
    static let secsPerHour = TimeConstant.secsPerMin * 60
}

class Time {
    func convertToString(time: Float) -> String {
        var secs = Int(ceil(time))
        var hours = 0
        var mins = 0
        
        if secs > TimeConstant.secsPerHour {
            hours = secs / TimeConstant.secsPerHour
            secs -= hours * TimeConstant.secsPerHour
        }
        
        if secs > TimeConstant.secsPerMin {
            mins = secs / TimeConstant.secsPerMin
            secs -= mins * TimeConstant.secsPerMin
        }
        
        var formattedString = ""
        if hours > 0 {
            formattedString = "\(String(format: "%02d", hours)):"
        }
        formattedString += "\(String(format: "%02d", mins)):\(String(format: "%02d", secs))"
        return formattedString
    }
}
