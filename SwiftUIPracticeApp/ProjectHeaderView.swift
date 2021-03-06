//
//  ProjectHeaderView.swift
//  SwiftUIPracticeApp
//
//  Created by yeonBlue on 2022/06/29.
//

import SwiftUI

struct ProjectHeaderView: View {
    
    @ObservedObject var project: Project
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(project.projectTitle)
                ProgressView(value: project.completionAmount)
                    .tint(Color(project.projectColor))
                
            }
            
            Spacer()
            
            NavigationLink(destination: EditProjectView(project: project)) {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
            }
            
        }
        .padding(.bottom, 10)
    }
}

struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectHeaderView(project: .example)
    }
}
