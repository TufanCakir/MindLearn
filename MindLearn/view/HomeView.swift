//
//  HomeView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

struct HomeView: View {

    @State private var showDrawer = false

    var body: some View {

        NavigationStack {

            ZStack {

                background
                mainContent
                overlayLayer
                drawerLayer
            }

            .navigationTitle("Lernen")

            .navigationBarTitleDisplayMode(.inline)

            .toolbar {

                ToolbarItem(
                    placement: .topBarLeading
                ) {

                    Button {

                        toggleDrawer()

                    } label: {

                        Image(
                            systemName:
                                showDrawer
                                ? "xmark"
                                : "line.3.horizontal"
                        )
                    }
                }
            }
        }
    }
}

extension HomeView {

    private var overlayLayer: some View {

        Group {

            if showDrawer {

                Color.black.opacity(0.35)

                    .ignoresSafeArea()

                    .transition(.opacity)

                    .onTapGesture {

                        closeDrawer()
                    }
            }
        }
        .animation(
            .easeInOut(duration: 0.2),
            value: showDrawer
        )
    }
}

extension HomeView {

    private var drawerLayer: some View {

        GeometryReader { geo in

            SideDrawerView(
                showDrawer: $showDrawer
            )

            .frame(
                width: min(
                    geo.size.width * 0.82,
                    360
                )
            )

            .offset(
                x: showDrawer ? 0 : -400
            )

            .transition(.move(edge: .leading))

            .gesture(

                DragGesture()

                    .onEnded { value in

                        if value.translation.width < -80 {

                            closeDrawer()
                        }
                    }
            )
        }
    }
}

extension HomeView {

    private func toggleDrawer() {

        withAnimation(
            .spring(
                response: 0.42,
                dampingFraction: 0.85
            )
        ) {

            showDrawer.toggle()
        }
    }

    private func closeDrawer() {

        withAnimation(
            .spring(
                response: 0.42,
                dampingFraction: 0.85
            )
        ) {

            showDrawer = false
        }
    }
}

// MARK: - Background

extension HomeView {

    private var background: some View {

        Color(.systemGroupedBackground)
            .ignoresSafeArea()
    }
}

// MARK: - Main Content

extension HomeView {

    private var mainContent: some View {

        LearningListView()

            .disabled(showDrawer)

            .scaleEffect(
                showDrawer ? 0.94 : 1,
                anchor: .leading
            )

            .offset(
                x: showDrawer ? 260 : 0
            )

            .blur(
                radius: showDrawer ? 4 : 0
            )

            .animation(
                .spring(
                    response: 0.42,
                    dampingFraction: 0.88
                ),
                value: showDrawer
            )
    }
}

#Preview {
    HomeView()
}
