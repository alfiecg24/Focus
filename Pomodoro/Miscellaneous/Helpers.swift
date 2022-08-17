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
    if (UserDefaults.standard.object(forKey: "saveTime") as? Date) != nil{
        UserDefaults.standard.removeObject(forKey: "saveTime")
    }
}
