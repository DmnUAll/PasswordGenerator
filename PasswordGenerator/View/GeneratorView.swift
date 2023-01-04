import UIKit

// MARK: - GeneratorViewDelegate protocol
protocol GeneratorViewDelegate: AnyObject {
    func passwordLengthChanged(to passwordLength: Int)
    func charctersGroupStateChanged(to state: Bool)
    func generateButtonTapped(withParameters parameters: [Bool], andPasswordLength passwordLength: Int)
    func passwordWasCopied()
}

// MARK: - GeneratorView
final class GeneratorView: UIView {

    // MARK: - Properties and Initializers
    weak var delegate: GeneratorViewDelegate?

    lazy var passwordLengthLabel: UILabel = {
        makeLabel(withText: "8", alignment: .left, andHuggingPriority: 249)
    }()

    lazy var passwordLengthSlider: UISlider = {
        let slider = UISlider()
        slider.tintColor = .pgWhite
        slider.minimumValue = 1
        slider.maximumValue = 32
        slider.value = 8
        slider.addTarget(self, action: #selector(passwordLengthChanged), for: .valueChanged)
        return slider
    }()

    private lazy var passwordLengthStackView: UIStackView = {
        let stackView = makeStackView(withAxis: .vertical)
        stackView.toAutolayout()
        stackView.addArrangedSubview(makeStackView(withAxis: .horizontal,
                                                   spacing: 3,
                                                   andItems: [
                                                    makeLabel(withText: "Password length:",
                                                              alignment: .left),
                                                    passwordLengthLabel
                                                   ]))
        stackView.addArrangedSubview(makeStackView(withAxis: .horizontal,
                                                   andItems: [
                                                    makeLabel(withText: "1", alignment: .center),
                                                    passwordLengthSlider,
                                                    makeLabel(withText: "32", alignment: .center)
                                                   ]))
        return stackView
    }()

    private lazy var lowercaseLettersSwitch: UISwitch = {
        makeSwitch()
    }()

    private lazy var uppercaseLettersSwitch: UISwitch = {
        makeSwitch()
    }()

    private lazy var numbersSwitch: UISwitch = {
        makeSwitch()
    }()

    private lazy var specialCharactersSwitch: UISwitch = {
        makeSwitch(withOnState: false)
    }()

    private lazy var charactersGroupsStackView: UIStackView = {
        let stackView = makeStackView(withAxis: .vertical)
        stackView.toAutolayout()
        stackView.addArrangedSubview(makeLabel(withText: "Characters groups:", alignment: .left))
        stackView.addArrangedSubview(makeStackView(withAxis: .horizontal,
                                                   andItems: [
                                                    makeLabel(withText: "Lowercase letters",
                                                              alignment: .right),
                                                    lowercaseLettersSwitch
                                                   ]))
        stackView.addArrangedSubview(makeStackView(withAxis: .horizontal,
                                                   andItems: [
                                                    makeLabel(withText: "Uppercase letters",
                                                              alignment: .right),
                                                    uppercaseLettersSwitch
                                                   ]))
        stackView.addArrangedSubview(makeStackView(withAxis: .horizontal,
                                                   andItems: [
                                                    makeLabel(withText: "Numbers",
                                                              alignment: .right),
                                                    numbersSwitch
                                                   ]))
        stackView.addArrangedSubview(makeStackView(withAxis: .horizontal,
                                                   andItems: [
                                                    makeLabel(withText: "Special characters",
                                                              alignment: .right),
                                                    specialCharactersSwitch
                                                   ]))
        return stackView
    }()

    let passwordSecurityLevelProgress: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .darkGray
        progressView.progressTintColor = .pgYellow
        progressView.progress = 0.75
        progressView.layer.cornerRadius = 10
        progressView.clipsToBounds = true
        return progressView
    }()

    private lazy var passwordSecurityLevelStackView: UIStackView = {
        let stackView = makeStackView(withAxis: .vertical)
        stackView.toAutolayout()
        stackView.addArrangedSubview(makeLabel(withText: "Password security level:", alignment: .center))
        stackView.addArrangedSubview(makeStackView(withAxis: .horizontal,
                                                   andItems: [
                                                    makeImageView(withImage: "hand.thumbsdown"),
                                                    passwordSecurityLevelProgress,
                                                    makeImageView(withImage: "hand.thumbsup")
                                                   ]))
        return stackView
    }()

    lazy var generatedPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.isUserInteractionEnabled = false
        textField.backgroundColor = .pgWhite
        textField.font = UIFont(name: "Apple SD Gothic Neo Regular", size: 20)
        textField.textColor = .black
        textField.textAlignment = .center
        textField.layer.cornerRadius = 10
        textField.addTarget(self, action: #selector(passwordWasCopied), for: .touchDown)
        return textField
    }()

    lazy var generatePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Generate Password", for: .normal)
        button.backgroundColor = .darkGray
        button.tintColor = .pgWhite
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var generatedPasswordStackView: UIStackView = {
        let stackView = makeStackView(withAxis: .vertical)
        stackView.toAutolayout()
        stackView.addArrangedSubview(makeLabel(withText: "Generated password:", alignment: .center))
        stackView.addArrangedSubview(generatedPasswordTextField)
        stackView.addArrangedSubview(generatePasswordButton)
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        toAutolayout()
        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers
extension GeneratorView {

    @objc private func passwordLengthChanged() {
        delegate?.passwordLengthChanged(to: Int(passwordLengthSlider.value))
    }

    @objc private func charactersGroupStateChanged(_ sender: UISwitch) {
        delegate?.charctersGroupStateChanged(to: sender.isOn)
    }

    @objc private func generateButtonTapped() {
        delegate?.generateButtonTapped(
            withParameters: [
                lowercaseLettersSwitch.isOn,
                uppercaseLettersSwitch.isOn,
                numbersSwitch.isOn,
                specialCharactersSwitch.isOn
            ],
            andPasswordLength: Int(passwordLengthSlider.value))
    }

    @objc private func passwordWasCopied() {
        delegate?.passwordWasCopied()
    }

    private func addSubviews() {
        addSubview(passwordLengthStackView)
        addSubview(charactersGroupsStackView)
        addSubview(passwordSecurityLevelStackView)
        addSubview(generatedPasswordStackView)
    }

    private func setupConstraints() {
        let constants = [
            passwordLengthStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            passwordLengthStackView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            passwordLengthStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            charactersGroupsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            charactersGroupsStackView.topAnchor.constraint(equalTo: passwordLengthStackView.bottomAnchor, constant: 48),
            charactersGroupsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            passwordSecurityLevelStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            passwordSecurityLevelStackView.topAnchor.constraint(equalTo: charactersGroupsStackView.bottomAnchor,
                                                                constant: 48),
            passwordSecurityLevelStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            generatedPasswordStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            generatedPasswordStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            generatedPasswordStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
        ]
        NSLayoutConstraint.activate(constants)
    }

    private func makeStackView(withAxis axis: NSLayoutConstraint.Axis,
                               spacing: CGFloat = 24,
                               andItems items: [UIView] = []
    ) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = spacing
        for item in items {
            stackView.addArrangedSubview(item)
        }
        return stackView
    }

    private func makeLabel(withText text: String, alignment: NSTextAlignment,
                           andHuggingPriority huggingPriority: Float = 250) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "Apple SD Gothic Neo Regular", size: 20)
        label.textColor = .pgWhite
        label.textAlignment = alignment
        label.setContentHuggingPriority(UILayoutPriority(huggingPriority), for: .horizontal)
        return label
    }

    private func makeSwitch(withOnState state: Bool = true) -> UISwitch {
        let uiSwitch = UISwitch()
        uiSwitch.isOn = state
        uiSwitch.addTarget(self, action: #selector(charactersGroupStateChanged), for: .valueChanged)
        return uiSwitch
    }

    private func makeImageView(withImage image: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: image)
        imageView.tintColor = .pgWhite
        return imageView
    }
}
