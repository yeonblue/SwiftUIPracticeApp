//
//  ContentView.swift
//  SwiftUIPracticeApp
//
//  Created by yeonBlue on 2022/06/06.
//

import SwiftUI

struct ContentView: View {
    /// iPad용 지원을 위해 SceneStorage가 적합. @AppStorage는 앱 전체가 공유(UserDefaults)
    /// Scene마다 고유의 Storage에 저장. 앱이 종료되면 사라지는 것이 @AppStorage와 차이점.
    @SceneStorage("selectedView") var selectedView: String?
    
    var body: some View {
        TabView(selection: $selectedView) {
            HomeView()
                .tag(HomeView.tag)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            ProjectView(showClosedProjects: false)
                .tag(ProjectView.openTag)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Open")
                }
            
            ProjectView(showClosedProjects: true)
                .tag(ProjectView.closeTag)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Closed")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
