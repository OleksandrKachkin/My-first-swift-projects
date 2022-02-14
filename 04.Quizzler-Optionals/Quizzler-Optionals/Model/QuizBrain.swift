//
//  QuizBrain.swift
//  11.Quizzler-Optionals
//
//  Created by Oleksandr Kachkin on 14.02.2022.
//

import Foundation
import UIKit

struct QuizBrain {
  
  var questionNumber =  0
  var score = 0
 
  
  let quiz = [
    Question(q: "1. Для чего используется двойной вопросительный знак ??", a: ["Принудительное извлечение", "Предоставить дефолтное значение", "Сделать переменную опциональной"], correctAnswer: "Предоставить дефолтное значение"),
    Question(q: "2. Выберите опциональный Bool", a: ["Bool?", "true?", "Bool"], correctAnswer: "Bool?"),
    Question(q: "3. Можно ли использовать переменную с явным, не опциональным типом даных, до ее инициализации", a: ["Да", "Нет", "Только внутри Структур и Классов"], correctAnswer: "Нет"),
    Question(q: "4. Каким образом мы можем установить опциональную переменную в состояние отсутствия значения?", a: ["Присвоить nil", "Присвоить 0", ".removeValue"], correctAnswer: "Присвоить nil"),
    Question(q: "5. Каким образом можно проверить, содержит ли опционал значение?", a: ["Через Force unwrapping", "Внутри цикла for-in", "Сравнивая с nil через if"], correctAnswer: "Сравнивая с nil через if"),
    Question(q: "6. Если мы точно уверены, что опционал имеет значение, каким наиболее быстрым образом мы можем его получить?", a: ["Оператор ??", "Force unwrapping (!)", "Внутри цикла while"], correctAnswer: "Force unwrapping (!)"),
    Question(q: "7. Опциональными типами данных являются такие типы, экземпляры которых ... ", a: ["... могут не иметь никакого значения", "... значение будет равно 0", "Оба варианта верны"], correctAnswer: "... могут не иметь никакого значения"),
    Question(q: "8. Можно ли складывать между собой 2 типа данных Int? и Int", a: ["Да", "Нет", "При условии извлечения опционала из Int?"], correctAnswer: "При условии извлечения опционала из Int?"),
    Question(q: "9. Optional binding начинается ключевыми словами", a: ["if let.. ", "for ... in ", "while... "], correctAnswer: "if let.. "),
    Question(q: "10. Укажите корректное использование Nil coalescing operator (оператор объединения по nil)", a: ["a + (b ?? 12)", "a + b!", "if b != nil"], correctAnswer: "a + (b ?? 12)"),
    Question(q: "11. Что из этого списка будет являться неявно извлеченным опционалом?", a: ["String", "String!", "String?"], correctAnswer: "String!"),
    Question(q: "12. Что мы получим, когда попытаемся получить доступ к неявно извлеченному опционалу, когда он не содержит значение?", a: ["Runtime error", "Ошибку компиляции", "Ошибки не будет"], correctAnswer: "Runtime error")
  ]
  
  
  func getQuestionText() -> String {
    return quiz[questionNumber].text
  }
  
  func getAnswers() -> [String] {
    return quiz[questionNumber].answers
  }
  
  func getProgress() -> Float {
    return Float(questionNumber) / Float(quiz.count)
  }
  
  mutating func getScore() -> Int {
    return score
  }
  

  
  mutating func checkAnswer(userAnswer: String) -> Bool {
    if userAnswer == quiz[questionNumber].correctAnswer {
      score += 1
      return true
    } else {
      return false
    }
  }
}
