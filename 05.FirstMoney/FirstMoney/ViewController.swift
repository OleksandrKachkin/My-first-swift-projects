//
//  ViewController.swift
//  FirstMoney
//
//  Created by Oleksandr Kachkin on 18.04.2022.
//

import UIKit
import RealmSwift


class ViewController: UIViewController {
  
  let realm = try! Realm()
  var itemArray: Results<Item>! // массив значений, кот хранятся в БД Realm
  
  //Outlets
  
  @IBOutlet weak var limitLabel: UILabel!
  @IBOutlet weak var availableForSpend: UILabel!
  @IBOutlet weak var spendingForPeriod: UILabel!
  @IBOutlet weak var allSpanding: UILabel!
  @IBOutlet weak var displayLabel: UILabel! 
  
  var stillTyping = false
  
  @IBOutlet var numberFromKeyboard: [UIButton]! {
    didSet { // наблюдатель свойств
      for button in numberFromKeyboard {
        button.layer.cornerRadius = 11
      }
    }
  }
  
  var categoryName = ""
  var displayValue: Int = 1
  
  @IBOutlet weak var tableView: UITableView!
  
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

    itemArray = realm.objects(Item.self)
    leftLabels()
    countAllSpending()
  }
  
  
  
  @IBAction func numberPressed(_ sender: UIButton) {
    let number = sender.currentTitle!
    
    if stillTyping {
      if displayLabel.text! == "0" {
        displayLabel.text = ""
      }
      if displayLabel.text!.count < 15 {
        displayLabel.text = displayLabel.text! + number
      }
    } else {
      displayLabel.text = number
      stillTyping = true
    }
  }
  
  @IBAction func resetButton(_ sender: UIButton) {
    reset()
  }
  
  @IBAction func categoryPressed(_ sender: UIButton) {
    let tag = sender.tag
    switch tag {
    case 1: categoryName = "Еда"
    case 2: categoryName = "Одежда"
    case 3: categoryName = "Связь"
    case 4: categoryName = "Досуг"
    case 5: categoryName = "Красота"
    case 6: categoryName = "Авто"
    default: break
    }
    
    displayValue = Int(displayLabel.text!)!
    reset()
    
    let value = Item(value: ["\(categoryName)", displayValue])
    try! realm.write {
      realm.add(value)
    }
    leftLabels()
    countAllSpending()
    tableView.reloadData()
  }
  
  func reset() {
    displayLabel.text = "0"
    stillTyping = false
  }
  
  // MARK: - Alert Controller
  @IBAction func limitPressed(_ sender: UIButton) {
    
    let alertController = UIAlertController(title: "Установить лимит", message: "Введите сумму и количество дней", preferredStyle: .alert)
    let alertInstall = UIAlertAction(title: "Установить", style: .default) { action in
      
      let tfsum = alertController.textFields?[0].text
      let tfday = alertController.textFields?[1].text
      
      //Если пользователь не внес инфу в поля TF
      guard tfday != "" && tfsum != "" else { return }
      
      self.limitLabel.text = tfsum
      
      if let day = tfday {
        let dayNow = Date()
        let lastDay: Date = dayNow.addingTimeInterval(60*60*24*Double(day)!)
        
        let limit = self.realm.objects(Limit.self)
        
        if limit.isEmpty {
          //Первая запись в БД
          let value = Limit(value: [self.limitLabel.text!, dayNow, lastDay])
          try! self.realm.write {
            self.realm.add(value)
          }
        } else {
          //Перезаписываем запись в БД
          try! self.realm.write {
            limit[0].limitSum = self.limitLabel.text!
            limit[0].limitDay = dayNow as NSDate
            limit[0].LimitLastDay = lastDay as NSDate
          }
        }
      }
      // при изменении тек лимита - пересчитает остаток
      self.leftLabels()
    }
    
    alertController.addTextField { (money) in
      money.placeholder = "Сумма"
      money.keyboardType = .asciiCapableNumberPad
    }
    
    alertController.addTextField { (day) in
      day.placeholder = "Количество дней"
      day.keyboardType = .asciiCapableNumberPad
    }
    
    let alertCancel = UIAlertAction(title: "Отмена", style: .default, handler: nil)
    
    alertController.addAction(alertInstall)
    alertController.addAction(alertCancel)
    
    present(alertController, animated: true)
  }
  
  // Подгружает данные в лейблы слева
  func leftLabels() {
    // свойство через которое обращаемся к БД Лимит
    let limit = self.realm.objects(Limit.self)
    
    // берем первое значение (ячейка с индексом 0)
    guard limit.isEmpty == false else { return }
    limitLabel.text = limit[0].limitSum
    
    // указываем какой календарь нужно использовать
    let calendar = Calendar.current // .current - календарь того часового пояса в кот юзер находится
    
    // при помощи DateFormatter выбираем только ГОД/МЕСЯЦ/ДЕНЬ часы:минуты
    let formatter = DateFormatter() // задаем формат даты
    formatter.dateFormat = "yyyy/MM/dd HH:mm"
    
    // берем из БД первое и последнюю запись (начало и конец), приводим к типу Date
    let firstDay = limit[0].limitDay as Date
    let lastDay = limit[0].LimitLastDay as Date
    
    // укажем формат даты. При помощи .dateComponents преобразуем нашу дату в формат год/месяц/день
    let firstComponents = calendar.dateComponents([.year, .month, .day], from: firstDay)
    let lastComponents = calendar.dateComponents([.year, .month, .day], from: lastDay)
    
    
    let startDay = formatter.date(from: "\(firstComponents.year!)/\(firstComponents.month!)/\(firstComponents.day!) 00:00") as Any
    let endDay = formatter.date(from: "\(lastComponents.year!)/\(lastComponents.month!)/\(lastComponents.day!) 23:59") as Any
    
    // выборка из БД Реалм по дате (предикат %@ - дата, кот будем сверять)
    let filteredLimit: Int = realm.objects(Item.self).filter("self.date >= %@ && self.date <= %@", startDay, endDay).sum(ofProperty: "cost") // сумма по полю "cost"
    
    // запишем значение суммы в поле "Траты за период"
    spendingForPeriod.text = "\(filteredLimit)"
    
    // запишем значение в поле "Доступно для трат"
    let a = Int(limitLabel.text!)!
    let b = Int(spendingForPeriod.text!)!
    let c = a - b
    availableForSpend.text = "\(c)"
    
    
  }
  
  func countAllSpending() {
    // все затраты
    let allSpend: Int = realm.objects(Item.self).sum(ofProperty: "cost") // сумма по полю "cost"
    allSpanding.text = "\(allSpend)"
  }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return itemArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
    
    let item = itemArray.reversed()[indexPath.row] // .reversed - чтобы последние созданные расходы были сверху таблицы
//    let item = itemArray.sorted(byKeyPath: "date", ascending: false)[indexPath.row] // 2 вариант сортировки
    
    cell.recordCategory.text = item.category
    cell.recordCost.text = "\(item.cost)"
        
    switch item.category {
    case "Еда": cell.recordImage.image = UIImage(systemName: "fork.knife.circle")
    case "Одежда": cell.recordImage.image = UIImage(systemName: "tshirt")
    case "Связь": cell.recordImage.image = UIImage(systemName: "phone.connection")
    case "Досуг": cell.recordImage.image = UIImage(systemName: "gamecontroller")
    case "Красота": cell.recordImage.image = UIImage(systemName: "person.crop.rectangle")
    case "Авто": cell.recordImage.image = UIImage(systemName: "car")
    default: break
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  
  // Удаление строк таблицы на НОВЫЙ лад (c iOS 13.0)
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let editingRow = itemArray.reversed()[indexPath.row] // .reversed - чтобы удалить строку в верху таблицы
    // let editingRow = itemArray.sorted(byKeyPath: "date", ascending: false)[indexPath.row] // 2 вариант сортировки
    
    let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { (_, _, completionHandler) in
      try! self.realm.write {
        self.realm.delete(editingRow)
        self.leftLabels()
        self.countAllSpending()
        tableView.reloadData()
      }
      //completionHandler(true)
    }
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
  
}


