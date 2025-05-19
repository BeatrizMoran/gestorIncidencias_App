//
//  ResueltasView.swift
//  gestorIncidencias
//
//  Created by  on 19/5/25.
//

import SwiftUI

struct ResueltasView: View {
    var body: some View {
        
        ZStack{
            VStack{
                HStack {
                    Image(systemName: "bolt.badge.checkmark.fill")
                        .resizable()
                        .foregroundStyle(Color.white)
                        .scaledToFit()
                        .frame(height: 50)
                        .cornerRadius(10)
                        .padding(.bottom, 8)

                    Text("Incidencias Resueltas")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .font(.system(size: 26, weight: .bold))
                        .padding()
                        .cornerRadius(10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.black)
                
                NavigationStack{
                    
                }
                
            }
        }
        
    }
}
