//
//  ViewController.swift
//  Rock Trivia App
//
//  Created by Kyle Sherrington on 2021-04-22.
//

import UIKit

class ViewController: UIViewController {

    var model = QuestionsModel()
    var question = [Question]()
    
    // keep track of correct answers to display at end of game, store in cache
    var correctAnswers = 0
    
    // keep track of which question the user is on, store in cache
    var currentQuestionIndex = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate of QuizModel
        model.delegate = self
        
        // retrieve questions on launch
        model.getQuestions()
        
    }


}

// MARK: - Methods


// MARK: - Quiz Protocol Methods
extension ViewController: QuizProtocol {
    
    func questionsRetrieved(_ questions: [Question]) {
        
        print("Questions retrieved")
        
    }
    
}
