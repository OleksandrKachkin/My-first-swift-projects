//
//  RecordViewController.swift
//  FindNumber
//
//  Created by Oleksandr Kachkin on 23.12.2021.
//

import UIKit

class RecordViewController: UIViewController {
  
  
  @IBOutlet weak var recordLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordGame)
    if record != 0 {
      recordLabel.text = "Ваш рекорд - \(record) сек."
    } else {
      recordLabel.text = "Рекорд не установлен"
    }
  }
  
  @IBAction func closeVC(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  
}
