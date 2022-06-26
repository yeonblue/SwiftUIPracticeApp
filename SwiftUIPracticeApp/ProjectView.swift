//
//  ProjectView.swift
//  SwiftUIPracticeApp
//
//  Created by yeonBlue on 2022/06/25.
//

import SwiftUI

struct ProjectView: View {
    
    let showClosedProjects: Bool
    let projects: FetchRequest<Project> // @FetchRequest 프로퍼티 래퍼로 사용도 가능
    
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        
        projects = FetchRequest<Project>(
            entity: Project.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Project.createDate, ascending: false)],
            predicate: NSPredicate(format: "closed = %d", showClosedProjects)
        )
    }
    
    var body: some View {
        NavigationView {
            List {
                // wrappedValue는 results of the fetch request.
                ForEach(projects.wrappedValue) { project in
                    Section(header: Text(project.title ?? "")) {
                        ForEach(project.items?.allObjects as? [Item] ?? []) { item in
                            Text(item.title ?? "")
                        }
                    }
                    
                }
                .listStyle(.insetGrouped)
                .navigationTitle(showClosedProjects ? "Closed Projects"
                                                    : "Open Projects")
            }
        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    
    static var dataController = DataController.preview
    
    static var previews: some View {
        ProjectView(showClosedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}

//
// 1. FetchRequest를 Property Wrapper가 아니라 구조체를 직접 사용하기 때문에 wrappedValue로 직접 읽어야 함.
// 2. CoreData는 데이터를 NSSet으로 보관. 따라서 allObjects를 직접 type casting 필요