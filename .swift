//
//  SearchHistory+CoreDataProperties.swift
//  Movies
//
//  Created by MACM72 on 12/12/25.
//
//

public import Foundation
public import CoreData


public typealias SearchHistoryCoreDataPropertiesSet = NSSet

extension SearchHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchHistory> {
        return NSFetchRequest<SearchHistory>(entityName: "SearchHistory")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var text: String?
    @NSManaged public var createdAt: Date?

}

extension SearchHistory : Identifiable {

}
