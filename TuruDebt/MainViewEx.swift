//
//  ContentView.swift
//  uTang
//
//  Created by Fuad Fadlila Surenggana on 08/04/23.
//

import SwiftUI

struct MainViewEx: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Person.name, ascending: false)], animation: .default)
    private var persons: FetchedResults<Person>
    
    @State private var personName: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                    }, label: {
                        NavigationLink(destination: NewTransactionView()) {
                             Text("New Transaction")
                         }
                    })
                    TextField("Person Name", text: $personName)
                        .textFieldStyle(.roundedBorder)
                    Button(action: addPerson) {
                        Label("", systemImage: "plus")
                    }
                }
                .padding()
                List {
                    ForEach(persons) { person in
                        NavigationLink(destination: DetailTransactionView(person: person)) {
                            HStack {
                                Text(person.name ?? "")
                                Spacer()
                                Text("Rp. \(Int(person.totalDebt)) ,-")
                                    .foregroundColor(person.totalDebt < 0 ? Color.red : Color.black)
                                    .italic()
                            }
                        }
                    }
                    .onDelete(perform: deletePerson)
                }
            }
//            .navigationTitle("Person")
        }
        
    }
    
    private func addPerson() {
        withAnimation {
            let newPerson = Person(context:viewContext)
            newPerson.id = UUID()
            newPerson.name = personName
            
            PersistenceController.shared.saveContext()
            
        }
    }
    
    func deletePerson(offsets: IndexSet) {
        withAnimation {
            offsets.map { persons[$0] }.forEach(viewContext.delete)
            
            PersistenceController.shared.saveContext()
        }
    }
}

struct ContentViews_Previews: PreviewProvider {
    static var previews: some View {
        MainViewEx()
    }
}
