//
//  AuthViewModel.swift
//  gestorIncidencias
//
//  Created by  on 19/5/25.
//


import SwiftUI

import SwiftKeychainWrapper



class AuthViewModel: ObservableObject {
    @Published var user: Usuario? = nil
    @Published var token: String? = nil
    @Published var refreshToken: String? = nil


    @Published var isAuthenticated: Bool = false




    init() {
        loadRefreshToken()
    }


    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(API.baseURL)/auth/jwt/create") else {
            completion(false) // URL mal formada
            return
        }
       
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")


        let loginData = LoginRequest(email: email, password: password)
        request.httpBody = try? JSONEncoder().encode(loginData)


        print(loginData)
       
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false) // No hay datos, error en red
                }
                return
            }


            if let decodedResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                DispatchQueue.main.async {


                    //self.user = decodedResponse.user
                    //self.token = decodedResponse.access_token
                    self.token = decodedResponse.access
                    self.refreshToken = decodedResponse.refresh
                    self.isAuthenticated = true
                    // Guardar refresh token en Keychain
                    KeychainWrapper.standard.set(decodedResponse.refresh, forKey: "refreshToken")




                   
                    completion(true) // ✅ Login correcto
                }
            } else {
                DispatchQueue.main.async {
                    print(String(data: data, encoding: .utf8) ?? "Data inválida")


                    print("fallo")
                    completion(false)
                }
            }
        }.resume()
    }
   
    //  Refresh Token
        func refreshTokenIfNeeded(completion: @escaping (Bool) -> Void) {
            guard let refresh = refreshToken,
                  let url = URL(string: "\(API.baseURL)/auth/jwt/refresh") else {
                completion(false)
                return
            }


            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")


            let body = ["refresh": refresh]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)


            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }


                if let decoded = try? JSONDecoder().decode(RefreshResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.token = decoded.access
                        self.isAuthenticated = true


                        completion(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        print("Refresh error:", String(data: data, encoding: .utf8) ?? "")
                        self.logout()
                        completion(false)
                    }
                }
            }.resume()
        }


    func logout() {
        self.user = nil
        self.token = nil
        self.refreshToken = nil
        self.isAuthenticated = false
        KeychainWrapper.standard.remove(forKey: "refreshToken")
        
        print("LogOut hecho.")

    }


    // Cargar el refresh token al abrir la app
    private func loadRefreshToken() {
    if let savedRefresh = KeychainWrapper.standard.string(forKey: "refreshToken") {
        self.refreshToken = savedRefresh
        self.refreshTokenIfNeeded { success in
            DispatchQueue.main.async {
                self.isAuthenticated = success
            }
        }
    }
}


}



