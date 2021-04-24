//
//  ViewController.swift
//  Rock Trivia App
//
//  Created by Kyle Sherrington on 2021-04-22.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Variables and Properties
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var model = QuestionsModel()
    var questions = [Question]()
    var numCorrect = 0
    var currentQuestionIndex = 0
    
    var detailDialog:DetailViewController?
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailDialog = storyboard?.instantiateViewController(identifier: "ResultVC") as? DetailViewController
        
        // set modal presentation style
        detailDialog?.modalPresentationStyle = .overCurrentContext
        
        // delegate of DetailViewController
        detailDialog?.delegate = self
        
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

// MARK: - TableView Delegate Methods

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
        
        // try and cast tag 1 (question label) as a UILabel
        let label = cell.viewWithTag(1) as? UILabel
        
        // check it's not nil
        if label != nil {
            
            // get reference to current question
            let question = questions[currentQuestionIndex]
            
            // check there are answers, and that we aren't outside the bounds
            if question.answers != nil && indexPath.row < question.answers!.count {
                
                label!.text = question.answers![indexPath.row]
                
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
            
            // update titleText
            titleText = "Correct!"
            
            // increment numCorrect
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
            
            DispatchQueue.main.async {
                
                self.present(self.detailDialog!, animated: true, completion: nil)
                
            }
        }
        
    }
    
    // MARK: - QuestionsProtocol
    
    func questionsRetrieved(_ questions: [Question]) {
        
        self.questions = questions
        
        // check if we should restore the state from user defaults before displaying first question
        let savedIndex = StateManager.retrieveData(key: StateManager.questionIndexKey) as? Int
        
        // if there is saved data, check it's not nil and that it's within the array bounds
        if savedIndex != nil && savedIndex! < self.questions.count {
            
            currentQuestionIndex = savedIndex!
            
            // retrieve the number correct from user defaults
            let savedNumCorrect = StateManager.retrieveData(key: StateManager.numCorrectKey) as? Int
            
            if savedNumCorrect != nil {
                
                numCorrect = savedNumCorrect!
                
            }
        }
     
        // display the first question
        displayQuestion()
        
    }
    
}

// MARK: - Detail View Controller Protocol Methods

extension ViewController: DetailViewControllerProtocol {
    
    func dialogDismissed() {
        
        // increment currentQuestionIndex
        currentQuestionIndex += 1
        
        if currentQuestionIndex == questions.count {
            
            if detailDialog != nil {
             
                // user has just answered the last question, show summary dialog
                detailDialog!.titleText = "Summary"
                detailDialog!.feedbackText = "You got \(numCorrect) out of \(questions.count) questions correct."
                detailDialog!.buttonText = "Restart"
                
                // present summary popup
                present(detailDialog!, animated: true, completion: nil)
                
                // clear state
                StateManager.clearState()
                
            }
        }
        else if currentQuestionIndex > questions.count {
            
            // restart
            print("Summary - restart tapped")
            numCorrect = 0
            currentQuestionIndex = 0
            displayQuestion()
        }
        else if currentQuestionIndex < questions.count {
            
            // there are still more questions, display next question
            displayQuestion()
            
            // save state
            StateManager.saveState(numCorrect: numCorrect, questionIndex: currentQuestionIndex)
        }
    }
}
