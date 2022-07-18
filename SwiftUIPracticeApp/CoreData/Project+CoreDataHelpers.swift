//
//  Project+CoreDataHelpers.swift
//  SwiftUIPracticeApp
//
//  Created by yeonBlue on 2022/06/26.
//

import Foundation

// 기본적으로 CoreData 프로퍼티는 optional이므로 보다 편한 사용을 위함.
// Model은 CodeGen으로 xCode가 자동으로 class를 생성해 줌.
// 직접 아래와 같이 생성하는 것은 좋지 않음. ( 모델을 조정할때마다 수정이 필요 )
//extension Project {
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
//        return NSFetchRequest<Project>(entityName: "Project")
//    }
//
//    @NSManaged public var closed: Bool
//    @NSManaged public var color: String?
//    @NSManaged public var creationDate: Date?
//    @NSManaged public var detail: String?
//    @NSManaged public var title: String?
//    @NSManaged public var items: NSSet?
//}

extension Project {
    
    static let colors = ["Pink", "Purple", "Red", "Orange", "Gold",
                         "Green", "Teal", "Light Blue", "Dark Blue", "Midnight",
                         "Dark Gray", "Gray"]
    
    var projectTitle: String {
        return title ?? "New Project"
    }
    
    var projectDetail: String {
        return detail ?? ""
    }
    
    var projectColor: String {
        return color ?? "Light Blue"
    }
    
    var completionAmount: Double {
        let originalItems = items?.allObjects as? [Item] ?? []

        guard originalItems.isEmpty == false else { return 0 }
        let completedItems = originalItems.filter(\.completed) // NSObject를 상속했기 때문에 key-path 사용 가능
        return Double(completedItems.count) / Double(originalItems.count)
    }
    
    /// allObjects가 NSSet이기 때문에 [Any] type으로 리턴되므로 따로 allItem을 정의
    var allProjectItems: [Item] {
        let itemArray = items?.allObjects as? [Item] ?? []
        return itemArray.sorted { first, second in
            if first.completed == false {
                if second.completed == true {
                    return true
                }
            } else {
                if second.completed == false {
                    return false
                }
            }
            
            // completed 상태가 똑같으 경우 우선도 비교
            if first.priority > second.priority {
                return true
            } else if first.priority < second.priority {
                return false
            }
            
            // 우선도도 같고, completed 상태가 똑같은 경우 날짜로 비교
            return first.itemCreationDate < second.itemCreationDate
        }
    }
    
    static var example: Project {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let item = Project(context: viewContext)
        
        item.title = "Sample Project"
        item.detail = "This is a sample Project data"
        item.closed = true
        item.createDate = Date()
        
        return item
    }
}
