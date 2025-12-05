import UIKit
import SwiftUI


class MovieCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Background")
        view.layer.cornerRadius = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 0
        iv.widthAnchor.constraint(equalToConstant: 90).isActive = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 18)
        lbl.textColor = .white
        return lbl
    }()
    
    private let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .lightGray
        return lbl
    }()
    
    private let overviewLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .white
        lbl.numberOfLines = 3
        return lbl
    }()
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .top
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(named: "Background")
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(mainStack)
        
        // Add views to stacks
        infoStack.addArrangedSubview(titleLabel)
        infoStack.addArrangedSubview(dateLabel)
        infoStack.setCustomSpacing(12, after: dateLabel)
        infoStack.addArrangedSubview(overviewLabel)

        mainStack.addArrangedSubview(posterImageView)
        mainStack.addArrangedSubview(infoStack)

        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addBorder(sides: [.bottom], color: .systemBackground, borderWidth: 0.2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            contentView.heightAnchor.constraint(equalToConstant: Screen.height * 0.2),
            
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            mainStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    
    // MARK: - Configure
    func configure(with movie: Movies) {
        titleLabel.text = movie.title
        dateLabel.text = movie.releaseDate
        overviewLabel.text = movie.overview
        
        loadImage(from: movie.posterURL)
    }
    
    
    // MARK: - Image from URL
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        posterImageView.image = nil
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    self.posterImageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}





// MARK: - SwiftUI Preview

#if DEBUG
struct MovieCell_Preview: PreviewProvider {
    static var previews: some View {
        
        let previewMovie = Movies(
            id: 1,
            title: "Venom",
            originalTitle: "Venom",
            overview: "When Eddie Brock acquires the powers of a symbiote, he must release his alter-ego Venom to save his life.",
            releaseDate: "2018-10-03",
            posterPath: "/2uNW4WbgBXL25BAbXGLnLqX71Sw.jpg",
            backdropPath: "/someBackdrop.jpg",
            adult: false,
            genreIDs: [28, 878, 53],
            popularity: 500.0,
            voteAverage: 7.5,
            voteCount: 1200,
            video: false
        )
        
        return MovieCellRepresentable(movie: previewMovie)
            .frame(width: Screen.width, height: 180)
            .previewDevice("iPhone 15")
    }
}
struct MovieCellRepresentable: UIViewRepresentable {

    let movie: Movies

    func makeUIView(context: Context) -> UIView {
        let cell = MovieCell(style: .default, reuseIdentifier: "cell")
        cell.configure(with: movie)
        cell.layoutIfNeeded()
        return cell.contentView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
#endif

