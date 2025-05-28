import Foundation
import SwiftUI

class ActualizarIncidenciaViewModel: ObservableObject {
    
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    private let authViewModel: AuthViewModel
    
    init(authViewModel: AuthViewModel) {
        self.authViewModel = authViewModel
    }
    
    func actualizarIncidencia(incidencia: Incidencia, nuevoEstado: String, completion: @escaping () -> Void) {
        
        guard let token = authViewModel.token else {
            errorMessage = "Token no disponible. Inicia sesión nuevamente."
            return
        }
        
        guard let url = URL(string: "\(API.baseURL)/incidencias/\(incidencia.id)") else {
            errorMessage = "URL inválida"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("JWT \(token)", forHTTPHeaderField: "Authorization")
        
        let actualizadaIncidencia = [
            "descripcion": incidencia.descripcion,
            "ubicacion": incidencia.ubicacion,
            "urgencia": incidencia.urgencia.lowercased(),
            "estado": nuevoEstado,
        ]
        
        print("Incidencia Actualizada", actualizadaIncidencia)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: actualizadaIncidencia, options: [])
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
                
                if httpResponse.statusCode == 201 || httpResponse.statusCode == 200 {
                    self.successMessage = "Incidencia actualizada con éxito"
                    completion() // 🔥 Llamamos al completion aquí
                } else {
                    self.errorMessage = "Error del servidor. Código: \(httpResponse.statusCode)"
                }
            }
        }.resume()
    }
}
