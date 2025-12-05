//
//  MovieInfoContentView.swift
//  Movies
//
//  Created by MACM72 on 04/12/25.
//

import UIKit
import SwiftUI

class MovieInfoContentView: UIView {
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Backdrop Image
    private let backdropContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backdropImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .darkGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let backdropGradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Poster and Title Container
    private let posterTitleContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .darkGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    // Info sections container
    private let infoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Info rows
    private var overviewRow: InfoRowView!
    private var genresRow: InfoRowView!
    private var durationRow: InfoRowView!
    private var releaseDateRow: InfoRowView!
    private var productionCompaniesRow: InfoRowView!
    private var budgetRow: InfoRowView!
    private var revenueRow: InfoRowView!
    private var languagesRow: InfoRowView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(named: "Background")
        
        // Add gradient to backdrop
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor(named: "Background")?.cgColor ?? UIColor.black.cgColor
        ]
        gradientLayer.locations = [1.0, 1.0]
        backdropGradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Setup scroll view
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        backdropContainerView.addSubview(backdropImageView)
        backdropContainerView.addSubview(backdropGradientView)
        contentStackView.addArrangedSubview(backdropContainerView)
//        
//        // Add poster and title
        posterTitleContainer.addSubview(posterImageView)
        posterTitleContainer.addSubview(titleStackView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(taglineLabel)
        contentStackView.addArrangedSubview(posterTitleContainer)
        
        // Add info section
        infoContainer.addSubview(infoStackView)
        contentStackView.addArrangedSubview(infoContainer)
        
        // Create info rows
        overviewRow = InfoRowView(title: "Overview", value: "")
        genresRow = InfoRowView(title: "Genres", value: "")
        durationRow = InfoRowView(title: "Duration", value: "")
        releaseDateRow = InfoRowView(title: "Release Date", value: "")
        productionCompaniesRow = InfoRowView(title: "Production Companies", value: "")
        budgetRow = InfoRowView(title: "Production Budget", value: "")
        revenueRow = InfoRowView(title: "Revenue", value: "")
        languagesRow = InfoRowView(title: "Languages", value: "")
        
        infoStackView.addArrangedSubview(overviewRow)
        infoStackView.addArrangedSubview(genresRow)
        infoStackView.addArrangedSubview(durationRow)
        infoStackView.addArrangedSubview(releaseDateRow)
        infoStackView.addArrangedSubview(productionCompaniesRow)
        infoStackView.addArrangedSubview(budgetRow)
        infoStackView.addArrangedSubview(revenueRow)
        infoStackView.addArrangedSubview(languagesRow)
        
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Update gradient frame
        if let gradientLayer = backdropGradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = backdropGradientView.bounds
        }
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Content stack
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Backdrop container
            backdropContainerView.heightAnchor.constraint(equalToConstant: Screen.height * 0.3),
            
            // Backdrop image
            backdropImageView.topAnchor.constraint(equalTo: backdropContainerView.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: backdropContainerView.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: backdropContainerView.trailingAnchor),
            backdropImageView.bottomAnchor.constraint(equalTo: backdropContainerView.bottomAnchor),
            
            // Backdrop gradient
            backdropGradientView.topAnchor.constraint(equalTo: backdropContainerView.topAnchor),
            backdropGradientView.leadingAnchor.constraint(equalTo: backdropContainerView.leadingAnchor),
            backdropGradientView.trailingAnchor.constraint(equalTo: backdropContainerView.trailingAnchor),
            backdropGradientView.bottomAnchor.constraint(equalTo: backdropContainerView.bottomAnchor),
            
            // Poster and title container
            posterTitleContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: Screen.height * 0.15),
            
            posterTitleContainer.topAnchor.constraint(equalTo: backdropContainerView.bottomAnchor,constant: -120),
            
            // Poster image
            posterImageView.topAnchor.constraint(equalTo: posterTitleContainer.topAnchor, constant: -50),
            posterImageView.leadingAnchor.constraint(equalTo: posterTitleContainer.leadingAnchor, constant: 20),
            posterImageView.widthAnchor.constraint(equalToConstant: Screen.width * 0.22),
            posterImageView.heightAnchor.constraint(equalToConstant: 150),
            posterImageView.bottomAnchor.constraint(lessThanOrEqualTo: posterTitleContainer.bottomAnchor, constant: -20),
            
            // Title stack
            titleStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleStackView.trailingAnchor.constraint(equalTo: posterTitleContainer.trailingAnchor, constant: -20),
//            titleStackView.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            titleStackView.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            titleStackView.bottomAnchor.constraint(lessThanOrEqualTo: posterTitleContainer.bottomAnchor, constant: -20),
            
            // Info container
            infoContainer.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: 0),
            infoContainer.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor, constant:0),
            
            // Info stack
            infoStackView.topAnchor.constraint(equalTo: infoContainer.topAnchor,constant: -10),
            infoStackView.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor,constant: 20),
            infoStackView.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor,constant: -20),
            infoStackView.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor, constant: -20),
        ])
    }
    
    func configure(with movie: MovieDetail) {
        titleLabel.text = movie.title
        taglineLabel.text = movie.tagline
        
        overviewRow.update(value: movie.overview)
        genresRow.update(value: movie.genreNames)
        durationRow.update(value: movie.formattedRuntime)
        releaseDateRow.update(value: movie.formattedReleaseDate)
        
        let companies = movie.productionCompanies.map { $0.name }.joined(separator: ", ")
        productionCompaniesRow.update(value: companies)
        
        budgetRow.update(value: movie.formattedBudget)
        revenueRow.update(value: movie.formattedRevenue)
        
        let languages = movie.spokenLanguages.map { $0.englishName }.joined(separator: ", ")
        languagesRow.update(value: languages)
        
        // Load images
        if let backdropURL = URL(string: movie.backdropURL) {
            loadImage(from: backdropURL, into: backdropImageView)
        }
        
        if let posterURL = URL(string: movie.posterURL) {
            loadImage(from: posterURL, into: posterImageView)
        }
    }
    
    private func loadImage(from url: URL, into imageView: UIImageView) {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    await MainActor.run {
                        // imageView is refrence of UIImageView(whihc is creae above for posten and backdrop poster)
                        imageView.image = image
                    }
                }
            } catch {
                print("Failed to load image: \(error)")
            }
        }
    }
}




// MARK: - Mock Data for Preview
#if DEBUG
extension MovieDetail {
    static var mock: MovieDetail {
        MovieDetail(
            adult: false,
            backdropPath: "/3V4kLQg0kSqPLctI5ziYWabAZYF.jpg",
            belongsToCollection: nil,
            budget: 25000000,
            genres: [
                Genre(id: 18, name: "Drama"),
                Genre(id: 80, name: "Crime")
            ],
            homepage: "https://www.warnerbros.com/movies/shawshank-redemption",
            id: 278,
            imdbId: "tt0111161",
            originCountry: ["US"],
            originalLanguage: "en",
            originalTitle: "The Shawshank Redemption",
            overview: "Framed in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.",
            popularity: 132.502,
            posterPath: "/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg",
            productionCompanies: [
                ProductionCompany(id: 97, logoPath: "/7znWcbDd4PcJzJUlSxD3j3bKPrq.png", name: "Castle Rock Entertainment", originCountry: "US")
            ],
            productionCountries: [
                ProductionCountry(iso31661: "US", name: "United States of America")
            ],
            releaseDate: "1994-09-23",
            revenue: 28341469,
            runtime: 142,
            spokenLanguages: [
                SpokenLanguage(englishName: "English", iso6391: "en", name: "English")
            ],
            status: "Released",
            tagline: "Fear can hold you prisoner. Hope can set you free.",
            title: "The Shawshank Redemption",
            video: false,
            voteAverage: 8.707,
            voteCount: 26909
        )
    }
}

// MARK: - SwiftUI Preview
struct MovieInfoContentView_Preview: PreviewProvider {
    static var previews: some View {
        MovieInfoContentViewRepresentable()
            .ignoresSafeArea()
            .previewDevice("iPhone 15")
    }
}

struct MovieInfoContentViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> MovieInfoContentView {
        let view = MovieInfoContentView()
        view.configure(with: .mock)
        return view
    }
    
    func updateUIView(_ uiView: MovieInfoContentView, context: Context) {
        // No update needed
    }
}
#endif
