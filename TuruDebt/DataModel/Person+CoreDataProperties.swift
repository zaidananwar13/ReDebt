//
//  Person+CoreDataProperties.swift
//  uTang
//
//  Created by Fuad Fadlila Surenggana on 09/04/23.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var totalDebt: Double
    @NSManaged public var id: UUID?
    @NSManaged public var transactions: NSSet?
    
    public var unwrappedName: String {
        name ?? "Unknown Name"
    }
    
    public var transactionsArray: [Transaction] {
        let transactionSet = transactions as? Set<Transaction> ?? []
        
        return transactionSet.sorted {
            $1.unwrappedDate < $0.unwrappedDate
        }
    }

}

// MARK: Generated accessors for transactions
extension Person {

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSSet)

}

extension Person : Identifiable {

}
