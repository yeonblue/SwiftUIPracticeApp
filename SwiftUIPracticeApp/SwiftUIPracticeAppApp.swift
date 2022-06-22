//
//  SwiftUIPracticeAppApp.swift
//  SwiftUIPracticeApp
//
//  Created by yeonBlue on 2022/06/06.
//

import SwiftUI

@main
struct SwiftUIPracticeAppApp: App {
    @StateObject var dataController: DataController
    
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
        
        // wrapped Value에 접근은 _
        // projected Value 접근은 $, combine Publisher로 되어 있음(state object 등)
        // 이니셜라이저가 아닌 직접 초기화로 생성하면 문제가 발생
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // SwiftUI가 Core Data를 쿼리할 때마다 데이터를 위치를 알아야 하므로 설정.
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
