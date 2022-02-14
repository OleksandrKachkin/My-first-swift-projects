//
//  Question.swift
//  11.Quizzler-Optionals
//
//  Created by Oleksandr Kachkin on 14.02.2022.
//

import Foundation

struct Question {
  let text: String
  let answers: [String]
  let correctAnswer: String
  
  init(q: String, a: [String], correctAnswer: String) {
    text = q
    answers = a
    self.correctAnswer = correctAnswer
  }
  
  
}
