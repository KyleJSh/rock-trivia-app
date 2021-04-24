//
//  QuestionsModel.swift
//  Rock Trivia App
//
//  Created by Kyle Sherrington on 2021-04-22.
//

import Foundation

protocol QuizProtocol {
    
    func questionsRetrieved(_ questions:[Question])
    
}

class QuestionsModel {
    
    var delegate:QuizProtocol?
    
    // retrieve questions
    func getQuestions() {
        
        // get path to local json file
        let path = Bundle.main.path(forResource: "questions", ofType: "json")
        
        guard path != nil else {
            // couldn't get path to local json file
            return
        }
        
        let url = URL(fileURLWithPath: path!)
        
        do {
            
            // try and get data from url
            let data = try Data(contentsOf: url)
            
            // create json decoder object
            let decoder = JSONDecoder()
            
            // try and parse json
            let array = try decoder.decode([Question].self, from: data)
            
            // run on main thread, as we're updating the UI
            DispatchQueue.main.async {
                
                // pass parsed json to viewcontroller
                self.delegate?.questionsRetrieved(array)
            }
        }
        catch {
            print("Couldn't parse JSON")
        }
    }
}
