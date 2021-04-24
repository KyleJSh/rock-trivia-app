//
//  DetailViewController.swift
//  Rock Trivia App
//
//  Created by Kyle Sherrington on 2021-04-23.
//

import UIKit

protocol DetailViewControllerProtocol {
    
    func dialogDismissed()
    
}

class DetailViewController: UIViewController {

    // MARK: - Variables and Properties
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var dialogView: UIView!
    
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    var delegate:DetailViewControllerProtocol?
    var currentQuestionIndex = 0
    
    var titleText = ""
    var feedbackText = ""
    var buttonText = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // round corner of dialog view
        dialogView.layer.cornerRadius = 5

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let savedIndex = StateManager.retrieveData(key: StateManager.questionIndexKey) as? Int
        
        if savedIndex != nil && savedIndex! < 11 {
            
            currentQuestionIndex = savedIndex!
            
        }
        
        // after answering 10 questions, user has tapped restart from summary popup and is back at the beginning, restart currentQuestionIndex
        if currentQuestionIndex == 11 {
            currentQuestionIndex = 0
        }
        
        // set image
        artistImage.image = UIImage(named: String(currentQuestionIndex))
        currentQuestionIndex += 1
        
        titleLabel.text = titleText
        feedbackLabel.text = feedbackText
        dismissButton.setTitle(buttonText, for: .normal)
        
        dimView.alpha = 0
        titleLabel.alpha = 0
        feedbackLabel.alpha = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            
            self.dimView.alpha = 1
            self.titleLabel.alpha = 1
            self.feedbackLabel.alpha = 1
            
        }, completion: nil)
        
    }
    
    // MARK: - Methods
    
    @IBAction func dismissTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
        // dismiss the popup
        delegate?.dialogDismissed()
                
    }
}
