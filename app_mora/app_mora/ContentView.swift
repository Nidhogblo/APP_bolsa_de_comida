//
//  ContentView.swift
//  app_mora
//
//  Created by Juan Daniel Muñoz Dueñas on 17/08/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showRegister = false

    var body: some View {
        if showRegister {
            RegisterView()
        } else {
            LoginView(showRegister: $showRegister)
        }
    }
}

struct RegisterView: View {
    @State private var name: String = ""
    @State private var lastName: String = ""
    @State private var birthDate = Date()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var gender: String = ""
    @State private var profileImage = Image(systemName: "person.circle.fill") // Imagen genérica de perfil


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
                        // Aquí puedes agregar la lógica para seleccionar una imagen
                    }

                TextField("Nombre", text: $name)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange, lineWidth: 1))

                TextField("Apellidos", text: $lastName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange, lineWidth: 1))

                DatePicker("Fecha de nacimiento", selection: $birthDate, displayedComponents: .date)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange, lineWidth: 1))

                TextField("Correo", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange, lineWidth: 1))
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

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
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.orange, lineWidth: 1))

                Button(action: {
                    // Acción de registro aquí
                }) {
                    Text("Registrar")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}


struct LoginView: UIViewControllerRepresentable {
    @Binding var showRegister: Bool

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> LoginViewController {
        let viewController = LoginViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {
        // Actualizaciones si es necesario
    }

    class Coordinator: NSObject {
        var parent: LoginView

        init(_ parent: LoginView) {
            self.parent = parent
        }

        @objc func handleRegisterButtonTapped() {
            parent.showRegister = true
        }
    }
}
