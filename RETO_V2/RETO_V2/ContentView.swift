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
    
    init?(data: [String: Any]) {
        guard let id = data["id"] as? Int,
              let name = data["name"] as? String,
              let stateRawValue = data["state"] as? String,
              let state = DonationState(rawValue: stateRawValue),
              let content = data["content"] as? [String],
              let donorData = data["donor"] as? [String: Any],
              let donorName = donorData["name"] as? String,
              let donorEmail = donorData["email"] as? String,
              let donorImage = donorData["image"] as? String else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.state = state
        self.content = content
        self.donor = Donor(name: donorName, email: donorEmail, image: donorImage)
    }
    
    init(id: Int, name: String, state: DonationState, content: [String], donor: Donor) {
        self.id = id
        self.name = name
        self.state = state
        self.content = content
        self.donor = donor
    }
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "name": name,
            "state": state.rawValue,
            "content": content,
            "donor": [
                "name": donor.name,
                "email": donor.email,
                "image": donor.image
            ]
        ]
    }
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

struct TrackingView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437), // Coordenadas mock
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        Map(coordinateRegion: $region)
            .navigationTitle("Tracking")
    }
}

struct DonationRow: View {
    @State private var showPopup = false
    @State private var showTrackingView = false
    @State private var showContentDetailView = false
    @State private var showDonorProfileView = false

    var donation: Donation

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(donation.name)
                    .font(.headline)
                Text(donation.state.rawValue)
                    .font(.subheadline)
                    .foregroundColor(getColorForState(donation.state))
            }
            
            Spacer()
            
            Button(action: {
                showPopup.toggle()
            }) {
                Image(systemName: "ellipsis.circle.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.gray)
            }
            .actionSheet(isPresented: $showPopup) {
                ActionSheet(title: Text("Options"), buttons: [
                    .default(Text("Track"), action: {
                        showTrackingView.toggle()
                    }),
                    .default(Text("Content"), action: {
                        showContentDetailView.toggle()
                    }),
                    .default(Text("Donor Profile"), action: {
                        showDonorProfileView.toggle()
                    }),
                    .cancel()
                ])
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
        .sheet(isPresented: $showTrackingView) {
            NavigationView {
                TrackingView()
            }
        }
        .sheet(isPresented: $showContentDetailView) {
            NavigationView {
                ContentDetailView()
            }
        }
        .sheet(isPresented: $showDonorProfileView) {
            NavigationView {
                DonorProfileView()
            }
        }
    }
    
    func getColorForState(_ state: DonationState) -> Color {
        switch state {
        case .onTheWay: return .orange
        case .received: return .red
        case .sent: return .blue
        case .delivered: return .green
        }
    }
}

struct ContentView: View {
    private var ref: DatabaseReference = Database.database().reference()
    var donations: [Donation] {
        let sampleDonor = Donor(name: "John Doe", email: "johndoe@example.com", image: "profile_image_placeholder")
        return [
            Donation(id: 0, name: "Donación 0", state: .onTheWay, content: ["Bread", "Butter"], donor: sampleDonor),
            Donation(id: 1, name: "Donación 1", state: .received, content: ["Apple", "Orange"], donor: sampleDonor),
            Donation(id: 2, name: "Donación 2", state: .sent, content: ["Milk", "Cookies"], donor: sampleDonor),
            Donation(id: 3, name: "Donación 3", state: .delivered, content: ["Carrots", "Potatoes"], donor: sampleDonor)
        ] + (4...53).map {
            Donation(id: $0, name: "Donación \($0)", state: DonationState.allCases.randomElement()!, content: ["Sample food"], donor: sampleDonor)
        }
    }
    
    init() {
        pushDonationsToFirebase()
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(donations) { donation in
                        DonationRow(donation: donation)
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

    func pushDonationsToFirebase() {
        for donation in donations {
            let newRef = ref.child("donations").childByAutoId()
            newRef.setValue(donation.dictionary)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

