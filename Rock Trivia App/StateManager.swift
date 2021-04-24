//
//  StateManager.swift
//  Rock Trivia App
//
//  Created by Kyle Sherrington on 2021-04-24.
//

import Foundation

class StateManager {
    
    static var numCorrectKey = "NumberCorrectKey"
    static var questionIndexKey = "QuestionIndexKey"
    
    static func saveState(numCorrect:Int, questionIndex:Int) {
        
        // get reference to user defaults
        let defaults = UserDefaults.standard
        
        // save the state data
        defaults.set(numCorrect, forKey: numCorrectKey)
        defaults.set(questionIndex, forKey: questionIndexKey)
        
    }
    
    // retrieve state data
    static func retrieveData(key:String) -> Any? {
        
        // get reference to user defaults
        let defaults = UserDefaults.standard
        
        return defaults.value(forKey: key)
        
    }
    
    static func clearState() {
        
        // get reference to user defaults
        let defaults = UserDefaults.standard
        
        // clear state data
        defaults.removeObject(forKey: numCorrectKey)
        defaults.removeObject(forKey: questionIndexKey)
        
    }
    
}
