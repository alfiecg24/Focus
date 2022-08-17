//
//  Helpers.swift
//  Pomodoro
//
//  Created by Alfie on 16/08/2022.
//

import Foundation

// Helpers for backgrounding the timer

func getTimeDifference(startDate: Date) -> (Int){
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: Date())
    return (components.second!)
}

func removeSavedDate(){
    if (UserDefaults.standard.object(forKey: "saveTime") as? Date) != nil{
        UserDefaults.standard.removeObject(forKey: "saveTime")
    }
}
