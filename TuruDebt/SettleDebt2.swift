//
//  SettleDebt2.swift
//  TuruDebt
//
//  Created by Fuad Fadlila Surenggana on 16/04/23.
//

import SwiftUI
import CoreData

struct SettleDebt2: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @Binding var targetPerson: String
    
//    @StateObject var person: Person
    
    @State var nominal: String = ""
    @State var note: String = ""
    @State var showSettleDebt : Bool =  false
    
    enum Status: String, CaseIterable, Identifiable {
        case pay, addMore
        var id: Self { self }
    }
    @State private var settleSelectedStatus: Status = .pay
    
    var body: some View {
        DynamicFetchView(predicate: NSPredicate(format: "name == %@", targetPerson), sortDescriptors: []) { (persons: FetchedResults<Person>) in
            ForEach(persons, id: \.self) { person in
                NavigationView{
                    ZStack {
                        VStack{
                            Image("Brazuca Browsing")
                                .padding(.init(top: -80, leading: 150, bottom: 250, trailing: 0))
                        }
                        
                        VStack {
                            //                VStack{
                            //                    Button(action: {
                            //                        showSettleDebt.toggle()
                            //                        dismiss()
                            //                    }, label: {
                            //                        Image(systemName: "xmark.circle")
                            //                            .foregroundColor(Color(red: 0.9607843137254902, green: 0.4745098039215686, blue: 0.5686274509803921))
                            //                            .font(.largeTitle)
                            //                            .padding(.init(top: 0, leading: 310, bottom: 0, trailing: 0))
                            //                    })
                            //                }
                            
                            //                HStack{
                            //                    Text("\(person.name!)")
                            //                        .font(.title)
                            //                    Spacer()
                            //                }
                            //                .padding(.bottom)
                            
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
                            
                            VStack{
                                HStack{
                                    Text("What are you?")
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                                HStack{
                                    Picker("Status", selection: $settleSelectedStatus) {
                                        Text("Pay Debt").tag(Status.pay)
                                        Text("Add more Debt").tag(Status.addMore)
                                    }
                                    .accentColor(settleSelectedStatus == Status.addMore ? Color(hex: 0xFF7090) : Color(hex: 0x8FCBFF))
                                    Spacer()
                                }
                            }
                            .padding()
                            
                            Button(action: {
                                print("Clicked")
                                addTransaction(person: person)
                                dismiss()
                            }, label: {
                                HStack {
                                    Image(systemName: "paperplane.fill")
                                    Text("Settle")
                                }
                            })
                            .foregroundColor(.white)
                            .background(settleSelectedStatus == Status.addMore ? Color(hex: 0xFF7090) : Color(hex: 0x8FCBFF))
                            .cornerRadius(5)
                            .frame(height:25)
                            .padding(0)
                            .buttonStyle(.bordered)
                            .disabled(self.nominal.isEmpty)
                            
                            .navigationTitle("Settle Debt")
                            .navigationBarItems(trailing: Button("Dismiss", action: {
                                self.dismiss()
                            }))
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    private func addTransaction(person: Person) {
        let newTransaction = Transaction(context: viewContext)
        newTransaction.date = Date()
        newTransaction.note = note
        if settleSelectedStatus == Status.addMore {
            newTransaction.nominal = 0 - (Double(nominal)!)
        } else {
            newTransaction.nominal = Double(nominal)!
        }
        
        person.totalDebt = totalDebt(transaction: person.transactionsArray) + newTransaction.nominal
        person.addToTransactions(newTransaction)
        
        PersistenceController.shared.saveContext()
    }
    
    func totalDebt(transaction: [Transaction]) -> Double {
        var debt: Double = 0
        for item in transaction {
            debt += item.unwrappedNominal
        }
        return debt
    }
}
//struct SettleDebt2_Previews: PreviewProvider {
//    static var previews: some View {
//        SettleDebt2()
//    }
//}

