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

    @StateObject private var authVM: AuthViewModel
    @StateObject private var incidenciaVM: IncidenciaListViewModel

    init() {
        // Crear el ViewModel de autenticación
        let auth = AuthViewModel()
        _authVM = StateObject(wrappedValue: auth)

        // Crear el ViewModel de incidencias con la misma instancia de auth
        _incidenciaVM = StateObject(wrappedValue: IncidenciaListViewModel(auth: auth))
    }

    var body: some View {
        Group {
            if isLoggedIn {
                TabView(selection: $selectedTab) {
                    NuevaIncidenciaView()
                        .tabItem {
                            Label("Nueva", systemImage: "plus.circle.fill")
                        }
                        .tag(Tab.nueva)

                    IncidenciasView(selectedTab: $selectedTab, viewModel: incidenciaVM)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .tag(Tab.home)

                    ResueltasView(viewModel: incidenciaVM)
                        .tabItem {
                            Label("Resueltas", systemImage: "checkmark.seal.fill")
                        }
                        .tag(Tab.resueltas)
                }
                .tint(.black)
            } else {
                LoginView(onLoginSuccess: {
                    isLoggedIn = true
                    // No hace falta volver a crear el ViewModel aquí
                }, authVM: authVM)
            }
        }
    }
}
