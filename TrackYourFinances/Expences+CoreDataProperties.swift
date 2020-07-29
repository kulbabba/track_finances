//
//  Expences+CoreDataProperties.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 16.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//
//

import Foundation
import CoreData


extension Expences {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expences> {
        return NSFetchRequest<Expences>(entityName: "Expences")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Int32
    @NSManaged public var epenceDate: Date?
    @NSManaged public var expenceCurrency: String?
    @NSManaged public var category: Categories?

}
