//
//  SavedMovies+CoreDataProperties.swift
//  Movies
//
//  Created by MACM72 on 15/12/25.
//
//

public import Foundation
public import CoreData


public typealias SavedMoviesCoreDataPropertiesSet = NSSet

extension SavedMovies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedMovies> {
        return NSFetchRequest<SavedMovies>(entityName: "SavedMovies")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?

}

extension SavedMovies : Identifiable {

}
