//
//  Incidencia.swift
//  gestorIncidencias
//
//  Created by  on 19/5/25.
//
import Foundation

struct Incidencia: Identifiable, Codable {
    var id: Int
    var descripcion: String
    var ubicacion: String
    var urgencia: String
    var estado: String
    var createdAt: String
    var updatedAt: String
    var asignadoA: Usuario?
    var reportadoPor: Usuario

    enum CodingKeys: String, CodingKey {
        case id
        case descripcion
        case ubicacion
        case urgencia
        case estado
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case asignadoA = "asignado_a_data"
        case reportadoPor = "reportado_por_data"
    }
}
