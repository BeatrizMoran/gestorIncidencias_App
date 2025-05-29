//
//  NotificacionesListViewModel.swift
//  gestorIncidencias
//
//  Created by  on 26/5/25.
//

//
//  IncidenciaListViewModel.swift
//  gestorIncidencias
//
//  Created by  on 19/5/25.
//

import SwiftUI

import Combine

class NotificacionesListViewModel: ObservableObject {
    @Published var notificaciones: [Notificacion] = []

    private var auth: AuthViewModel
    private var tokenCancellable: AnyCancellable?
    private var currentToken: String?

    init(auth: AuthViewModel) {
        self.auth = auth

        tokenCancellable = auth.$token.sink { [weak self] token in
            guard let self = self, let token = token else { return }
            self.currentToken = token
            self.fetchNotificaciones() // Usamos el token más reciente
        }
    }

    func refetch() {
        fetchNotificaciones()
    }

    private func fetchNotificaciones(retryOnUnauthorized: Bool = true) {
        guard let token = currentToken,
              let url = URL(string: "\(API.baseURL)/api/notificaciones") else {
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

                    // Intentamos refrescar el token
                    self.auth.refreshTokenIfNeeded { success in
                        if success {
                            print("✅ Token refrescado, reintentando fetch...")
                            DispatchQueue.main.async {
                                self.currentToken = self.auth.token
                                self.fetchNotificaciones(retryOnUnauthorized: false)
                            }
                        } else {
                            print("❌ No se pudo refrescar el token")
                        }
                    }
                    return
                }
            }

            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Notificacion].self, from: data) {
                    DispatchQueue.main.async {
                        self.notificaciones = decodedResponse
                        print("✅ Notificaciones cargadas: \(decodedResponse.count)")
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
    
    func marcarNotificacionComoLeida(id: Int) {
        guard let token = currentToken,
              let url = URL(string: "\(API.baseURL)/api/notificaciones/\(id)/marcar_leido") else {
            print("❌ Token o URL inválidos")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("JWT \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["leido": true]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("✅ Notificación \(id) marcada como leída")
                    DispatchQueue.main.async {
                        if let index = self.notificaciones.firstIndex(where: { $0.id == id }) {
                            self.notificaciones[index].leido = true
                        }
                    }
                } else {
                    print("❌ Error al marcar como leída: \(httpResponse.statusCode)")
                }
            } else if let error = error {
                print("❌ Error de red: \(error.localizedDescription)")
            }
        }.resume()
    }

}

