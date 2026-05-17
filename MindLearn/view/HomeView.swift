//
//  HomeView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

struct HomeView: View {
    @State private var showDrawer = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AppStorage("reduceAppMotion")
    private var reduceAppMotion = false
    @AppStorage("language")
    private var language =
        Locale.current.language.languageCode?.identifier ?? "en"

    private var text: AppLocalization {
        Bundle.main.appLocalization(language: language)
    }

    private var shouldReduceMotion: Bool {
        reduceMotion || reduceAppMotion
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            mainContent

            overlayLayer

            drawerLayer
        }
        .navigationTitle(text.home.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: toggleDrawer) {
                    Image(
                        systemName: showDrawer ? "xmark" : "line.3.horizontal"
                    )
                }
                .accessibilityLabel(
                    showDrawer
                        ? text.accessibility.closeDrawer
                        : text.accessibility.openDrawer
                )
                .accessibilityHint(text.accessibility.closeDrawerHint)
            }
        }
    }

    private var overlayLayer: some View {
        Group {
            if showDrawer {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                    .transition(shouldReduceMotion ? .identity : .opacity)
                    .onTapGesture(perform: closeDrawer)
                    .accessibilityLabel(text.accessibility.closeDrawer)
                    .accessibilityHint(text.accessibility.closeDrawerHint)
            }
        }
        .animation(
            shouldReduceMotion ? nil : .easeOut(duration: 0.18),
            value: showDrawer
        )
    }

    private var drawerLayer: some View {
        GeometryReader { geo in
            SideDrawerView(showDrawer: $showDrawer)
                .frame(width: min(geo.size.width * 0.82, 360))
                .offset(x: showDrawer ? 0 : -400)
                .transition(
                    shouldReduceMotion ? .identity : .move(edge: .leading)
                )
                .gesture(
                    DragGesture().onEnded { value in
                        guard value.translation.width < -80 else { return }
                        closeDrawer()
                    }
                )
        }
    }

    private var mainContent: some View {
        LanguageSelectionView()
            .disabled(showDrawer)
            .offset(x: shouldReduceMotion ? 0 : (showDrawer ? 72 : 0))
            .animation(
                shouldReduceMotion ? nil : .easeOut(duration: 0.2),
                value: showDrawer
            )
    }

    private func toggleDrawer() {
        withDrawerAnimation {
            showDrawer.toggle()
        }
    }

    private func closeDrawer() {
        withDrawerAnimation {
            showDrawer = false
        }
    }

    private func withDrawerAnimation(_ action: @escaping () -> Void) {
        guard !shouldReduceMotion else {
            action()
            return
        }

        withAnimation(.easeOut(duration: 0.22), action)
    }
}

#Preview {
    HomeView()
}
