//
//  ContentDetailView.swift
//  RETO_V2
//
//  Created by Enrique Mora on 29/08/23.
//

import SwiftUI

struct ContentDetailView: View {
    
    // Sample data
    struct FoodItem: Identifiable {
        var id = UUID()
        var name: String
        var quantity: Int
    }

    let foodItems: [FoodItem] = [
        "Bread", "Butter", "Apple", "Orange", "Milk", "Cookies", "Carrots", "Potatoes", "Chicken", "Eggs"
    ].shuffled().prefix(Int.random(in: 3...8)).map {
        FoodItem(name: $0, quantity: Int.random(in: 1...10))
    }
    
    var body: some View {
        List(foodItems) { item in
            HStack {
                Text(item.name)
                    .font(.custom("Arial", size: 18))
                    .foregroundColor(Color.red.opacity(0.7))
                Spacer()
                Text("\(item.quantity)")
                    .font(.custom("Arial", size: 16))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 4)
        }
        .listStyle(PlainListStyle())
        .padding([.horizontal])
        .background(NavigationConfigurator { nc in
            nc.navigationBar.titleTextAttributes = [.font : UIFont(name: "Arial", size: 24)!,
                                                    .foregroundColor : UIColor.red]
        })
        .navigationTitle("Donation Content")
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentDetailView()
        }
    }
}

