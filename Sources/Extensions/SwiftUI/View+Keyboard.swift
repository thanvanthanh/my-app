import SwiftUI
import UIKit

extension View {
    /// Dismisses the keyboard when tapping anywhere outside a text input.
    /// The recognizer does not consume touches, so buttons and other controls still work.
    func dismissKeyboardOnTap() -> some View {
        background(KeyboardDismissGestureInstaller())
    }
}

private struct KeyboardDismissGestureInstaller: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> InstallerView {
        let view = InstallerView()
        let coordinator = context.coordinator

        view.isUserInteractionEnabled = false
        view.onMoveToWindow = { [weak coordinator] window in
            coordinator?.install(on: window)
        }
        return view
    }

    func updateUIView(_ uiView: InstallerView, context: Context) {}

    static func dismantleUIView(_ uiView: InstallerView, coordinator: Coordinator) {
        coordinator.uninstall()
    }

    final class InstallerView: UIView {
        var onMoveToWindow: ((UIWindow?) -> Void)?

        override func didMoveToWindow() {
            super.didMoveToWindow()
            onMoveToWindow?(window)
        }
    }

    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        private weak var window: UIWindow?

        private lazy var recognizer: UITapGestureRecognizer = {
            let recognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(handleTap)
            )
            recognizer.cancelsTouchesInView = false
            recognizer.delegate = self
            return recognizer
        }()

        func install(on window: UIWindow?) {
            guard self.window !== window else { return }

            uninstall()
            self.window = window
            window?.addGestureRecognizer(recognizer)
        }

        func uninstall() {
            window?.removeGestureRecognizer(recognizer)
            window = nil
        }

        @objc private func handleTap() {
            UIApplication.shared.dismissKeyboard()
        }

        func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldReceive touch: UITouch
        ) -> Bool {
            !touch.isInsideTextInput
        }
    }
}

private extension UITouch {
    var isInsideTextInput: Bool {
        var currentView = view

        while let candidate = currentView {
            if candidate is UITextField || candidate is UITextView {
                return true
            }
            currentView = candidate.superview
        }

        return false
    }
}
