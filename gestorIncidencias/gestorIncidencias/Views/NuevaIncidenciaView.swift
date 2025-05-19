//
//  NuevaIncidenciaView.swift
//  gestorIncidencias
//
//  Created by  on 19/5/25.
//

import SwiftUI

struct NuevaIncidenciaView: View {
    @State private var descripcion: String = ""
    @State private var ubicacion: String = ""
    @State private var urgencia: String = "Baja"
    
    let nivelesUrgencia = ["Baja", "Media", "Alta"]

    var body: some View {
        NavigationView {
            VStack{
                
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
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.black)

                // Formulario
                Form {
                    Section(header: Text("Descripción")) {
                        TextField("Describe la incidencia...", text: $descripcion)
                    }

                    Section(header: Text("Ubicación")) {
                        TextField("¿Dónde ocurre la incidencia?", text: $ubicacion)
                    }

                    Section(header: Text("Urgencia")) {
                        Picker("Nivel de urgencia", selection: $urgencia) {
                            ForEach(nivelesUrgencia, id: \.self) { nivel in
                                Text(nivel)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section {
                        Button(action: registrarIncidencia) {
                            HStack {
                                Image(systemName: "paperplane.fill")
                                Text("Registrar Incidencia")
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(8)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    // Acción al registrar
    func registrarIncidencia() {
        print("Descripción: \(descripcion)")
        print("Ubicación: \(ubicacion)")
        print("Urgencia: \(urgencia)")
        // Aquí podrías guardar la incidencia, subirla a una base de datos, etc.
    }
}

