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
            self.fetchIncidencias() 
        }
    }

    func refetch() {
        fetchIncidencias()
    }

    private func fetchIncidencias(retryOnUnauthorized: Bool = true) {
        guard let token = currentToken,
              let url = URL(string: "\(API.baseURL)/api/incidencias") else {
            print("❌ Token o URL inválidos")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("JWT \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 401 && retryOnUnauthorized {
                    print("⚠️ Token expirado, intentando refrescar...")

                    self.auth.refreshTokenIfNeeded { success in
                        if success {
                            print("✅ Token refrescado, reintentando fetch...")
                            DispatchQueue.main.async {
                                self.currentToken = self.auth.token
                                self.fetchIncidencias(retryOnUnauthorized: false)
                            }
                        } else {
                            print("❌ No se pudo refrescar el token")
                        }
                    }
                    return
                }
            }

            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Incidencia].self, from: data) {
                    DispatchQueue.main.async {
                        self.incidencias = decodedResponse
                        print("✅ Incidencias cargadas: \(decodedResponse.count)")
                    }
                } else {
                    print("❌ Error al decodificar las incidencias")
                    print(String(data: data, encoding: .utf8) ?? "")
                }
            } else if let error = error {
                print("❌ Error en la solicitud: \(error.localizedDescription)")
            }
        }.resume()
    }
}

