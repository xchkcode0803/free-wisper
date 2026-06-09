import UIKit
import SwiftUI

class KeyboardViewController: UIInputViewController {

    private var hosting: UIHostingController<AnyView>?
    private let vm = VoiceKeyboardViewModel()
    private let lang = LangManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        SharedDefaults.shared.keyboardDidLoadAt = Date()
        SharedDefaults.shared.keyboardHasFullAccess = self.hasFullAccess

        vm.inputViewController = self

        let rootView = VoiceKeyboardView(vm: vm).environmentObject(lang)
        let host = UIHostingController(rootView: AnyView(rootView))
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.backgroundColor = .clear
        addChild(host)
        view.addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        host.didMove(toParent: self)
        self.hosting = host

        // Lock the height to ~260pt above the home indicator (system adds safe area).
        let height = view.heightAnchor.constraint(equalToConstant: 260)
        height.priority = .defaultHigh
        height.isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SharedDefaults.shared.keyboardHasFullAccess = self.hasFullAccess
    }

    override func textWillChange(_ textInput: UITextInput?) {}
    override func textDidChange(_ textInput: UITextInput?) {}
}
