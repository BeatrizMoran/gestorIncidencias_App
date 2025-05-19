//
//  AuthViewModel.swift
//  gestorIncidencias
//
//  Created by  on 19/5/25.
//

import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var user: Usuario? = nil
    @Published var token: String? = nil

    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://10.100.252.110:8000/api/jwt/create") else {
            completion(false) // URL mal formada
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let loginData = LoginRequest(email: email, password: password)
        request.httpBody = try? JSONEncoder().encode(loginData)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false) // No hay datos, error en red
                }
                return
            }

            if let decodedResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.user = decodedResponse.user
                    self.token = decodedResponse.access_token
                    completion(true) // ✅ Login correcto
                }
            } else {
                DispatchQueue.main.async {
                    completion(false) // ❌ Falló el decode = login inválido
                }
            }
        }.resume()
    }

    func logout() {
        self.user = nil
        self.token = nil
    }
}
