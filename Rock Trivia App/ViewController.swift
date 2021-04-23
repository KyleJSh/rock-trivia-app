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
    var numCorrect = 0
    
    var detailDialog:DetailViewController?
    
    // keep track of which question the user is on, store in cache
    var currentQuestionIndex = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailDialog = storyboard?.instantiateViewController(identifier: "ResultVC") as? DetailViewController
        
        // set modal presentation style
        detailDialog?.modalPresentationStyle = .overCurrentContext
        
        // delegate of QuizModel
        model.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        // retrieve questions on launch
        model.getQuestions()
        
    }

    // MARK: - Methods
    
    func displayQuestion() {
        
        // check there ARE questions, and that we aren't outside the bounds
        guard questions.count > 0 && currentQuestionIndex < questions.count else {
            return
        }
        
        // display the question text
        questionLabel.text = questions[currentQuestionIndex].question
        
        // reload tableview
        tableView.reloadData()
    }
}

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
            
            // get reference to current question
            let question = questions[currentQuestionIndex]
            
            // check there are answers, and that we aren't outside the bounds
            if question.answers != nil && indexPath.row < question.answers!.count {
                
                label?.text = question.answers![indexPath.row]
                
            }
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var titleText = ""
        
        // get reference to current question
        let question = questions[currentQuestionIndex]
        
        if question.correctAnswerIndex! == indexPath.row {
            
            // user got the right answer!
            print("User answered right")
            titleText = "Correct!"
            numCorrect += 1
        }
        else {
            
            // user got the wrong answer
            print("User answered wrong")
            titleText = "Wrong!"
            
        }
        
        if detailDialog != nil {
            
            // customize dialog text
            detailDialog!.titleText = titleText
            detailDialog!.feedbackText = question.feedback!
            detailDialog!.buttonText = "Next"
            
            present(detailDialog!, animated: true, completion: nil)
            
        }
        
        // increment currentQuestionIndex
        currentQuestionIndex += 1
        
        // display the next question
        displayQuestion()
        
    }
    
    // MARK: - QuestionsProtocol
    
    func questionsRetrieved(_ questions: [Question]) {
        
        self.questions = questions
        
        // display the first question
        displayQuestion()
        
    }
    
}
