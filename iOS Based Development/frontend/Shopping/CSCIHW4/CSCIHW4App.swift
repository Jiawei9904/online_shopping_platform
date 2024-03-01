//
//  CSCIHW4App.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/14/23.
//

import SwiftUI

@main
struct CSCIHW4App: App {
    @State private var showSearchForm = false

    var body: some Scene {
        WindowGroup {
            if showSearchForm {
                SearchFormView()
            } else {
                LaunchScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.showSearchForm = true
                        }
                    }
            }
        }
    }
}

