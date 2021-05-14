//
//  Scores+CoreDataProperties.swift
//  
//
//  Created by Edward Guilllermo on 5/14/21.
//
//

import Foundation
import CoreData


extension Scores {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Scores> {
        return NSFetchRequest<Scores>(entityName: "Scores")
    }

    @NSManaged public var correctAnswers: Int64
    @NSManaged public var totalQuestions: Int64
    @NSManaged public var scoreID: NSSet?

}

// MARK: Generated accessors for scoreID
extension Scores {

    @objc(addScoreIDObject:)
    @NSManaged public func addToScoreID(_ value: Categories)

    @objc(removeScoreIDObject:)
    @NSManaged public func removeFromScoreID(_ value: Categories)

    @objc(addScoreID:)
    @NSManaged public func addToScoreID(_ values: NSSet)

    @objc(removeScoreID:)
    @NSManaged public func removeFromScoreID(_ values: NSSet)

}
