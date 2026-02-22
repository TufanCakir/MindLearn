//
//  RootView.swift
//  Slayken Learn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

struct RootView: View {

    var body: some View {
        TabView {

            HomeView()
                .tabItem {
                    Label(
                        "Learn",
                        systemImage: "book"
                    )
                }

            NavigationStack {
                AccountView()
            }
            .tabItem {
                Label("Account", systemImage: "person.crop.circle")
            }
        }
    }
}
