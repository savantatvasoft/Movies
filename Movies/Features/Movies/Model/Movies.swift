//
//  Movies.swift
//  Movies
//
//  Created by MACM72 on 03/12/25.
//
import Foundation


struct MoviesResponse: Decodable {
    let page: Int
    let results: [Movies]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movies: Decodable {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let releaseDate: String
    let posterPath: String?  // ← API returns poster_path, not posterURL
    let backdropPath: String?
    let adult: Bool
    let genreIDs: [Int]
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
    let video: Bool
    
    // Computed property to build full URL
    var posterURL: String {
        guard let posterPath = posterPath else { return "" }
        return "https://image.tmdb.org/t/p/w500\(posterPath)"
    }
    
    // Computed property for backdrop URL
    var backdropURL: String {
        guard let backdropPath = backdropPath else { return "" }
        return "https://image.tmdb.org/t/p/w500\(backdropPath)"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"  // ← Map from API field name
        case backdropPath = "backdrop_path"
        case adult
        case genreIDs = "genre_ids"
        case popularity
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case video
    }
}


struct MovieDetail: Decodable {
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: Collection?
    let budget: Int
    let genres: [Genre]
    let homepage: String?
    let id: Int
    let imdbId: String?
    let originCountry: [String]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String
    let revenue: Int
    let runtime: Int?
    let spokenLanguages: [SpokenLanguage]
    let status: String
    let tagline: String?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget
        case genres
        case homepage
        case id
        case imdbId = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue
        case runtime
        case spokenLanguages = "spoken_languages"
        case status
        case tagline
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
   
    var posterURL: String {
        guard let posterPath = posterPath else { return "" }
        return "https://image.tmdb.org/t/p/w500\(posterPath)"
    }
    
    var backdropURL: String {
        guard let backdropPath = backdropPath else { return "" }
        return "https://image.tmdb.org/t/p/original\(backdropPath)"
    }
    
    var formattedReleaseDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: releaseDate) else {
            return releaseDate
        }
        
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }
    
    var formattedRuntime: String {
        guard let runtime = runtime else { return "N/A" }
        let hours = runtime / 60
        let minutes = runtime % 60
        return "\(hours)h \(minutes)m"
    }
    
    var formattedBudget: String {
        if budget == 0 { return "N/A" }
        return "$\(budget / 1_000_000)M"
    }
    
    var formattedRevenue: String {
        if revenue == 0 { return "N/A" }
        return "$\(revenue / 1_000_000)M"
    }
    
    var ratingPercentage: Int {
        return Int(voteAverage * 10)
    }
    
    var genreNames: String {
        return genres.map { $0.name }.joined(separator: ", ")
    }
}

// MARK: - Collection
struct Collection: Decodable {
    let id: Int
    let name: String
    let posterPath: String?
    let backdropPath: String?
    
    var posterURL: String {
        guard let posterPath = posterPath else { return "" }
        return "https://image.tmdb.org/t/p/w500\(posterPath)"
    }
}

// MARK: - Genre
struct Genre: Decodable {
    let id: Int
    let name: String
}

// MARK: - Production Company
struct ProductionCompany: Decodable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String?  // ✅ Make this optional
    
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
    
    var logoURL: String {
        guard let logoPath = logoPath else { return "" }
        return "https://image.tmdb.org/t/p/w200\(logoPath)"
    }
}

// MARK: - Production Country
struct ProductionCountry: Decodable {
    let iso31661: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case name
    }
}

// MARK: - Spoken Language
struct SpokenLanguage: Decodable {
    let englishName: String
    let iso6391: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso6391 = "iso_639_1"
        case name
    }
}
