//
//  RoutineManager.swift
//  Vana
//
//  Created by Jake Correnti on 3/18/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import Foundation

class RoutineManager {
    
    var habit = Habit()
    
    private var currentStreak       = 0
    private var completedDates      = [String]()
    private var sortedDates         = [String]()
    private var datesFullyCompleted = [String]()
    private var individualDates     = [String]()
    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        return df
    }
    
    // must be called before sorting function
    private func accessAllCompletedDates() {
        completedDates.removeAll()
        let routines = habit.updatedRoutine
        
        routines.forEach { routine in
            routine.daysCompleted.forEach { day in
                completedDates.append(day)
            }
        }
    }
    
    /// sorts all of the habit's combined routine actions' completed dates and sorts them in ascending order
    private func sort() {
        accessAllCompletedDates()
        sortedDates = completedDates.sorted { dateFormatter.date(from: $0)! < dateFormatter.date(from: $1)! }
    }
    
    func getSortedDates() -> [String] {
        return sortedDates
    }
    
    func getUnsortedDates() -> [String] {
        accessAllCompletedDates()
        return completedDates
    }
    
    private func getDifferentIndividualDates() {
        sort()
        if sortedDates.count > 0 {
            var currentDate = sortedDates[0]
            var individualDates = [sortedDates[0]]
            
            sortedDates.forEach { day in
                if day != currentDate {
                    currentDate = day
                    individualDates.append(day)
                }
            }
            self.individualDates = individualDates
        }
    }
    
    private func determineWhichDatesWereFullyCompleted() {
        var datesCompletedFully = [String]()
        
        getDifferentIndividualDates()
        individualDates.forEach { day in
            let actionsCount = habit.updatedRoutine.count
            var dayRepeatedCount = 0
            
            sortedDates.forEach { if $0 == day { dayRepeatedCount += 1 } }
            
            // if the date is repeated the same amount as the number of actions in the routine, it means that all of the actions were completed for that given day
            if dayRepeatedCount == actionsCount {
                datesCompletedFully.append(day)
            }
        }
        
        self.datesFullyCompleted = datesCompletedFully
    }
    
    // check if there is a gap between the most recently completed day, if there is, the current streak is 0
    // if there is no gap, the current streak calculated is valid and should be used
    
    /// returns the current habit streak that the user is on (excludes the current day)
    private func determineCurrentStreak() {
        sort()
        determineWhichDatesWereFullyCompleted()
        
        var currentStreak = 0
        var allConsecutiveStreaks = [Int]()
        var index = 0
        
        var daysCompleted = datesFullyCompleted
        // dont want to include the current day in comparison if there is a gap between the current day and the last fully completed action
        if daysCompleted.last! == dateFormatter.string(from: Date()) {
            daysCompleted.removeLast()
        }
        
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)
        
        if dateFormatter.string(from: yesterday!) != daysCompleted.last! {
            currentStreak = 0
        } else {
            while index + 1 < daysCompleted.count {
                let calendar = Calendar.current
                let currentDate = dateFormatter.date(from: daysCompleted[index])
                let nextDate = dateFormatter.date(from: daysCompleted[index + 1])
                let components = calendar.compare(currentDate!, to: nextDate!, toGranularity: .day)
                
                if abs(components.rawValue) > 1 {
                    allConsecutiveStreaks.append(currentStreak)
                    currentStreak = 0
                } else if abs(components.rawValue) == 1 {
                    currentStreak += 1
                }
                
                index += 1
            }
        }
        
        self.currentStreak = currentStreak
    }
    
    func getDatesFullyCompletd() -> [String] {
        determineWhichDatesWereFullyCompleted()
        return datesFullyCompleted
    }
    
    func getCurrentHabitCompletionStreak() -> Int {
        determineCurrentStreak()
        if currentStreak != 0 {
            // value will be one less than the actual streak, since the counter begins at 0
            return currentStreak + 1
        }
        return currentStreak
    }
    
    
}
