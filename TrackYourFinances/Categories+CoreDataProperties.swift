//
//  Categories+CoreDataProperties.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 07.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//
//

import Foundation
import CoreData


extension Categories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Categories> {
        return NSFetchRequest<Categories>(entityName: "Categories")
    }

    @NSManaged public var categoryName: String?
    //@NSManaged public var expence: NSSet?
    @NSManaged public var expence: Set<Expences>
    

}

// MARK: Generated accessors for expence
extension Categories {

    @objc(addExpenceObject:)
    @NSManaged public func addToExpence(_ value: Expences)

    @objc(removeExpenceObject:)
    @NSManaged public func removeFromExpence(_ value: Expences)

    @objc(addExpence:)
    @NSManaged public func addToExpence(_ values: NSSet)

    @objc(removeExpence:)
    @NSManaged public func removeFromExpence(_ values: NSSet)

}
