//
//  ComentarioIncidencia.swift
//  gestorIncidencias
//
//  Created by  on 19/5/25.
//

struct ComentarioIncidencia: Identifiable, Codable {
    let id: Int
    let texto: String
    let createdAt: String
    let updatedAt: String
    let incidencia: Int  
    // let autor: CustomUser? // 

    enum CodingKeys: String, CodingKey {
        case id
        case texto
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case incidencia
        // case autor
    }
}



