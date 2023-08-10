//
//  FetchPerson.swift
//  TuruDebt
//
//  Created by Zaidan Anwar on 17/04/23.
//

import SwiftUI

struct FetchPerson: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Person.name, ascending: false)], animation: .default)
    var persons: FetchedResults<Person>
    
    var body: some View {
        let _ = print("aaaa \(persons.count)")
    }
}

struct FetchPerson_Previews: PreviewProvider {
    static var previews: some View {
        FetchPerson()
    }
}
