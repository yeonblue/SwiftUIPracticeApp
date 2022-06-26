//
//  HomeView.swift
//  SwiftUIPracticeApp
//
//  Created by yeonBlue on 2022/06/25.
//

import SwiftUI

struct HomeView: View {
    
    static let tag: String? = "Home" // TabView의 selectedView가 String?이므로 타입을 맞춰야 햠
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        NavigationStack {
            VStack {
                Button("Add Data") {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }
                .navigationTitle("Home")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(DataController())
    }
}
