//
//  RegisterView.swift
//  RETO_V2
//
//  Created by Enrique Mora on 19/09/23.
//

import SwiftUI

struct RegisterView: View {
    @Binding var isLogged: Bool
    @State private var name: String = ""
    @State private var lastName: String = ""
    @State private var birthDate = Date()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var gender: String = ""
    @State private var profileImage = Image(systemName: "person.circle.fill")

    var genderOptions = ["Masculino", "Femenino", "Otro"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Pantalla de Registro")
                    .font(.largeTitle)
                    .foregroundColor(.orange)

                profileImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.orange, lineWidth: 2))
                    .padding()
                    .onTapGesture {
                    }

                TextField("Nombre", text: $name)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange, lineWidth: 1))

                TextField("Apellido", text: $lastName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange, lineWidth: 1))

                DatePicker("Fecha de Nacimiento", selection: $birthDate, displayedComponents: .date)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange, lineWidth: 1))

                TextField("Correo Electrónico", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange, lineWidth: 1))

                SecureField("Contraseña", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange, lineWidth: 1))

                Picker("Género", selection: $gender) {
                    ForEach(genderOptions, id: \.self) {
                        Text($0)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange, lineWidth: 1))

                Button("Registrar") {
                    // Lógica de registro
                    isLogged = true
                }
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
    }
}


