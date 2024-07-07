//
//  ItemTable.swift
//  MeaningOut
//
//  Created by 강석호 on 7/7/24.
//

import RealmSwift
import Foundation

class ItemTable: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String = ""
    @Persisted var price: String = ""
    @Persisted var imageUrl: String = ""
    @Persisted var mallName: String = ""
    
    convenience init(title: String, price: String, imageUrl: String, mallName: String) {
        self.init()
        self.title = title
        self.price = price
        self.imageUrl = imageUrl
        self.mallName = mallName
    }
}
