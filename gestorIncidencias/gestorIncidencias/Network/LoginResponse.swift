//
//  LoginResponse.swift
//  gestorIncidencias
//
//  Created by  on 19/5/25.
//

struct LoginResponse: Codable{
    let access_token: String
    let toke_type: String
    let expires_in : Int
    let user: Usuario
}
