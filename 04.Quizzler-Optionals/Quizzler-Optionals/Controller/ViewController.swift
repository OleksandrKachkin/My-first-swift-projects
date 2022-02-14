//
//  ViewController.swift
//  11.Quizzler-Optionals
//
//  Created by Oleksandr Kachkin on 14.02.2022.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var progressBar: UIProgressView!
  
  @IBOutlet weak var choice1Button: UIButton!
  @IBOutlet weak var choice2Button: UIButton!
  @IBOutlet weak var choice3Button: UIButton!
  
  @IBOutlet weak var scoreLabel: UILabel!
  
  
  var quizBrain = QuizBrain()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateUI()
  }
  
  @IBAction func answerButtonPressed(_ sender: UIButton) {
    
    let userAnswer = sender.currentTitle!
    
    let userGotItRight = quizBrain.checkAnswer(userAnswer: userAnswer)
    
    if userGotItRight {
      sender.backgroundColor = .green
    } else {
      sender.backgroundColor = .red
    }
    
    if quizBrain.questionNumber + 1 < quizBrain.quiz.count {
      quizBrain.questionNumber += 1
    } else {
      let alert = UIAlertController(title: "Ваш счет: \(quizBrain.score)", message: "Уже хорошо! Но вы можете еще лучше!", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
      present(alert, animated: true, completion: nil)
      
      quizBrain.questionNumber = 0
      quizBrain.score = 0
    }
    
    Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
  }
  
  @objc func updateUI() {
    questionLabel.text = quizBrain.getQuestionText()
    
    let answerChoices = quizBrain.getAnswers()
    choice1Button.setTitle(answerChoices[0], for: .normal)
    choice2Button.setTitle(answerChoices[1], for: .normal)
    choice3Button.setTitle(answerChoices[2], for: .normal)
    
    progressBar.progress = quizBrain.getProgress()
    scoreLabel.text = "Score: \(quizBrain.getScore())"
    
    choice1Button.backgroundColor = .clear
    choice2Button.backgroundColor = .clear
    choice3Button.backgroundColor = .clear
    
    
    
  }
  
}

