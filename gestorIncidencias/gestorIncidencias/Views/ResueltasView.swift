//
//  ResueltasView.swift
//  gestorIncidencias
//
//  Created by  on 19/5/25.
//

import SwiftUI

struct ResueltasView: View {
    
    @ObservedObject var viewModel: IncidenciaListViewModel
    @State private var incidenciaSeleccionada: Incidencia? = nil
    @State private var mostrarDetalle = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image(systemName: "bolt.badge.checkmark.fill")
                        .resizable()
                        .foregroundStyle(Color.white)
                        .scaledToFit()
                        .frame(height: 50)
                        .cornerRadius(10)
                        .padding(.bottom, 8)

                    Text("Incidencias Resueltas")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .font(.system(size: 26, weight: .bold))
                        .padding()
                        .cornerRadius(10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.black)
                
                NavigationStack {
                    let resueltas = viewModel.incidencias.filter { $0.estado == "resuelta" }

                    List(resueltas) { incidencia in
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
                    
                    Text("Estado")
                        .font(.headline)
                    Text(incidencia.estado.capitalized.replacingOccurrences(of: "_", with: " "))
                        .font(.body)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 20)
                .padding(40)
                .transition(.scale)
            }
        }
    }
}
