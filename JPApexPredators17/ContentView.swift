//
//  ContentView.swift
//  JPApexPredators17
//
//  Created by Bayu P Yuhartono on 18/06/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State var searchText = ""
    @State var isAlphabetical = false
    @State var currentSelection = PredatorType.all
    
    let predators = Predators()
    
    var filterDinos: [ApexPredator] {
        predators.filter(by: currentSelection)
        predators.sort(by: isAlphabetical)
        
        return predators.search(for: searchText)
    }
    
    var body: some View {
        NavigationStack {
            List(filterDinos) { predator in
                NavigationLink {
                    PredatorDetail(predator: predator, position: .camera(MapCamera(centerCoordinate: predator.location, distance: 30000)))
                } label: {
                    HStack {
                        // dino image
                        Image(predator.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .shadow(color: .white, radius: 1)
                        
                        VStack(alignment: .leading) {
                            // name
                            Text(predator.name)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            
                            // type
                            Text(predator.type.rawValue.capitalized)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 13)
                                .padding(.vertical, 5)
                                .background(predator.type.background)
                                .clipShape(.capsule)
                        }
                    }
                }
            }
            .navigationTitle("Apex Predators")
            .searchable(text: $searchText)
            .autocorrectionDisabled()
            .animation(.default, value: searchText)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            isAlphabetical.toggle()
                        }
                    } label: {
                        Image(systemName: isAlphabetical ? "film" : "textformat")
                            .symbolEffect(.bounce, value: isAlphabetical)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Filter", selection: $currentSelection.animation()) {
                            ForEach(PredatorType.allCases) { type in
                                Label(type.rawValue.capitalized, systemImage: type.icon)
                            }
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
