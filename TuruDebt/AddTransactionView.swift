//
//  AddTransactionView.swift
//  uTang
//
//  Created by Fuad Fadlila Surenggana on 09/04/23.
//

import SwiftUI

struct AddTransactionView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @StateObject var person: Person
    
    @State private var note = ""
    @State private var nominal = ""
//    @State private var nominal: Double = 0
    
    var status = ["Mengutang", "Memberi hutang"]
    @State private var selectedStatus = "Mengutang"
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Transaction Note", text: $note)
                    TextField("Nominal", text: $nominal)
                        .keyboardType(.numberPad)
    //                VStack {
    //                    Text("Nominal: \(Int(nominal))")
    //                    Slider(value: $nominal, in: 0...1000, step: 10)
    //                }
                    
                    Picker("Which one are you", selection: $selectedStatus) {
                        ForEach(status, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Button("Submit") {
                            addTransaction()
                            dismiss()
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add Transaction").font(.headline)
                }
            }

        }
        
    }
    
    private func addTransaction() {
        
        withAnimation {
            let newTransaction = Transaction(context: viewContext)
            newTransaction.date = Date()
            newTransaction.note = note
            if selectedStatus == "Mengutang" {
                newTransaction.nominal = 0 - (Double(nominal)!)
            } else {
                newTransaction.nominal = Double(nominal)!
            }
//            newTransaction.nominal = Double(nominal)!
            
            person.addToTransactions(newTransaction)
            PersistenceController.shared.saveContext()
        }
    }
}

//struct AddTransactionView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddTransactionView()
//    }
//}
