//
//  DonorProfileView.swift
//  RETO_V2
//
//  Created by Enrique Mora on 29/08/23.
//

import SwiftUI

struct DonorProfileView: View {
    
    struct Donor {
        var name: String
        var email: String
        var phone: String
        var numberOfDonations: Int
        var image: Image
    }

    // Sample data
    let donor: Donor = Donor(name: "John Doe", email: "johndoe@example.com", phone: "+1234567890", numberOfDonations: 5, image: Image(systemName: "person.crop.circle"))

    var body: some View {
        VStack(spacing: 20) {
            donor.image
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .background(Color.orange.opacity(0.2))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.orange, lineWidth: 3))
                .shadow(radius: 10)
            
            VStack(spacing: 10) {
                ProfileDataRow(label: "Name", value: donor.name, color: .orange)
                ProfileDataRow(label: "Email", value: donor.email, color: .orange)
                ProfileDataRow(label: "Phone", value: donor.phone, color: .orange)
                ProfileDataRow(label: "Donations", value: "\(donor.numberOfDonations)", color: .orange)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .navigationTitle("Donor Profile")
        .background(NavigationConfigurator { nc in
            nc.navigationBar.titleTextAttributes = [.font : UIFont(name: "Chalkduster", size: 24)!,
                                                    .foregroundColor : UIColor.orange]
        })
    }
}

struct ProfileDataRow: View {
    var label: String
    var value: String
    var color: Color
    
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .foregroundColor(color)
            Spacer()
            Text(value)
                .font(.subheadline)
        }
    }
}

struct DonorProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DonorProfileView()
        }
    }
}

