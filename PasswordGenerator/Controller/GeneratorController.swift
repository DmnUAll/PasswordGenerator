import UIKit

// MARK: - GeneratorController
final class GeneratorController: UIViewController {

    // MARK: - Properties and Initializers
    private var presenter: GeneratorPresenter?
    lazy var generatorView: GeneratorView = {
        let view = GeneratorView()
        return view
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(generatorView)
        setupConstraints()
        presenter = GeneratorPresenter(viewController: self)
    }
}

// MARK: - Helpers
extension GeneratorController {

    private func setupConstraints() {
        let constraints = [
            generatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            generatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            generatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            generatorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
