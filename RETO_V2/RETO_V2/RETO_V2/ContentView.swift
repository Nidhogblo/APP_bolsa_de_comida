//
//  ContentView.swift
//  RETO_V2
//
//  Created by Enrique Mora on 29/08/23.
//

import SwiftUI
import MapKit
import FirebaseDatabase

struct Donation: Identifiable {
    var id: Int
    var name: String
    var state: DonationState
    var content: [String]
    var donor: Donor
}

struct Donor {
    var name: String
    var email: String
    var image: String
}

enum DonationState: String, CaseIterable {
    case onTheWay = "On the way"
    case received = "Received"
    case sent = "Sent"
    case delivered = "Delivered"
}

struct ContentView: View {
    @State private var donations: [Donation] = []

    init() {
        fetchDonations()
        
        // Sample donations
        let sampleDonations: [Donation] = (1...20).map { index in
            Donation(
                id: index,
                name: "Donation \(index)",
                state: DonationState.allCases.randomElement()!,
                content: ["Item \(index)A", "Item \(index)B"],
                donor: Donor(name: "Donor \(index)", email: "donor\(index)@example.com", image: "imageURL\(index)")
            )
        }
        
        // Push sample donations to Firebase
        for donation in sampleDonations {
            createDonation(donation: donation)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                List(donations) { donation in
                    VStack(alignment: .leading) {
                        Text(donation.name)
                            .font(.headline)
                        Text(donation.state.rawValue)
                            .font(.subheadline)
                        Text(donation.donor.name)
                            .font(.caption)
                    }
                }
                .navigationTitle("Donations Dashboard")
                .navigationBarItems(leading: Image(systemName: "applelogo").foregroundColor(.red))
                .font(Font.custom("Billabong", size: 24))
            }
            .tabItem {
                Image(systemName: "gift")
                Text("Donations")
            }
        }
    }

    func fetchDonations() {
        let ref = Database.database().reference().child("donations")
        ref.observe(.value) { snapshot in
            var loadedDonations: [Donation] = []
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                if let value = child.value as? [String: Any],
                   let name = value["name"] as? String,
                   let stateRaw = value["state"] as? String,
                   let state = DonationState(rawValue: stateRaw),
                   let content = value["content"] as? [String],
                   let donorData = value["donor"] as? [String: String],
                   let donorName = donorData["name"],
                   let donorEmail = donorData["email"],
                   let donorImage = donorData["image"] {
                    let donor = Donor(name: donorName, email: donorEmail, image: donorImage)
                    let donation = Donation(id: Int(child.key) ?? 0, name: name, state: state, content: content, donor: donor)
                    loadedDonations.append(donation)
                }
            }
            self.donations = loadedDonations
        }
    }

    func createDonation(donation: Donation) {
        let ref = Database.database().reference()
        ref.child("donations").childByAutoId().setValue([
            "name": donation.name,
            "state": donation.state.rawValue,
            "content": donation.content,
            "donor": [
                "name": donation.donor.name,
                "email": donation.donor.email,
                "image": donation.donor.image
            ]
        ])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
