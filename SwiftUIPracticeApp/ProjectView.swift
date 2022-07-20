//
//  ProjectView.swift
//  SwiftUIPracticeApp
//
//  Created by yeonBlue on 2022/06/25.
//

import SwiftUI

struct ProjectView: View {
    
    static let openTag: String? = "Open" // 같은 뷰를 open, close에서 사용하고 있으므로 태그로 분류
    static let closeTag: String? = "Close"
    
    let showClosedProjects: Bool
    let projects: FetchRequest<Project> // @FetchRequest 프로퍼티 래퍼로 사용도 가능
    //@FetchRequest var projects: FetchedResults<Project>
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    init(showClosedProjects: Bool) {
        self.showClosedProjects = showClosedProjects
        
        // property wrapper로 선언했으면 _projects로 초기화
        
        projects = FetchRequest<Project>(
            entity: Project.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Project.createDate, ascending: false)],
            predicate: NSPredicate(format: "closed = %d", showClosedProjects)
        )
    }
    
    var body: some View {
        NavigationStack {
            List {
                // wrappedValue는 results of the fetch request.
                ForEach(projects.wrappedValue) { project in
                    Section(header: ProjectHeaderView(project: project)) {
                        ForEach(project.allProjectItems, content: ItemRowView.init)
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle(showClosedProjects ? "Closed Projects"
                                                : "Open Projects")
            .toolbar {
                if showClosedProjects == false {
                    Button {
                        withAnimation {
                            let project = Project(context: managedObjectContext)
                            project.closed = false
                            project.createDate = Date()
                            dataController.save()
                        }
                    } label: {
                        Label("Add Project", systemImage: "plus")
                    }

                }
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
