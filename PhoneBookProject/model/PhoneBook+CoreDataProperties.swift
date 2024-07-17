//
//  PhoneBook+CoreDataProperties.swift
//  PhoneBookProject
//
//  Created by 박승환 on 7/12/24.
//
//

import Foundation
import CoreData


extension PhoneBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhoneBook> {
        return NSFetchRequest<PhoneBook>(entityName: "PhoneBook")
    }

    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    
}

extension PhoneBook : Identifiable {

}
