//import UIKit
//
//final class SearchSuggestionCell: UITableViewCell {
//
//    static let identifier = "SearchSuggestionCell"
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 15, weight: .regular)
//        label.textColor = .white
//        return label
//    }()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupUI() {
//        backgroundColor = .darkGray
//        contentView.addSubview(titleLabel)
//
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
//            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
//            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
//        ])
//    }
//
//    func configure(with suggestion: SearchSuggestion) {
//        titleLabel.text = suggestion.title
//    }
//}


import UIKit

final class SearchSuggestionCell: UITableViewCell {

    static let id = "SearchSuggestionCell"

    func configure(title: String) {
        textLabel?.text = title
        textLabel?.textColor = .white
        backgroundColor = .clear
    }
}
