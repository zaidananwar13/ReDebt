//
//  NewTransactionView.swift
//  screen transaction turu app
//
//  Created by Pahala Sihombing on 03/04/23.
//

import SwiftUI
import CoreData

struct NewTransactionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Person.name, ascending: false)], animation: .default)
    private var persons: FetchedResults<Person>
    
    @State private var name: String = ""
    @State private var nominal: String = ""
    @State private var note: String = ""
    @State private var utang = false
    
    @State var bubbleScene: BubblesScene = BubblesScene()
    
    enum Status: String, CaseIterable, Identifiable {
        case iOweYou, youOweMe
        var id: Self { self }
    }
    @State private var selectedStatus: Status = .iOweYou
    
    @State var showExistedNameAlert: Bool = false
    
    let gradientColors = [
        Color(hex: 0xFF7090),
        Color(hex: 0x8FCBFF)
    ]
    
    var body: some View {
        VStack {
            VStack{
//                VStack{
//                    Text("Slide to back to Home")
//                        .padding(.bottom,6)
//                    Image(systemName: "chevron.down")
//                }
//                .padding(.top,25)
//                .padding(.bottom,25)
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
                .padding(.top)
                
                HStack{
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
                
                HStack{
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
                .keyboardType(.numberPad)
                
                HStack{
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
            
            VStack{
                HStack{
                    Text("What are you?")
                        .foregroundColor(.gray)
                    Spacer()
                }
                HStack{
                    Picker("Status", selection: $selectedStatus) {
                        Text("I Owe You \(name)").tag(Status.iOweYou)
                        Text("You Owe Me \(name)").tag(Status.youOweMe)
                    }
                    .accentColor(selectedStatus == Status.iOweYou ? Color(hex: 0xFF7090) : Color(hex: 0x8FCBFF))
                    Spacer()
                }
                Spacer()
            }
            .padding()
            
            Button(action: {
                print("Clicked")
                addPerson()
                
                
            }, label: {
                HStack {
                    Image(systemName: "paperplane.fill")
                    Text("Save")
                }
            })
            .foregroundColor(.white)
            .background(selectedStatus == Status.iOweYou ? Color(hex: 0xFF7090) : Color(hex: 0x8FCBFF))
            .cornerRadius(5)
            .frame(height:25)
            .padding(0)
            .buttonStyle(.bordered)
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
//            let _ = print("ini request: \(request)")
            let predicate = NSPredicate(format: "name == %@", name)
//            let _ = print("ini predicate: \(predicate)")
            request.predicate = predicate
            request.fetchLimit = 1
            
            do{
                let count = try viewContext.count(for: request)
                if(count == 0){
                    print("no matches")
                    let newPerson = Person(context:viewContext)
                    newPerson.id = UUID()
                    newPerson.name = name

                    let _ = print(newPerson)
                    
                    PersistenceController.shared.saveContext()
                    addTransaction(person: newPerson)
                }
                else{
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

}

struct NewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NewTransactionView()
    }
}
