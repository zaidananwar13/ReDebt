//
//  TuruDebtApp.swift
//  TuruDebt
//
//  Created by Zaidan Anwar on 31/03/23.
//

import SwiftUI

@main
struct TuruDebtApp: App {
    
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
//            MainViewEx()
            MainView()
//            NewTransactionView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
        }
    }
}
