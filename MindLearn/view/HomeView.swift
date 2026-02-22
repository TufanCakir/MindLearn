//
//  HomeView.swift
//  Slayken Learn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

struct HomeView: View {

    @State private var showDrawer = false

    var body: some View {

        NavigationStack {

            ZStack(alignment: .leading) {

                background

                mainContent

                if showDrawer {

                    dimOverlay
                }

                if showDrawer {

                    drawer
                }

                topBar
            }

            .toolbar(.hidden)
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

            .blur(radius: showDrawer ? 6 : 0)

            .scaleEffect(showDrawer ? 0.96 : 1)

            .animation(
                .spring(
                    response: 0.45,
                    dampingFraction: 0.85
                ),
                value: showDrawer
            )
    }
}

// MARK: - Overlay

extension HomeView {

    private var dimOverlay: some View {

        Color.black.opacity(0.35)

            .ignoresSafeArea()

            .transition(.opacity)

            .onTapGesture {

                closeDrawer()
            }
    }
}

// MARK: - Drawer

extension HomeView {

    private var drawer: some View {

        GeometryReader { geo in

           SideDrawerView(
               showDrawer: $showDrawer
           )

           .frame(
               width: min(
                   geo.size.width * 0.85,
                   360
               )
           )
        }
    }
}

// MARK: - Top Bar

extension HomeView {

    private var topBar: some View {

        VStack {

            HStack {

                Button {

                    toggleDrawer()
                        
                } label: {

                    Image(
                        systemName:
                            showDrawer
                            ? "xmark"
                            : "line.3.horizontal"
                    )

                    .font(.title2.weight(.semibold))

                    .padding()

                    .background(.ultraThinMaterial)

                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 14,
                            style: .continuous
                        )
                    )
                }
            }

            .padding()
            .padding(.top,30)
            .ignoresSafeArea(edges:.top)

            Spacer()
        }
    }
}

// MARK: - Actions

extension HomeView {

    private func toggleDrawer() {

        withAnimation(
            .spring(
                response: 0.45,
                dampingFraction: 0.8
            )
        ) {

            showDrawer.toggle()
        }
    }

    private func closeDrawer() {

        withAnimation(
            .spring(
                response: 0.45,
                dampingFraction: 0.8
            )
        ) {

            showDrawer = false
        }
    }
}

#Preview {
    HomeView()
}
