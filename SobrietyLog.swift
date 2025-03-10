//
//  SobrietyLog.swift
//  Sobreity Shield
//
//  Created by Emaan Grey on 2025-03-04.
//


import Foundation

struct SobrietyLog: Codable {
    var startDate: Date
    var relapses: [Date]
    
    init(startDate: Date = Date(), relapses: [Date] = []) {
        self.startDate = startDate
        self.relapses = relapses
    }
    
    func currentStreakDays() -> Int {
        let mostRecentRelapse = relapses.sorted().last ?? startDate
        return Calendar.current.dateComponents([.day], from: mostRecentRelapse, to: Date()).day ?? 0
    }
    
    func totalDaysSinceStart() -> Int {
        return Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
    }
    
    func longestStreak() -> Int {
        var sortedDates = relapses.sorted()
        sortedDates.insert(startDate, at: 0)
        
        if sortedDates.count == 1 {
            return currentStreakDays()
        }
        
        var maxStreak = 0
        
        for i in 0..<(sortedDates.count - 1) {
            let daysBetween = Calendar.current.dateComponents([.day], from: sortedDates[i], to: sortedDates[i+1]).day ?? 0
            maxStreak = max(maxStreak, daysBetween)
        }
        
        // Compare with current streak
        maxStreak = max(maxStreak, currentStreakDays())
        
        return maxStreak
    }
}
