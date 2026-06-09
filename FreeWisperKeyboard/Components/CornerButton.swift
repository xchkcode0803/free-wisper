import SwiftUI

// Square corner button (no rounded), hairline ink border.
struct CornerButton<Content: View>: View {
    let action: () -> Void
    var longPress: (() -> Void)? = nil
    @ViewBuilder var content: () -> Content

    var body: some View {
        Button(action: action) {
            content()
                .frame(width: 44, height: 44)
                .background(Color.clear)
                .overlay(Rectangle().stroke(FWColor.hair, lineWidth: 1))
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.4).onEnded { _ in longPress?() }
        )
    }
}
