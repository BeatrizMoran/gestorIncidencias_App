//
//  Notificacion.swift
//  gestorIncidencias
//
//  Created by  on 19/5/25.
//

struct Notificacion: Codable, Identifiable {
    let id: Int
    let incidencia: Int
    let remitente: Usuario?
    let destinatario: Usuario
    let cuerpo: String
    let fechaEnvio: String
    let leido: Bool
}

enum CodingKeys: String, CodingKey {
    case fechaEnvio = "fecha_envio"
    case updatedAt = "updated_at"

}
