//
//  IncidenciaListViewModel.swift
//  gestorIncidencias
//
//  Created by  on 19/5/25.
//

import SwiftUI

class IncidenciaListViewModel: ObservableObject {
   
    @Published var incidencias: [Incidencia] = []
    

    func fetchIncidencias() {
        guard let url = URL(string : "\(API.baseURL)/incidencias") else {
            print("URL no válida")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Incidencia].self, from: data) {
                    // Imprimir en consola para ver las Incidencias
                    print("Incidencias recibidos: \(decodedResponse)")
                    
                    DispatchQueue.main.async {
                        self.incidencias = decodedResponse
                    }
                } else {
                    print("Error al decodificar las incidencias")
                }
            } else if let error = error {
                print("Error en la solicitud: \(error.localizedDescription)")
            }
        }.resume()
    }
}
