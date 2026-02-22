//
//  SideDrawerView.swift
//  Slayken Learn
//
//  Created by Tufan Cakir on 21.02.26.
//

import SwiftUI

struct SideDrawerView: View {

    @Binding var showDrawer: Bool

    var body: some View {

        VStack(spacing: 0) {

            header

            Divider()

            DrawerListView()

            closeButton
        }

        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )

        .background(
            Color(.systemGroupedBackground)
        )

        .padding(.top, 50)
    }
}

extension SideDrawerView {

    private var header: some View {

        HStack {

            Label(
                "Dokumentation",
                systemImage: "book.fill"
            )
            .font(.title3.bold())

            Spacer()
        }
        .padding()
    }
}

extension SideDrawerView {

    private var closeButton: some View {

        Button {

            closeDrawer()

        } label: {

            Text("Schließen")
                .frame(maxWidth: .infinity)
        }

        .buttonStyle(.borderedProminent)

        .padding()
    }
}

extension SideDrawerView {

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

    SideDrawerView(
        showDrawer: .constant(false)
    )
}
