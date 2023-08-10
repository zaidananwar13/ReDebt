//
//  ContentView.swift
//  TuruDebt
//
//  Created by Zaidan Anwar on 31/03/23.
//

import SwiftUI

struct DataItem: Identifiable {
    var id = UUID()
    var title: String
    var size: CGFloat
    var color: Color
    var offset = CGSize.zero
}

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Person.name, ascending: false)], animation: .default)
    private var persons: FetchedResults<Person>
    
    @State private var selectedName: String = ""
    @State private var onDetailView: Bool = false
    @State private var onFirstTime: Bool = false
//    @State private var data: [DataItem] = [
//        DataItem(title: "Ahmad", size: 81, color: .blue),
//        DataItem(title: "Bagas", size: 61, color: .blue),
//    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                BubbleView(onFirstTimeView: $onFirstTime, onSelectedBubble: $onDetailView, selectedName: $selectedName)
                    .navigationDestination(
                        isPresented: $onDetailView) {
                            DetailView(targetPerson: $selectedName, onClose: $onDetailView)
                            Text("")
                                .hidden()
                        }
            }
        }
    }
    
//    func saveDataitem () -> [DataItem] {
//        for person in persons {
//            data.append(DataItem(title: person.name!, size: 81, color: person.totalDebt < 0 ? Color(hex:0xFF7090) : Color(hex:0x8FCBFF)))
//            let _ = print("person: \(persons.count)")
//            let _ = print("data: \(data)")
//        }
//
//        return data
//    }
//    
//    func fetchBubbleData() {
//        data.removeAll()
//
//        for person in persons {
//            data.append(DataItem(title: person.name ?? "no name", size: 80, color: person.totalDebt < 0 ? Color(hex:0xFF7090) : Color(hex:0x8FCBFF)))
//        }
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
