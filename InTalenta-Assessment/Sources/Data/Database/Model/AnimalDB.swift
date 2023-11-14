//
//  AnimalDB.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 13/11/23.
//

import Foundation
import CoreData

@objc(AnimalDB)
public class AnimalDB: NSManagedObject {

}

extension AnimalDB {
    @NSManaged public var category: String?
    @NSManaged public var name: String?
    @NSManaged public var photoID: String?
    @NSManaged public var photoThumbnail: String?
    @NSManaged public var photoOriginal: String?
}

extension AnimalDB: Identifiable {

}

struct AnimalDBModel: Equatable {
    var category: String?
    var name: String?
    var photoID: String?
    var photoThumbnail: String?
    var photoOriginal: String?
    
    init(db: AnimalDB) {
        self.category = db.category
        self.name = db.name
        self.photoID = db.photoID
        self.photoThumbnail = db.photoThumbnail
        self.photoOriginal = db.photoOriginal
    }
}

public extension NSManagedObject {
    convenience init(using usedContext: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: usedContext)!
        self.init(entity: entity, insertInto: usedContext)
    }
}
