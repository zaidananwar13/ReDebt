//
//  TuruDebtApp.swift
//  TuruDebt
//
//  Created by Zaidan Anwar on 31/03/23.
//

import SwiftUI

@main
struct TuruDebtApp: App {
<<<<<<< Updated upstream
    var body: some Scene {
        WindowGroup {
            ContentView()
=======
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
>>>>>>> Stashed changes
        }
    }
}
