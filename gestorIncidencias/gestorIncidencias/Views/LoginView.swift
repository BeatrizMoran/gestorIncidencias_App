//
//  LoginView.swift
//  gestorIncidencias
//
//  Created by  on 19/5/25.
//

import SwiftUI

struct LoginView: View {
    var onLoginSuccess: () -> Void

    @ObservedObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Iniciar Sesión")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Contraseña", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Entrar") {
                
                authVM.login(email: email, password: password) { success in
                        if success {
                            onLoginSuccess()
                        } else {
                            // Mostrar alerta, vibración, etc.
                            print("Credenciales inválidas")
                        }
                    }
                
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.black)
            .cornerRadius(8)
        }
        .padding()
    }
}

