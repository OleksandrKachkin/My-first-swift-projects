//
//  ViewController.swift
//  Calculator_v3
//
//  Created by Oleksandr Kachkin on 16.12.2021.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var resultLabel: UILabel!
  
  var stillTyping = false
  var dotIsPlaced = false
  var firstOperand: Double = 0
  var secondOperand: Double = 0
  var operationSign: Int = 0
  
  var currentInput: Double {
    get {
      return Double(resultLabel.text!)!
    }
    set {
      let value = "\(newValue)"
      let valueArray = value.components(separatedBy: ".")
      if valueArray[1] == "0" {
        resultLabel.text = "\(valueArray[0])"
      } else {
        resultLabel.text = "\(newValue)"
      }
      stillTyping = false
    }
  }
  
  // Сделать СтатусБар белым цветом, чтобы его было видно на черном фоне
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  @IBAction func numberPressed(_ sender: UIButton) {
    
    let number = String(sender.tag)
    
    if stillTyping {
      if resultLabel.text!.count < 20 {
        resultLabel.text = resultLabel.text! + number
      }
    } else {
      resultLabel.text = number
      stillTyping = true
    }
  }
  
  @IBAction func operationPressed(_ sender: UIButton) {
    operationSign = sender.tag
    firstOperand = currentInput
    stillTyping = false
    dotIsPlaced = false
  }
  
  func operateTwoOperands(operation: (Double, Double) -> Double) {
    currentInput = operation(firstOperand, secondOperand)
    stillTyping = false
  }
  
  @IBAction func equalSignPressed(_ sender: UIButton) {
    
    if stillTyping {
      secondOperand = currentInput
    }
    
    dotIsPlaced = false
    
    switch operationSign {
    case 11: operateTwoOperands {$0 / $1}
    case 12: operateTwoOperands {$0 * $1}
    case 13: operateTwoOperands {$0 - $1}
    case 14: operateTwoOperands {$0 + $1}
    default: break
    }
  }
  
  @IBAction func clearButtonPressed(_ sender: UIButton) {
    firstOperand = 0
    secondOperand = 0
    currentInput = 0
    resultLabel.text = "0"
    stillTyping = false
    dotIsPlaced = false
    operationSign = 0
  }
  
  @IBAction func plusMinusButtonPressed(_ sender: UIButton) {
    currentInput = -currentInput
  }
  
  @IBAction func percentageButtonPressed(_ sender: UIButton) {
    if firstOperand == 0 {
      currentInput = currentInput / 100
    } else {
      secondOperand = firstOperand * currentInput / 100
    }
    stillTyping = false
  }
  
  @IBAction func dotButtonPressed(_ sender: UIButton) {
    if stillTyping && !dotIsPlaced {
      resultLabel.text = resultLabel.text! + "."
      dotIsPlaced = true
    } else if !stillTyping && !dotIsPlaced {
      resultLabel.text = "0."
    }
  }
}

