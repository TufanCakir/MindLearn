import SwiftUI

struct ContentLoadingFailureView: View {
    let title: String
    let description: String
    let details: String

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: "exclamationmark.triangle")
        } description: {
            VStack(spacing: 6) {
                Text(description)
                Text(details)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
