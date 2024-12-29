///
//  @filename   Item.swift
//  @package   
//  
//  @author     jeffy
//  @date       2024/1/8 
//  @abstract   
//
//  Copyright (c) 2024 and Confidential to jeffy All rights reserved.
//

import Foundation
import SwiftData

@Model
public final class Objective {
    
    @Attribute(.unique) var timestamp: Date
    
    var name: String
    
    var motivations: [String] = []
    
    var feasibilities: [String] = []
    
    var keyResults: [KeyResult] = []
    
    var progress: Double {
        var points = keyResults.reduce(0, { $0 + $1.points })
        var wholePoints = keyResults.reduce(0, { $0 + $1.wholePoints })
        return Double(points) / Double(wholePoints)
    }
    
    var records: [Record] {
        return keyResults.flatMap { $0.records }.sorted(by: { $0.timestamp > $1.timestamp })
    }
    
    var tasks: [Task] {
        return keyResults.flatMap { $0.tasks }.sorted(by: { $0.schedule?.start ?? Date() > $1.schedule?.start ?? Date() })
    }
    
    init(timestamp: Date, name: String) {
        self.timestamp = timestamp
        self.name = name
    }
}

@Model class KeyResult {
        
    var name: String = ""
    
    var points: Int = 0
    
    var wholePoints: Int = 0
    
    var records: [Record] = []
    
    var tasks: [Task] = []
    
    init(name: String) {
        self.name = name
    }
}

@Model class Record {
    
    var timestamp: Date
    
    var points: Int
    
    var memo: String = ""
    
    init(timestamp: Date, points: Int) {
        self.timestamp = timestamp
        self.points = points
    }
}

@Model class Task {
    
    var name: String
        
    var memo: String = ""
    
    var isDone: Bool = false
    
    var schedule: Schedule?
    
    init(name: String, timestamp: Date) {
        self.name = name
    }
}

@Model class Schedule {
    
    var start: Date
    
    var end: Date

    var allDay: Bool = false
    
    init(start: Date, end: Date, allDay: Bool) {
        self.start = start
        self.end = end
        self.allDay = allDay
    }
}
