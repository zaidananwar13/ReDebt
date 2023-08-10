//
//  DetailView.swift
//  TuruDebt
//
//  Created by Fuad Fadlila Surenggana on 16/04/23.
//

import Foundation

//
//  ContentView.swift
//  screen transaction turu app
//
//  Created by Pahala Sihombing on 31/03/23.
//

import SwiftUI

struct DetailView: View {
    @Binding var targetPerson: String
    @Binding var onClose: Bool
    
    @State var showingAddview: Bool = false
    
    var body: some View {
        DynamicFetchView(predicate: NSPredicate(format: "name == %@", targetPerson), sortDescriptors: []) { (persons: FetchedResults<Person>) in
            ForEach(persons, id: \.self) { person in
                VStack {
                    //            HStack{
                    //                Image(systemName: "arrow.left")
                    //                Text("Debt Details")
                    //                    .font(.body)
                    //                    .fontWeight(.bold)
                    //                Spacer()
                    //            }
                    //            .padding(.horizontal)
                    
                    VStack{
                        Text("\(person.totalDebt < 0 ? "You Owe" : "Owes You")")
                            .font(.title3)
                            .fontWeight(.regular)
                            .foregroundColor(person.totalDebt < 0 ? Color(hex:0xFF7090) : Color(hex:0x8FCBFF))
        //                    .padding(.top, 22.0)
                        Text("\(person.name!)")
                            .font(.title3)
                            .fontWeight(.regular)
                            .padding(.vertical, 16.0)
                        ZStack {
                            Circle()
                                .frame(width: 88.0, height: 88.0)
                                .foregroundColor(person.totalDebt < 0 ? Color(hex:0xFF9BB2) : Color(hex:0xB1DBFF))
                            Circle()
                                .frame(width: 60.0, height: 60.0)
                                .foregroundColor(person.totalDebt < 0 ? Color(hex:0xFF7090) : Color(hex:0x8FCBFF))
                            Image(systemName: "creditcard.circle.fill")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 34.0, height: 34.0)
                        }
                        
                        Text("Rp. \(Int(person.totalDebt))")
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
                        .background(person.totalDebt < 0 ? Color(hex:0xFF7090) : Color(hex:0x8FCBFF))
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
//                        .onDelete(perform: deleteTransaction)
                    }
                    
                    .frame(maxWidth: .infinity)
                    .listStyle(.inset)
                    .scrollContentBackground(.hidden)
                    
                }
                .navigationBarHidden(false)
                .sheet(isPresented: $showingAddview) {
                    SettleDebt2(targetPerson: $targetPerson)
                        .presentationDetents([.fraction(0.7)])

                }
            }
        }
    }
}
