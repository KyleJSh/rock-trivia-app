//
//  DetailViewController.swift
//  Rock Trivia App
//
//  Created by Kyle Sherrington on 2021-04-23.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Variables and Properties
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var dialogView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    var question:Question?
    
    var titleText = ""
    var feedbackText = ""
    var buttonText = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set title label text
        titleLabel.text = titleText
        feedbackLabel.text = feedbackText
        dismissButton.setTitle(buttonText, for: .normal)

    }
    

    // MARK: - Methods
    
    @IBAction func dismissTapped(_ sender: Any) {
        
        // dismiss the popup
        
    }
    
    
}
