//
//  ComentarioIncidencia.swift
//  gestorIncidencias
//
//  Created by  on 19/5/25.
//

struct ComentarioIncidencia: Identifiable, Codable, Equatable {
    let id: Int
    let texto: String
    let createdAt: String
    let updatedAt: String
    let incidencia: Int  

    enum CodingKeys: String, CodingKey {
        case id
        case texto
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case incidencia
    }
}



