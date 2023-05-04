////
////  WorkspaceDataClass.swift
////  PostmanApp
////
////  Created by Pranav Singhal on 21/04/23.
////
//
//import Foundation
//import CoreData
//
//final class WorkspaceEntity: NSManagedObject, Identifiable {
//    @NSManaged var id:String;
//    @NSManaged var name:String;
//    
//    override func awakeFromInsert() {
//        super.awakeFromInsert()
//        
//        setPrimitiveValue("0", forKey: "id")
//        setPrimitiveValue("0", forKey: "name")
//    }
//}
