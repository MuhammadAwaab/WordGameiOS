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
    @IBOutlet weak var spanishLabelTop: NSLayoutConstraint!
    
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
                self?.resetSpanishLabel()
                self?.updateScore()
                UIView.animate(withDuration: TimeInterval(self?.viewModel.getTimeForAttempt() ?? 5)) {
                    self?.spanishLabelTop.constant = self?.view.bounds.height ?? 500
                    self?.view.layoutIfNeeded()
                }
                self?.spanishLabel.text = self?.viewModel.getSpanishWordToDisplay()
                self?.englishLabel.text = self?.viewModel.getEnglishWordToDisplay()
            }
        }
        
        self.viewModel.showEndDialogue = { [weak self] in
            DispatchQueue.main.async {
                self?.resetSpanishLabel()
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
    
    private func resetSpanishLabel() {
        self.spanishLabel.text = ""
        self.englishLabel.text = ""
        self.spanishLabelTop.constant = -20
        self.view.layoutIfNeeded()

    }
    
    @IBAction func correctButtonTapped(_ sender: Any) {
        resetSpanishLabel()
        viewModel.userSelectedCorrect()
    }
    
    @IBAction func wrongButtonTapped(_ sender: Any) {
        resetSpanishLabel()
        viewModel.userSelectedWrong()
    }
    
    
}

