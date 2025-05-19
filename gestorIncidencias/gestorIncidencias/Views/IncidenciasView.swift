//
//  IncidenciasView.swift
//  gestorIncidencias
//
//  Created by  on 19/5/25.
//

import SwiftUI

struct IncidenciasView: View {
    @Binding var selectedTab: Tab
    @State private var mostrarNotificaciones = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "bolt.horizontal.circle")
                        .resizable()
                        .foregroundStyle(Color.white)
                        .scaledToFit()
                        .frame(height: 50)
                        .cornerRadius(10)
                        .padding(.bottom, 8)

                    Text("Incidencias")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .font(.system(size: 26, weight: .bold))
                        .padding()
                        .cornerRadius(10)

                    Spacer()

                    Button(action: {
                        mostrarNotificaciones = true
                    }) {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .foregroundStyle(Color.white)
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .padding(.trailing, 4)
                    }
                }
                .padding()
                .background(Color.black)

                Spacer()
            }
            .navigationDestination(isPresented: $mostrarNotificaciones) {
                NotificacionesView()
            }
            .onChange(of: selectedTab) { newValue in
                if newValue == .home {
                    mostrarNotificaciones = false // reset al volver a Home
                }
            }
        }
    }
}
