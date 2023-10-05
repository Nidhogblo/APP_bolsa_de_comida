//
//  MainAppView.swift
//  RETO_V2
//
//  Created by Enrique Mora on 21/09/23.
//

import SwiftUI

struct MainAppView: View {
    @State private var isLogged = false

    var body: some View {
        if isLogged {
            ContentView()
        } else {
            LoginView(isLogged: $isLogged)
        }
    }
}

