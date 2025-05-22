//
//  IncidenciaListViewModel.swift
//  gestorIncidencias
//
//  Created by  on 19/5/25.
//

import SwiftUI

import Combine

class IncidenciaListViewModel: ObservableObject {
    @Published var incidencias: [Incidencia] = []

    private var auth: AuthViewModel
    private var tokenCancellable: AnyCancellable?
    private var currentToken: String?

    init(auth: AuthViewModel) {
        self.auth = auth

        tokenCancellable = auth.$token.sink { [weak self] token in
            guard let self = self, let token = token else { return }
            self.currentToken = token
            print("✅ Token recibido en IncidenciaListViewModel: \(token)")
            self.fetchIncidencias(token: token)
        }
    }

    func refetch(){
        guard let token = currentToken else {
            print("❌ No hay token disponible para recargar incidencias")
            return
        }
        fetchIncidencias(token: token)
    }
    
    private func fetchIncidencias(token: String) {
        guard let url = URL(string: "\(API.baseURL)/incidencias") else {
            print("❌ URL no válida")
            return
        }

        let authValue = "JWT \(token)"
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(authValue, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Incidencia].self, from: data) {
                    DispatchQueue.main.async {
                        self.incidencias = decodedResponse
                        print("✅ Incidencias cargadas: \(decodedResponse.count)")
                    }
                } else {
                    print("❌ Error al decodificar incidencias")
                    print(String(data: data, encoding: .utf8) ?? "Respuesta no legible")
                }
            } else if let error = error {
                print("❌ Error en la solicitud: \(error.localizedDescription)")
            }
        }.resume()
    }
}


