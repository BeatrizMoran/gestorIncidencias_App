import Foundation
import SwiftUI

class NuevaIncidenciaViewModel: ObservableObject {
    @Published var descripcion: String = ""
    @Published var ubicacion: String = ""
    @Published var urgencia: String = "Baja"
    @Published var errorMessage: String?
    @Published var successMessage: String?

    
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

    func crearIncidencia(){
        guard validarCampos() else { return }
        guard let token = authViewModel.token else {
            errorMessage = "Token no disponible. Inicia sesión nuevamente."
            return
        }

        guard let url = URL(string: "\(API.baseURL)/incidencias") else {
            errorMessage = "URL inválida"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("JWT \(token)", forHTTPHeaderField: "Authorization")

        let nuevaIncidencia = [
            "descripcion": descripcion,
            "ubicacion": ubicacion,
            "urgencia": urgencia.lowercased(),
            "estado": "pendiente"
        ]
        
        print("Incidencia", nuevaIncidencia)

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: nuevaIncidencia, options: [])
        } catch {
            errorMessage = "Error al codificar los datos."
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Error de red: \(error.localizedDescription)"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Respuesta no válida del servidor."
                    return
                }

                
                if httpResponse.statusCode == 201 {
                            DispatchQueue.main.async {
                                self.successMessage = "Incidencia creada con éxito"
                                self.descripcion = ""
                                self.ubicacion = ""
                                self.urgencia = "Baja"
                            }
                    
                } else {
                    self.errorMessage = "Error del servidor. Código: \(httpResponse.statusCode)"
                }
            }
        }.resume()
    }
}
