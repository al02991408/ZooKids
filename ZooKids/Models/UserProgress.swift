//
//  UserProgress.swift
//  ZooKids
//
//  Created by ZooKids Team on 27/11/25.
//

import Foundation
import CoreData

@objc(UserProgress)
public class UserProgress: NSManagedObject {

}

extension UserProgress {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProgress> {
        return NSFetchRequest<UserProgress>(entityName: "UserProgress")
    }

    @NSManaged public var coins: Int64
    @NSManaged public var xp: Int64
    @NSManaged public var selectedPetName: String?
    @NSManaged public var petHappiness: Double
    @NSManaged public var petEnergy: Double
    @NSManaged public var petLearningScore: Double
    @NSManaged public var unlockedItems: String?

}

extension UserProgress : Identifiable {

}
