//
//  Binding-onChange.swift
//  SwiftUIPracticeApp
//
//  Created by yeonBlue on 2022/06/27.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(get: { self.wrappedValue },
                set: { newValue, _ in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
