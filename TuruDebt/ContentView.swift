//
//  ContentView.swift
//  screen transaction turu app
//
//  Created by Pahala Sihombing on 31/03/23.
//

import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
        VStack {
            HStack{
                Image(systemName: "arrow.left")
                Text("Debt Details")
                    .font(.body)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.horizontal)
            VStack{
                Text("You Owe")
                    .font(.title3)
                    .fontWeight(.regular)
                    .foregroundColor(Color(hex: 0xFF7090))
                    .padding(.top, 22.0)
                Text("Gretchen Mango")
                    .font(.title3)
                    .fontWeight(.regular)
                    .padding(.vertical, 16.0)
                ZStack {
                    Circle()
                        .frame(width: 88.0, height: 88.0)
                        .foregroundColor(Color(hex: 0xFF9BB2))
                    
                    Circle()
                    
                        .frame(width: 60.0, height: 60.0)
                        .foregroundColor(Color(hex: 0xFF7090))
                    Image(systemName: "creditcard.circle.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 34.0, height: 34.0)
                }
                
                Text("Rp. 100.000")
                    .font(.title2)
                    .fontWeight(.regular)
                    .padding(.vertical, 16.0)
                Button(action: {
                    print("clicked")
                        
                }, label: {
                    
                    Text("Settle Your Debt")
                        .fontWeight(.semibold)
                        .font(.headline)
                        .frame(width: 207.0, height:50.0)
                })
                
                .foregroundColor(.white)
                .background(Color(hex: 0xFF7090))
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
                yudaView()
                yudaaView()
                yudaView()
                yudaaView()
            }
            
            .frame(maxWidth: .infinity)
            .listStyle(.inset)
            .scrollContentBackground(.hidden)
            
        }
    }
}


struct yudaView: View {
    var body: some View {
        VStack {
            VStack{
                HStack{
                    Text("Friday, April 7 2023")
                        .fontWeight(.regular)
                        .font(.body)
                    Spacer()
                }
                Spacer()
                HStack{
                    ZStack{
                        Circle()
                            .foregroundColor(Color(hex:0xFFE2E9))
                            .frame(width:42.0,height: 42.0)
                        Image(systemName: "creditcard.fill")
                            .foregroundColor(Color(hex:0xFF7090))
                            .background(Color(hex: 0xFFE2E9))
                    }
                    Text("Cinema Tickets")
                        .fontWeight(.regular)
                        .font(.subheadline)
                    Spacer()
                    Text("- Rp. 100.000")
                        .fontWeight(.regular)
                        .font(.subheadline)
                }
                
            }
            
            .padding(10)
        }
        .listRowSeparator(.hidden)
        .cornerRadius(10.0)
    }
}

struct yudaaView: View {
    var body: some View {
        VStack {
            VStack{
                HStack{
                    Text("Saturday, April 8 2023")
                        .fontWeight(.regular)
                        .font(.body)
                    Spacer()
                }
                Spacer()
                HStack{
                    ZStack{
                        Circle()
                            .foregroundColor(Color(hex:0xE9F5FF))
                            .frame(width:42.0,height: 42.0)
                        Image(systemName: "creditcard.fill")
                            .foregroundColor(Color(hex:0x8FCBFF))
                            .background(Color(hex: 0xE9F5FF))
                    }
                    Text("Cinema Tickets")
                        .fontWeight(.regular)
                        .font(.subheadline)
                    Spacer()
                    Text("+ Rp. 25.000")
                        .fontWeight(.regular)
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
                
            }
            
            .padding(10)
        }
        .listRowSeparator(.hidden)
        .cornerRadius(10.0)
    }
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
