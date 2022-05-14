//
//  ViewController.swift
//  WordGame
//
//  Created by XiSYS Creatives on 14/05/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var correctAttemptsLabel: UILabel!
    @IBOutlet weak var wrongAttemptsLabel: UILabel!
    @IBOutlet weak var spanishLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    
    lazy var viewModel = {
        GameViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindWithViewModel()
    }
    
    func bindWithViewModel() {
        self.viewModel.updateView = {(english, spanish) in
            self.updateScore()
            self.spanishLabel.text = spanish
            self.englishLabel.text = english
        }
    }
    
    func updateScore()  {
        correctAttemptsLabel.text = "Correct attempts:" + viewModel.getCorrectAnswersValue()
        wrongAttemptsLabel.text = "Wrong attempts:" + viewModel.getWrongAnswersValues()
    }
    
    @IBAction func correctButtonTapped(_ sender: Any) {
        viewModel.userSelectedCorrect()
    }
    
    @IBAction func wrongButtonTapped(_ sender: Any) {
        viewModel.userSelectedWrong()
    }
    
    
}

