//
//  EditProjectView.swift
//  SwiftUIPracticeApp
//
//  Created by yeonBlue on 2022/07/18.
//

import SwiftUI

struct EditProjectView: View {
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String
    @State private var detail: String
    @State private var color: String
    @State private var isShowingDeleteAlert = false
    
    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]
    
    let project: Project
    
    init(project: Project) {
        self.project = project
        
        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)
    }
    
    var body: some View {
        
        Form {
            Section(header: Text("Basic setting")) {
                TextField("Project name", text: $title.onChange(update))
                TextField("Description of this project", text: $detail.onChange(update))
            }
            
            Section(header: Text("Custom project color")) {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self) { item in
                        ZStack {
                            Color(item)
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(6)
                            if item == color {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                            }
                        }.onTapGesture {
                            color = item
                            update()
                        }
                    }
                }.padding(.vertical)
            }

            Section {
                Button(project.closed ? "Reopen this project"
                                      : "Close this project") {
                    project.closed.toggle()
                    update()
                }
            } footer: {
                Text("Closing a project moves it from the Open to Closed tab; deleting it removes the project completely.")
            }
            
            Button("Delete this project") {
                isShowingDeleteAlert.toggle()
            }.tint(.red)

            
        }
        .navigationTitle("Edit Project")
        .onDisappear(perform: dataController.save)
        .alert(Text("Are you sure you want to delete this project? You will also delete all the items it contains."), isPresented: $isShowingDeleteAlert) {
            Button("Delete", role: .destructive) {
                
            }
            
            Button("Cancel", role: .cancel) {
                
            }
        }
    }
    
    
    func update() {
        project.title = title
        project.detail = detail
        project.color = color
    }
    
    func delete() {
        dataController.delete(project)
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: .example)
            .environmentObject(DataController(inMemory: true))
    }
}
