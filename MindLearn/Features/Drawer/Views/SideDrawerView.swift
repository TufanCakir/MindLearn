//
//  SideDrawerView.swift
//  MindLearn
//
//  Created by Tufan Cakir on 31.10.25.
//

import SwiftUI

struct SideDrawerView: View {

    @Binding var showDrawer: Bool
    @State private var vm = DrawerViewModel()
    @Environment(LocalizationStore.self) private var localization

    private var language: String { localization.language }

    private var text: AppLocalization {
        localization.text
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            categoryTabs
            Divider()
            DrawerListView(sections: vm.filteredSections)
            closeButton
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Category Tabs

extension SideDrawerView {

    private var categoryTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(vm.categories, id: \.self) { category in
                    categoryButton(category)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .background(Color(.secondarySystemGroupedBackground))
    }

    private func categoryButton(
        _ category: ContentCategoryFilter
    ) -> some View {

        let selected = vm.selectedCategory == category
        let style = vm.style(for: category)
        let color = style.color

        return Button {
            withAnimation(.easeOut(duration: 0.16)) {
                vm.selectedCategory = category
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: style.icon)
                    .font(.caption.bold())
                    .foregroundStyle(selected ? color : .secondary)

                Text(category.title(allTitle: text.drawer.all))
                    .font(.caption.bold())
                    .foregroundStyle(selected ? color : .primary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                selected
                    ? color.opacity(0.16)
                    : Color(.tertiarySystemGroupedBackground)
            )
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(category.title(allTitle: text.drawer.all))
    }
}

extension SideDrawerView {

    private var header: some View {
        HStack {
            Label(text.drawer.title, systemImage: "book.fill")
                .font(.title3.bold())

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

extension SideDrawerView {

    private var closeButton: some View {
        Button {
            closeDrawer()
        } label: {
            Text(text.drawer.close)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.glassProminent)
        .controlSize(.regular)
        .padding(16)
        .accessibilityLabel(text.accessibility.closeDrawer)
        .accessibilityHint(text.accessibility.closeDrawerHint)
    }
}

extension SideDrawerView {

    private func closeDrawer() {
        withAnimation(.easeOut(duration: 0.2)) {
            showDrawer = false
        }
    }
}

#Preview {
    PreviewRoot {
        SideDrawerView(
            showDrawer: .constant(false)
        )
    }
}
