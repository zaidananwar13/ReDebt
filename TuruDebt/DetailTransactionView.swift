//
//  ContentView.swift
//  screen transaction turu app
//
//  Created by Pahala Sihombing on 31/03/23.
//

import SwiftUI

struct DetailTransactionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var person: Person
    @State var showingAddview: Bool = false
    
    var body: some View {
        VStack {
            VStack{
                Text("\(debtCondition())")
                    .font(.title3)
                    .fontWeight(.regular)
                    .foregroundColor(totalDebt() < 0 ? Color(hex:0xFF7090) : Color(hex:0x8FCBFF))
//                    .padding(.top, 22.0)
                Text("\(person.name!)")
                    .font(.title3)
                    .fontWeight(.regular)
                    .padding(.vertical, 16.0)
                ZStack {
                    Circle()
                        .frame(width: 88.0, height: 88.0)
                        .foregroundColor(totalDebt() < 0 ? Color(hex:0xFF9BB2) : Color(hex:0xB1DBFF))
                    Circle()
                        .frame(width: 60.0, height: 60.0)
                        .foregroundColor(totalDebt() < 0 ? Color(hex:0xFF7090) : Color(hex:0x8FCBFF))
                    Image(systemName: "creditcard.circle.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 34.0, height: 34.0)
                }
                
                Text("Rp. \(Int(totalDebt()))")
                    .font(.title2)
                    .fontWeight(.regular)
                    .padding(.vertical, 16.0)
                Button(action: {
                    print("clicked")
                    showingAddview.toggle()
                        
                }, label: {
                    
                    Text("Settle Your Debt")
                        .fontWeight(.semibold)
                        .font(.headline)
                        .frame(width: 207.0, height:50.0)
                })
                
                .foregroundColor(.white)
                .background(totalDebt() < 0 ? Color(hex:0xFF7090) : Color(hex:0x8FCBFF))
                .cornerRadius(14)
                .buttonStyle(.bordered)
                .padding(.bottom, 24.0)
            }
            HStack{
                Text("Debt History")
                    .fontWeight(.semibold)
                    .font(.headline)
                Spacer()
                
            }
        
            .padding(.horizontal)
            Divider()
            List {
                ForEach(person.transactionsArray) { transaction in
                    VStack {
                        VStack{
                            HStack{
                                Text("\(transaction.unwrappedDate.formatted(.dateTime.weekday(.wide).day().month(.wide).year()))")
                                    .fontWeight(.regular)
                                    .font(.body)
                                Spacer()
                            }
                            Spacer()
                            HStack{
                                ZStack{
                                    Circle()
                                        .foregroundColor(transaction.unwrappedNominal < 0 ? Color(hex:0xFFE2E9) :  Color(hex:0xE9F5FF))
                                        .frame(width:42.0,height: 42.0)
                                    Image(systemName: "creditcard.fill")
                                        .foregroundColor(transaction.unwrappedNominal < 0 ? Color(hex:0xFF7090) : Color(hex:0x8FCBFF))
                                        .background(transaction.unwrappedNominal < 0 ? Color(hex:0xFFE2E9) :  Color(hex:0xE9F5FF))
                                }
                                Text(transaction.unwrappedNote)
                                    .fontWeight(.regular)
                                    .font(.subheadline)
                                Spacer()
                                Text("Rp. \(Int(transaction.unwrappedNominal))")
                                    .fontWeight(.regular)
                                    .font(.subheadline)
                                    .foregroundColor(transaction.unwrappedNominal < 0 ? Color.black : Color.green)
                            }
                            
                        }
                        
                        .padding(10)
                    }
                    .listRowSeparator(.hidden)
                    .cornerRadius(10.0)
                    
                }
                .onDelete(perform: deleteTransaction)
            }
            
            .frame(maxWidth: .infinity)
            .listStyle(.inset)
            .scrollContentBackground(.hidden)
            
        }
        .navigationBarHidden(false)
        .sheet(isPresented: $showingAddview) {
            SettleDebt(person: person)
                .presentationDetents([.fraction(0.7)])
                
        }
    }
    
    func debtCondition() -> String {
        if totalDebt() < 0 {
            return "You Owe"
        }
        else {
            return "Owes You"
        }
    }
    
    func totalDebt() -> Double {
        var debt: Double = 0
        for item in person.transactionsArray {
            debt += item.unwrappedNominal
        }
        return debt
    }
    
    func deleteTransaction(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let transaction = person.transactionsArray[index]
                viewContext.delete(transaction)
                PersistenceController.shared.saveContext()
            }
        }
    }
}

//extension Color {
//    init(hex: UInt, alpha: Double = 1) {
//        self.init(
//            .sRGB,
//            red: Double((hex >> 16) & 0xff) / 255,
//            green: Double((hex >> 08) & 0xff) / 255,
//            blue: Double((hex >> 00) & 0xff) / 255,
//            opacity: alpha
//        )
//    }
//}

struct DetailTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        let newPerson = Person(context: viewContext)
        newPerson.name = "Fuad"

        let trans1 = Transaction(context: viewContext)

        trans1.note = "Cinema Tickets"
        trans1.nominal = -25000

        let trans2 = Transaction(context: viewContext)

        trans2.note = "Woz"
        trans2.nominal = -10
        
        let trans3 = Transaction(context: viewContext)

        trans3.note = "Woz"
        trans3.nominal = 10

        newPerson.addToTransactions(trans2)
        newPerson.addToTransactions(trans3)
        newPerson.addToTransactions(trans1)
        

        return DetailTransactionView(person: newPerson)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
