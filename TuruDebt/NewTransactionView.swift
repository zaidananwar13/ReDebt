//
//  NewTransactionView.swift
//  screen transaction turu app
//
//  Created by Pahala Sihombing on 03/04/23.
//

import SwiftUI

struct NewTransactionView: View {
<<<<<<< Updated upstream
=======
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Person.name, ascending: false)], animation: .default)
    private var persons: FetchedResults<Person>
>>>>>>> Stashed changes
    @State private var name: String = ""
    @State private var nominal: String = ""
    @State private var note: String = ""
    @State private var utang = false
<<<<<<< Updated upstream
    
    let defaults = UserDefaults.standard
    
    
    func saveNama(name: String){
        defaults.set(name, forKey: "Nama")
        
    }
    
    
=======
    @State var bubbleScene: BubblesScene = BubblesScene()

>>>>>>> Stashed changes
    enum Status: String, CaseIterable, Identifiable {
        case iOweYou, youOweMe
        var id: Self { self }
    }
<<<<<<< Updated upstream
    
    @State private var selectedStatus: Status = .iOweYou
    
=======

    @State private var selectedStatus: Status = .iOweYou
    @State var showExistedNameAlert: Bool = false
>>>>>>> Stashed changes
    let gradientColors = [
        Color(hex: 0xFF7090),
        Color(hex: 0x8FCBFF)
    ]

    var body: some View {
        VStack {
<<<<<<< Updated upstream
            VStack{
                VStack{
                    Text("Slide to back to Home")
                        .padding(.bottom,6)
                    Image(systemName: "chevron.down")
                }
                .padding(.top,25)
                .padding(.bottom,25)
=======
            VStack {
>>>>>>> Stashed changes
                HStack {
                    Text("Fill")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor( selectedStatus == Status.iOweYou ? Color(hex: 0xFF7090) : Color(hex: 0x8FCBFF))
                    Text("the Form")
                        .font(.title)
                        .fontWeight(.semibold)
                }
                .padding(.bottom, 30)
<<<<<<< Updated upstream
                HStack{
=======
                .padding(.top)

                HStack {
>>>>>>> Stashed changes
                    Text("Name")
                        .foregroundColor(.gray)
                    Spacer()
                }
                TextField(
                    "Write your name",
                    text: $name
                )
                
                .frame(height: 41)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 4, x: 2, y: 2)
                .padding(.bottom, 24.0)

                HStack {
                    Text("Nominal")
                        .foregroundColor(.gray)
                    Spacer()
                }
                TextField(
                    "Nominal transaction",
                    text: $nominal
                )
                .frame(height: 41)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 4, x: 2, y: 2)
                
                .padding(.bottom, 24.0)
<<<<<<< Updated upstream
                
                HStack{
=======
                .keyboardType(.numberPad)

                HStack {
>>>>>>> Stashed changes
                    Text("Note")
                        .foregroundColor(.gray)
                    Spacer()
                }
                TextField(
                    "Reason",
                    text: $note
                )
                .frame(height: 41)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 4, x: 2, y: 2)
                .padding(.bottom, 24.0)
            }
            .padding(.horizontal)

            VStack {
                HStack {
                    Text("What are you?")
                        .foregroundColor(.gray)
                    Spacer()
                }
                HStack {
                    Picker("Status", selection: $selectedStatus) {
                        Text("I Owe You \(name)").tag(Status.iOweYou)
                        Text("You Owe Me \(name)").tag(Status.youOweMe)                       
                    }
                    .accentColor(selectedStatus == Status.iOweYou ? Color(hex: 0xFF7090) : Color(hex: 0x8FCBFF))
                    Spacer()
                }
                
                Spacer()
            }
<<<<<<< Updated upstream
            
            .padding()
            Text(defaults.string(forKey: "Nama") ?? "")
            Spacer(minLength:10)
            Button(action: {
                print("Clicked")
                saveNama(name:name)
=======
            .padding()
            Button(action: {
                print("Clicked")
                addPerson()
>>>>>>> Stashed changes
            }, label: {
                HStack {
                    
                    Image(systemName: "paperplane.fill")
                    
                    Text("Save")
                }
            })
            .foregroundColor(.white)
            .background(selectedStatus == Status.iOweYou ? Color(hex: 0xFF7090) : Color(hex: 0x8FCBFF))
            .cornerRadius(5)
            .frame(height: 25)
            .padding(0)
            .buttonStyle(.bordered)
<<<<<<< Updated upstream
        }
    }
=======
            .disabled(self.nominal.isEmpty)
        }
        .alert("Name Already Exist.", isPresented: $showExistedNameAlert) {
            Button("OK", role: .cancel) {}
        }
    }
    private func addPerson() {
        withAnimation {
            // Search name is already exist or not
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            let predicate = NSPredicate(format: "name == %@", name)
            request.predicate = predicate
            request.fetchLimit = 1

            do {
                let count = try viewContext.count(for: request)
                if(count == 0){
                    print("no matches")
                    let newPerson = Person(context: viewContext)
                    newPerson.id = UUID()
                    newPerson.name = name

                    let _ = print(newPerson)
                    PersistenceController.shared.saveContext()
                    addTransaction(person: newPerson)
                }else {
                    print("match found")
                    showExistedNameAlert.toggle()
                }
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
    }

    private func addTransaction(person: Person) {
        withAnimation {
            let newTransaction = Transaction(context: viewContext)
            newTransaction.date = Date()
            newTransaction.note = note
            if selectedStatus == Status.iOweYou {
                newTransaction.nominal = 0 - (Double(nominal)!)
            } else {
                newTransaction.nominal = Double(nominal)!
            }
            person.totalDebt = newTransaction.nominal
            person.addToTransactions(newTransaction)
            PersistenceController.shared.saveContext()
            let _ = print(newTransaction)
            dismiss()
        }
    }
>>>>>>> Stashed changes
}

struct NewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NewTransactionView()
    }
}
