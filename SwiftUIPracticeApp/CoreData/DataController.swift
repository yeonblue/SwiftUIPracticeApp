//
//  DataController.swift
//  SwiftUIPracticeApp
//
//  Created by yeonBlue on 2022/06/22.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    
    /// Core Data를 사용하여 로컬 데이터를 로드하고 관리하는 일을 담당, 또한 iCloud와 동기화하여 모든 사용자의 기기와 앱이 동일한 데이터를 공유할 수 있게 함.
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")
        
        // 데이터가 디스크가 아닌 메모리에 생성. 앱이 종료되면 데이터가 사라짐. SwiftUI 프리뷰용
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        // 데이터가 있으면 그것으로 생성
        container.loadPersistentStores { storeDesciption, error in
            if let error = error {
                fatalError("Fatal Error: \(error.localizedDescription)")
            }
        }
    }
    
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal Error: \(error.localizedDescription)")
        }
        
        return dataController
    }()
    
    /// 프리뷰에 core data 표시 샘플 데이터 생성 함수
    func createSampleData() throws {
        
        // Core Data가 어디에 저장될지 지정, NSPersistentCloudKitContainer(name: "Main")
        let viewContext = container.viewContext
        
        for i in 1...5 {
            let project = Project(context: viewContext)
            project.title = "Project \(i)"
            project.createDate = Date()
            project.closed = Bool.random()
            project.items = []
            
            for j in 1...10 {
                let item = Item(context: viewContext)
                item.title = "Item \(j)"
                item.createDate = Date()
                item.completed = Bool.random()
                item.priority = Int16.random(in: 1...3)
                item.project = project // Project와 Item은 1:다 관계(dataModel RelationShip 참고)
            }
        }
        
        try viewContext.save()
        
        // 1. viewContext는 디스크에서 로드된 데이터 풀이기 때문에 Core Data에서 정말 중요한 개념.
        // 2. viewContext의 인스턴스를 생성할 때 인스턴스 Project가 Item 내부에 있는 viewContext를 전달해야 한다. 이를 통해 Core Data는 생성된 위치를 추적할 수 있으므로 나중에 저장할 위치를 알 수 있다.
        // 3. try viewContext.save()를 하며 모든 새 개체를 영구 저장소에 쓰도록 지시하는 viewContext를 호출한다. 이는 메모리에 있을 수 있고, 영구적인 저장소일 수도 있다. 지금의 경우 앱을 삭제하지 않는 한 지속 유지.
    }
    
    func save() {
        if container.viewContext.hasChanges { // 바뀐 내용이 있으면 저장
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
    func deleteAll() {
        
        // Core Data 모든 Item을 fetch 후 삭제
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)
        
        // Core Data 모든 Project를 fetch 후 삭제
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }
}
