//
//  DataManager.swift
//  PhoneBookProject
//
//  Created by 박승환 on 7/18/24.
//

import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    
    private let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "PhoneBookProject")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func readAllData() -> [PhoneBook] {
        var list: [PhoneBook] = []
        do {
            let phoneBooks = try context.fetch(PhoneBook.fetchRequest())
            for phoneBook in phoneBooks {
                list.append(phoneBook)
            }
        } catch {
            print("데이터 읽기 실패")
        }
        return list
    }
    
    func createData(image: String, name: String, phoneNumber: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: PhoneBook.className, in: context) else { return }
        let newPhoneBook = NSManagedObject(entity: entity, insertInto: context)
        newPhoneBook.setValue(image, forKey: PhoneBook.Key.image)
        newPhoneBook.setValue(name, forKey: PhoneBook.Key.name)
        newPhoneBook.setValue(phoneNumber, forKey: PhoneBook.Key.phoneNumber)
        save()
    }
    
    func updateData(currentName: String, updateName: String, updatePhoneNumber: String, updateImage: String) {
        let fetchRequest = PhoneBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", currentName)
        do {
            let result = try context.fetch(fetchRequest)
            for data in result as [NSManagedObject] {
                data.setValue(updateName, forKey: PhoneBook.Key.name)
                data.setValue(updatePhoneNumber, forKey: PhoneBook.Key.phoneNumber)
                data.setValue(updateImage, forKey: PhoneBook.Key.image)
            }
            save()
            print("데이터 수정 성공")
        } catch {
            print("데이터 수정 실패")
        }
        
    }
    
    func deleteData(name: String) {
        let fetchRequest = PhoneBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let result = try context.fetch(fetchRequest)
            for data in result as [NSManagedObject] {
                context.delete(data)
            }
            save()
            print("데이터 삭제 성공")
        } catch {
            print("데이터 삭제 실패")
        }
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("데이터 저장 싪패")
            }
        }
    }
}
