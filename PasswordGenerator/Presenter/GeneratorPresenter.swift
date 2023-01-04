import UIKit

// MARK: - GeneratorPresenter
final class GeneratorPresenter {

    // MARK: - Properties and Initializers
    weak var viewController: GeneratorController?

    init(viewController: GeneratorController? = nil) {
        self.viewController = viewController
        viewController?.generatorView.delegate = self
    }
}

// MARK: - Helpers
extension GeneratorPresenter {

    private func showSuccessfullCopyAlert() {

        let alertController = UIAlertController(
            title: "Password Copied",
            message: "The password was copied to the phone memory!",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController?.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - GeneratorViewDelegate
extension GeneratorPresenter: GeneratorViewDelegate {

    func passwordLengthChanged(to passwordLength: Int) {
        guard let view = viewController?.generatorView else { return }
        view.passwordLengthLabel.text = String(passwordLength)
    }

    func charctersGroupStateChanged(to state: Bool) {
        guard let view = viewController?.generatorView else { return }
        if state {
            view.passwordSecurityLevelProgress.progress += 0.25
        } else {
            view.passwordSecurityLevelProgress.progress -= 0.25
        }

        switch view.passwordSecurityLevelProgress.progress {
        case 0.25: view.passwordSecurityLevelProgress.progressTintColor = .pgRed
        case 0.50: view.passwordSecurityLevelProgress.progressTintColor = .pgOrange
        case 0.75: view.passwordSecurityLevelProgress.progressTintColor = .pgYellow
        case 1.00: view.passwordSecurityLevelProgress.progressTintColor = .pgGreen
        default: view.passwordSecurityLevelProgress.progressTintColor = .pgRed
        }
    }

    func generateButtonTapped(withParameters parameters: [Bool], andPasswordLength passwordLength: Int) {

        guard let view = viewController?.generatorView else { return }
        var groupsSet: Set<Characters.RawValue> = []

        view.generatePasswordButton.alpha = 0.75
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            view.generatePasswordButton.alpha = 1
        })

        if parameters[0] {
            groupsSet.insert(Characters.lowerCase.rawValue)
        }
        if parameters[1] {
            groupsSet.insert(Characters.upperCase.rawValue)
        }
        if parameters[2] {
            groupsSet.insert(Characters.numbers.rawValue)
        }
        if parameters[3] {
            groupsSet.insert(Characters.special.rawValue)
        }
        if groupsSet.count == 0 {
            view.generatedPasswordTextField.text = "No groups selected"
        } else {
            view.generatedPasswordTextField.text = Password().generate(groupsSet, passwordLength)
            view.generatedPasswordTextField.isUserInteractionEnabled = true
        }
    }

    func passwordWasCopied() {
        guard let view = viewController?.generatorView else { return }
        view.generatedPasswordTextField.isUserInteractionEnabled = false
        UIPasteboard.general.string = view.generatedPasswordTextField.text
        showSuccessfullCopyAlert()
    }
}
