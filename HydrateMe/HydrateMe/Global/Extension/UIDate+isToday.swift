//
//  UIDate+isSameDay.swift
//  HydrateMe
//
//  Created by Woochan Park on 2021/10/10.
//

import Foundation

extension Date {
  
  func isToday() -> Bool {
    
    let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    let selfComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
    
    guard todayComponents.year == selfComponents.year else { return false }
    guard todayComponents.month == selfComponents.month else { return false }
    guard todayComponents.day == selfComponents.day else { return false }
    
    return true
  }
}
