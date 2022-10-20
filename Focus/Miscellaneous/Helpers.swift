//
//  Helpers.swift
//  Pomodoro
//
//  Created by Alfie on 16/08/2022.
//

import Foundation

// Helpers for backgrounding the timer

func getTimeDifference(startDate: Date) -> (Int){
    return (Int)(Date.now.timeIntervalSince(startDate))
}

func removeSavedDate(){
    let defaults = UserDefaults(suiteName: "group.com.Alfie.Pomodoro")
    if (defaults!.object(forKey: "saveTime") as? Date) != nil{
        defaults!.removeObject(forKey: "saveTime")
    }
}
