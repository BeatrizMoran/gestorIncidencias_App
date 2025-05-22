//
//  Usuario.swift
//  gestorIncidencias
//
//  Created by  on 19/5/25.
//

struct Usuario: Codable, Identifiable, Equatable {
    let id: Int
    let email: String
    let name: String
}


