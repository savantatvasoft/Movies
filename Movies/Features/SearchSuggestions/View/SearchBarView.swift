import UIKit
import Combine

protocol SearchBarViewDelegate: AnyObject {
    func didStartSearching()
    func didCancelSearching()
    func didChangeText(_ text: String)
}

final class SearchBarView: UIView {

    weak var delegate: SearchBarViewDelegate?
    let suggestionView = SearchSuggestionView()

    private var isSearchActive = false
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI
    let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search movies"
        tf.textColor = .white
        tf.backgroundColor = UIColor(named: "SearchBackground") ?? .gray.withAlphaComponent(0.2)
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.systemGray4.cgColor
        tf.heightAnchor.constraint(equalToConstant: 40).isActive = true
        tf.setLeftIcon(UIImage(systemName: "magnifyingglass")!, padding: 12)
        return tf
    }()

    let cancelButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Cancel", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        btn.alpha = 0
        return btn
    }()

    private var leadingC: NSLayoutConstraint!
    private var trailingC: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = false   // Allow suggestions to appear outside
        setup()
        setupBindings()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        suggestionView.delegate = self

        textField.textPublisher
            .sink { [weak self] text in
                self?.suggestionView.update(text: text)
            }
            .store(in: &cancellables)

        addSubview(textField)
        addSubview(cancelButton)

        textField.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        leadingC = textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        trailingC = textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)

        NSLayoutConstraint.activate([
            leadingC,
            trailingC,
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),

            cancelButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])

        textField.delegate = self
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }

    private func setupBindings() {
        textField.textPublisher
            .debounce(for: .milliseconds(350), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.delegate?.didChangeText(text)
            }
            .store(in: &cancellables)
    }

    private func expand() {
        guard !isSearchActive else { return }
        isSearchActive = true

        leadingC.constant = 0
        trailingC.constant = -70
        textField.layer.borderWidth = 0
        textField.backgroundColor = .clear

        UIView.animate(withDuration: 0.3) {
            self.cancelButton.alpha = 1
            self.layoutIfNeeded()
        }

        delegate?.didStartSearching()
    }

    private func collapse() {
        guard isSearchActive else { return }
        isSearchActive = false

        leadingC.constant = 10
        trailingC.constant = -10
        textField.layer.borderWidth = 1
        textField.backgroundColor = UIColor(named: "SearchBackground") ?? .gray.withAlphaComponent(0.2)

        UIView.animate(withDuration: 0.3) {
            self.cancelButton.alpha = 0
            self.layoutIfNeeded()
        }

        delegate?.didCancelSearching()
    }

    @objc private func cancelTapped() {
        textField.text = ""
        collapse()
        textField.resignFirstResponder()
        delegate?.didChangeText("")
        suggestionView.isHidden = true
    }
}

// MARK: - UITextFieldDelegate
extension SearchBarView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        suggestionView.isHidden = false
        expand()
        return true
    }
}

// MARK: - SearchSuggestionViewDelegate
extension SearchBarView: SearchSuggestionViewDelegate {
    func didSelectSuggestion(_ text: String) {
        textField.text = text
        suggestionView.isHidden = true
        textField.resignFirstResponder()
        delegate?.didChangeText(text)
    }
}
