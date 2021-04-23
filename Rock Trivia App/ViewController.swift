//
//  ViewController.swift
//  Rock Trivia App
//
//  Created by Kyle Sherrington on 2021-04-22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var questionLabel: UILabel!
    
    var model = QuestionsModel()
    var questions = [Question]()
    
    // keep track of correct answers to display at end of game, store in cache
    var correctAnswers = 0
    
    // keep track of which question the user is on, store in cache
    var currentQuestionIndex = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate of QuizModel
        model.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        // retrieve questions on launch
        model.getQuestions()
        
    }


}

// MARK: - Methods


// MARK: - Quiz Protocol Methods
extension ViewController: QuizProtocol, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // check array contains at least 1 question
        guard questions.count > 0 else {
            return 0
        }
        
        // return number of answer for current question
        let currentQuestion = questions[currentQuestionIndex]
        
        if currentQuestion.answers != nil {
            
          return currentQuestion.answers!.count
            
        }
        else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        // TODO: configure cell
        
        // try and cast tag 1 (question label) as a UILabel
        let label = cell.viewWithTag(1) as? UILabel
        
        // check it's not nil
        if label != nil {
            
       // TODO: set answer to label
            
        }
        
        return cell
        
    }
    
    
    func questionsRetrieved(_ questions: [Question]) {
        
        print("Questions retrieved")
        
    }
    
}
