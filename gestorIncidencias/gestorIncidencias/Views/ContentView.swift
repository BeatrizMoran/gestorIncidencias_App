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
    @StateObject private var actualizarVM: ActualizarIncidenciaViewModel
    @StateObject private var  notificacionesVM: NotificacionesListViewModel
    


    init() {

        let auth = AuthViewModel()
        _authVM = StateObject(wrappedValue: auth)


        _incidenciaVM = StateObject(wrappedValue: IncidenciaListViewModel(auth: auth))
       
        _actualizarVM = StateObject(wrappedValue: ActualizarIncidenciaViewModel(authViewModel: auth))
        _notificacionesVM = StateObject(
            wrappedValue: NotificacionesListViewModel(auth: auth)
        )
    }


    var body: some View {
        Group {
            if authVM.isAuthenticated {
                TabView(selection: $selectedTab) {
                    NuevaIncidenciaView(viewModel: NuevaIncidenciaViewModel(authViewModel: authVM), selectedTab: $selectedTab)
                        .tabItem {
                            Label("Nueva", systemImage: "plus.circle.fill")
                        }
                        .tag(Tab.nueva)


                    IncidenciasView(
                        selectedTab: $selectedTab,
                        authVM: authVM,
                        viewModel: incidenciaVM,
                        actualizarViewModel: actualizarVM,
                        notificacionesViewModel: notificacionesVM
                    )
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
                                        
                }, authVM: authVM)
            }
        }
    }
}



