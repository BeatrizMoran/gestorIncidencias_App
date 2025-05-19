//
//  ContentView.swift
//  gestorIncidencias
//
//  Created by  on 5/5/25.
//

import SwiftUI

enum Tab {
    case nueva
    case home
    case resueltas
}

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @State private var isLoggedIn = false
    @StateObject private var authVM = AuthViewModel()

    var body: some View {
        Group {
            if isLoggedIn {
                TabView(selection: $selectedTab) {
                    NuevaIncidenciaView()
                        .tabItem {
                            Label("Nueva", systemImage: "plus.circle.fill")
                        }
                        .tag(Tab.nueva)

                    IncidenciasView(selectedTab: $selectedTab)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .tag(Tab.home)

                    ResueltasView()
                        .tabItem {
                            Label("Resueltas", systemImage: "checkmark.seal.fill")
                        }
                        .tag(Tab.resueltas)
                }
                .tint(.black)
            } else {
                LoginView(onLoginSuccess: {
                    isLoggedIn = true
                }, authVM: authVM)
            }
        }
    }
}
