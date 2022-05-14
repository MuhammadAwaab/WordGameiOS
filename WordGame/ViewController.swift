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
        self.viewModel.updateView = { [weak self] in
            DispatchQueue.main.async {
                self?.updateScore()
                self?.spanishLabel.text = self?.viewModel.getSpanishWordToDisplay()
                self?.englishLabel.text = self?.viewModel.getEnglishWordToDisplay()
            }
        }
        
        self.viewModel.showEndDialogue = { [weak self] in
            DispatchQueue.main.async {
                let endAlert = UIAlertController(title: "Result", message: "Correct attempts:\(self?.viewModel.getCorrectAnswersValue() ?? "") \n Wrong attempts:\(self?.viewModel.getWrongAnswersValues() ?? "")", preferredStyle: .alert)
                let restartAction = UIAlertAction(title: "Restart", style: .default) { _ in
                    self?.viewModel.restartGame()
                }
                let quitAction = UIAlertAction(title: "Quit Game", style: .destructive) { _ in
                    exit(0)
                }
                endAlert.addAction(restartAction)
                endAlert.addAction(quitAction)
                self?.present(endAlert, animated: true)
            }
        }
        
        self.viewModel.startGame()
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

