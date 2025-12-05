//
//  Header.swift
//  Movies
//
//  Created by MACM72 on 03/12/25.
//

import UIKit

final class Header: UIView {

    // MARK: - Props
    var showBackButton: Bool = false {
        didSet { backButton.isHidden = !showBackButton }
    }
    var backButtonAction: (() -> Void)?
    

    // MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        return label
    }()

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "chevron.left")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.isHidden = true
        return button
    }()



    // MARK: - Init with required title
    init(title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        setupViews()
        setConstraints()
        callBacks()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}

// MARK: - Setup views & constraints
extension Header {
    private func setupViews() {
        backgroundColor = UIColor(named: "Header") ?? .systemBlue
        addSubview(backButton)
        addSubview(titleLabel)
    }
    
    private func callBacks() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }

    private func setConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 100),

            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 60),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -60)
        ])
    }
    
    // MARK: - Back button handler
    @objc private func backButtonTapped() {
        backButtonAction?()
    }
}
