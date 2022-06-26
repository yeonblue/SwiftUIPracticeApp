//
//  Item+CoreDataHelpers.swift
//  SwiftUIPracticeApp
//
//  Created by yeonBlue on 2022/06/26.
//

import Foundation

extension Item {
    var itemTitle: String {
        return title ?? ""
    }
    
    var itemDetail: String {
        return detail ?? ""
    }
    
    var itemCreationDate: Date {
        return createDate ?? Date()
    }
    
    static var example: Item {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let item = Item(context: viewContext)
        
        item.title = "Sample Item"
        item.detail = "This is a sample Item data"
        item.priority = 2
        item.createDate = Date()
        
        return item
    }
}
