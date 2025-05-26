//
//  NuevaIncidenciaView.swift
//  gestorIncidencias
//
//  Created by  on 19/5/25.
//

import SwiftUI

struct NuevaIncidenciaView: View {
    @ObservedObject var viewModel: NuevaIncidenciaViewModel
    @Binding var selectedTab: Tab

    var body: some View {
        NavigationStack {
            VStack {
                // Cabecera
                HStack {
                    
                    Image(systemName: "exclamationmark.bubble.fill")
                        .resizable()
                        .foregroundStyle(Color.white)
                        .scaledToFit()
                        .frame(height: 50)
                        .cornerRadius(10)
                        .padding(.bottom, 8)

                    Text("Nueva Incidencia")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .font(.system(size: 26, weight: .bold))
                        .padding()
                        .cornerRadius(10)

                    Spacer()
                }
                .padding()
                .background(Color.black)

                Form {
                    Section(header: Text("Descripción")) {
                        TextField("Descripción", text: $viewModel.descripcion)
                    }

                    Section(header: Text("Ubicación")) {
                        TextField("Ubicación", text: $viewModel.ubicacion)
                    }

                    Section(header: Text("Urgencia")) {
                        Picker("Urgencia", selection: $viewModel.urgencia) {
                            Text("Baja").tag("Baja")
                            Text("Media").tag("Media")
                            Text("Alta").tag("Alta")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }

                    if let error = viewModel.errorMessage {
                        Section {
                            Text(error)
                                .foregroundColor(.red)
                        }
                    }

                    if let success = viewModel.successMessage {
                        Section {
                            Text(success)
                                .foregroundColor(.green)
                        }
                    }

                    Section {
                        Button("Registrar Incidencia") {
                            viewModel.crearIncidencia{
                                selectedTab = .home
                                
                            }
                            
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(8)
                    }
                }
            }
        }
    }
}
