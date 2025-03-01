//
//  ContentView.swift
//  fitness-tracker
//
//  Created by Noah Sterner on 2025-02-06.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        
        TabView {
            
            LogSessionPage()
            .tabItem{
                Image(systemName: "plus.circle")
                Text("Add Workout")
            }
            
            HistoryPage()
            .tabItem{
                Image(systemName: "clock")
                Text("History")
            }
            
        }
        .tint(colorScheme == .light ? .Primary : .primary70)
        .onAppear(perform: {
            UITabBar.appearance().unselectedItemTintColor = colorScheme == .light ? .primary15 : .primary90
            
            UITabBar.appearance().backgroundColor = .surfaceContainer.withAlphaComponent(1)
        })
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}
