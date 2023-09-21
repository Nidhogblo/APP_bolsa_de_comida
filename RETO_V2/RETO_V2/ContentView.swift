//
//  ContentView.swift
//  RETO_V2
//
//  Created by Enrique Mora on 29/08/23.
//

import SwiftUI
import MapKit

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

struct TrackingView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437), // Sample LA coordinates
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        Map(coordinateRegion: $region)
            .navigationTitle("Tracking")
    }
}

struct DonationRow: View {
    @State private var showPopup = false
    @State private var showTrackingView = false // State to manage showing the map

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
                        showTrackingView.toggle() // Trigger showing the map
                    }),
                    .default(Text("Content"), action: {
                        // Navigate to content view
                    }),
                    .default(Text("Donor Profile"), action: {
                        // Navigate to donor profile view
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
                .font(Font.custom("Billabong", size: 24)) // Use your desired font
            }
            .tabItem {
                Image(systemName: "gift")
                Text("Donations")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
