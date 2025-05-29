//
//  Notificacion.swift
//  gestorIncidencias
//
//  Created by  on 19/5/25.
//

struct Notificacion: Codable, Identifiable {
    let id: Int
       let incidencia: Incidencia
       let remitente: Usuario?
       let destinatario: Usuario
       let cuerpo: String
       let fechaEnvio: String
       var leido: Bool
       
       enum CodingKeys: String, CodingKey {
           case id
           case incidencia = "incidencia_data"
           case remitente = "remitente_data"
           case destinatario = "destinatario_data"
           case cuerpo
           case fechaEnvio = "fecha_envio"
           case leido
       }
        



}
