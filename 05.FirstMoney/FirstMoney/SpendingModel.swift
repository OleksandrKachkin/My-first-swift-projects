//
//  SpendingModel.swift
//  FirstMoney
//
//  Created by Oleksandr Kachkin on 20.04.2022.
//

import RealmSwift
import Foundation

class Item: Object {
  
  @objc dynamic var category = ""
  @objc dynamic var cost = 1
  @objc dynamic var date = NSDate()
  
}


class Limit: Object {
  @objc dynamic var limitSum = ""
  @objc dynamic var limitDay = NSDate()
  @objc dynamic var LimitLastDay = NSDate()
}
