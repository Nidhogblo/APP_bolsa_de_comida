//
//  LoginView.swift
//  RETO_V2
//
//  Created by Enrique Mora on 19/09/23.
//

import SwiftUI
import FirebaseAuth


struct LoginView: View {
    @Binding var isLogged: Bool
    @State private var showRegister = false
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image("appLogo") 
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)

                TextField("Nombre de usuario", text: $username)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange, lineWidth: 1))

                SecureField("Contraseña", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange, lineWidth: 1))

                Button("Iniciar sesión") {
                    // Lógica de inicio de sesión
                    Auth.auth().signIn(withEmail: username, password: password) { (authResult, error) in
                        if let error = error {
                            print("Error signing in: \(error)")
                            return
                        }
                        isLogged = true
                    }
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(8)

                NavigationLink(destination: RegisterView(isLogged: $isLogged), isActive: $showRegister) {
                    Text("Registrar usuario")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .isDetailLink(false)
            }
            .padding()
        }
    }
}



