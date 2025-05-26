import Foundation
import SwiftUI

class NuevaIncidenciaViewModel: ObservableObject {
    @Published var descripcion: String = ""
    @Published var ubicacion: String = ""
    @Published var urgencia: String = "Baja"
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var incidenciaCreada: Bool = false

    
    
    private let authViewModel: AuthViewModel
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
    }
    
    func validarCampos() -> Bool {
        guard !descripcion.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "La descripción es obligatoria."
            return false
        }
        guard !ubicacion.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "La ubicación es obligatoria."
            return false
        }
        return true
    }
    
    func crearIncidencia(onSuccess: @escaping () -> Void) {
        guard validarCampos() else { return }

        authViewModel.refreshTokenIfNeeded { [weak self] success in
            guard let self = self else { return }

            guard success, let token = self.authViewModel.token else {
                DispatchQueue.main.async {
                    self.errorMessage = "No se pudo refrescar el token. Inicia sesión nuevamente."
                }
                return
            }

            guard let url = URL(string: "\(API.baseURL)/api/incidencias") else {
                DispatchQueue.main.async {
                    self.errorMessage = "URL inválida"
                }
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("JWT \(token)", forHTTPHeaderField: "Authorization")

            let nuevaIncidencia: [String: Any] = [
                "descripcion": self.descripcion,
                "ubicacion": self.ubicacion,
                "urgencia": self.urgencia.lowercased(),
                "estado": "pendiente"
            ]

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: nuevaIncidencia)
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error al codificar los datos."
                }
                return
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Error de red: \(error.localizedDescription)"
                    }
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Respuesta no válida del servidor."
                    }
                    return
                }

                
                    if httpResponse.statusCode == 201 {
                        DispatchQueue.main.async {
                            print("✅ Incidencia creada con éxito")
                            self.successMessage = "Incidencia creada con éxito"
                            self.descripcion = ""
                            self.ubicacion = ""
                            self.urgencia = "Baja"
                            
                            DispatchQueue.main.async {
                                onSuccess()
                            }
                            
                        }

                    } else {
                        self.errorMessage = "Error del servidor. Código: \(httpResponse.statusCode)"
                    }
                
            }.resume()
        }
    }

}
