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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
