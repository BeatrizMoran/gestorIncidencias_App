//
//  IncidenciasView.swift
//  gestorIncidencias
//
//  Created by  on 19/5/25.
//

import SwiftUI

struct IncidenciasView: View {
    @Binding var selectedTab: Tab
    @ObservedObject var authVM: AuthViewModel
    @ObservedObject var viewModel: IncidenciaListViewModel
    @ObservedObject var actualizarViewModel: ActualizarIncidenciaViewModel
    @ObservedObject var notificacionesViewModel: NotificacionesListViewModel
    @State private var mostrarNotificaciones = false
    @State private var incidenciaSeleccionada: Incidencia? = nil
    @State private var mostrarDetalle = false
    @State private var estadoSeleccionado: String = "pendiente"
    let estadosDisponibles = ["pendiente", "en_proceso", "resuelta", "cancelada"]

    var body: some View {
        ZStack {
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
                        
                        Button(action: {
                            
                            authVM.logout()
                            
                        }) {
                            Image(systemName: "return.left")
                                .resizable()
                                .foregroundStyle(Color.white)
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .padding(.trailing, 4)
                        }
                        
                    }
                    .padding()
                    .background(Color.black)

                    let noResueltas = viewModel.incidencias.filter { $0.estado != "resuelta" }

                    List(noResueltas) { incidencia in
                        HStack(spacing: 16) {
                            VStack(alignment: .leading) {
                                Text(incidencia.descripcion)
                                    .font(.headline)

                                Text(incidencia.ubicacion)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            incidenciaSeleccionada = incidencia
                            withAnimation {
                                mostrarDetalle = true
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .refreshable {
                        
                        viewModel.refetch()
                    }
                }
                .navigationDestination(isPresented: $mostrarNotificaciones) {
                    NotificacionesView(
                        selectedTab: $selectedTab,
                        viewModel: notificacionesViewModel
                    )
                }
                .onChange(of: selectedTab) { oldValue, newValue in
                    if newValue == .home {
                        mostrarNotificaciones = false
                    }
                }
            }
            .blur(radius: mostrarDetalle ? 5 : 0)

            if let incidencia = incidenciaSeleccionada, mostrarDetalle {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            mostrarDetalle = false
                        }
                    }

                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                mostrarDetalle = false
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                    }

                    Text("Descripción")
                        .font(.headline)
                    Text(incidencia.descripcion)
                        .font(.body)

                    Text("Ubicación")
                        .font(.headline)
                    Text(incidencia.ubicacion)
                        .font(.body)
                    
                    Text("Urgencia")
                        .font(.headline)
                    Text(incidencia.urgencia)
                        .font(.body)
                    
                    Text(incidencia.estado)

                    Text("Estado")
                        .font(.headline)

                    Picker("Estado", selection: $estadoSeleccionado) {
                        ForEach(estadosDisponibles, id: \.self) { estado in
                            Text(estado.capitalized.replacingOccurrences(of: "_", with: " "))
                                .tag(estado)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    //MOSTRAR COMENTARIOS
                    Text("Comentarios")
                        .font(.headline)

                    if incidencia.comentarios.isEmpty {
                        Text("Sin comentarios.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else {
                        ForEach(incidencia.comentarios) { comentario in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("• \(comentario.texto)")
                                    .font(.body)
                                Text("Creado: \(comentario.createdAt)")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            .padding(.bottom, 6)
                        }
                    }


                    Spacer()

                    Button(action: {
                        actualizarViewModel.actualizarIncidencia(incidencia: incidencia, nuevoEstado: estadoSeleccionado) {
                            viewModel.refetch() 
                            incidenciaSeleccionada = nil
                            withAnimation {
                                mostrarDetalle = false
                            }
                        }
                    }) {
                        Text("Actualizar estado")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }

                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 20)
                .padding(40)
                .transition(.scale)
            }
        }
        .onChange(of: incidenciaSeleccionada) {
            if let incidencia = incidenciaSeleccionada {
                estadoSeleccionado = incidencia.estado
            }
        }
        .onChange(of: selectedTab) { _, newValue in
            if newValue == .home {
                mostrarNotificaciones = false
                viewModel.refetch()
            }
        }
    }
}
