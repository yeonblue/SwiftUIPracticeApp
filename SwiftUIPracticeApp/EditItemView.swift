//
//  EditItemView.swift
//  SwiftUIPracticeApp
//
//  Created by yeonBlue on 2022/06/26.
//

import SwiftUI

struct EditItemView: View {
    
    @EnvironmentObject var dataController: DataController
    let item: Item
    
    @State private var title: String
    @State private var detail: String
    @State private var priority: Int
    @State private var completed: Bool
    
    init(item: Item) {
        self.item = item
        
        _title = State(wrappedValue: item.itemTitle)
        _detail = State(wrappedValue: item.itemDetail)
        _priority = State(wrappedValue: Int(item.priority))
        _completed = State(wrappedValue: item.completed)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Basic settings")) {
                TextField("Item name", text: $title.onChange(update))
                TextField("Description", text: $detail.onChange(update))
            }
            
            Section(header: Text("Priority")) {
                Picker("Priority", selection: $priority.onChange(update)) {
                    Text("Low").tag(1)
                    Text("Medium").tag(2)
                    Text("High").tag(3)
                }.pickerStyle(.segmented)
            }
            
            Section {
                Toggle("Mark Completed", isOn: $completed.onChange(update))
            }
        }
        .navigationTitle("Edit Item")
        .onDisappear(perform: dataController.save)
    }
    
    func update() {
        item.title = title
        item.detail = detail
        item.priority = Int16(priority)
        item.completed = completed

        // 여기서 매번 dataController.save()는 비효율. 따라서 Noti와 onDisappear 이용
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditItemView(item: Item.example)
            .environmentObject(DataController.preview)
    }
}
