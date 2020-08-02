//
//  Currencies+CoreDataProperties.swift
//  TrackYourFinances
//
//  Created by Kapitan Kanapka on 18.07.2020.
//  Copyright © 2020 hippo. All rights reserved.
//
//

import Foundation
import CoreData


extension Currencies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currencies> {
        return NSFetchRequest<Currencies>(entityName: "Currencies")
    }

    @NSManaged public var currencyName: String?
    @NSManaged public var currencySymbol: String?

}
