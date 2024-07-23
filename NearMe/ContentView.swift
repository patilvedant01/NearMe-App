//
//  ContentView.swift
//  NearMe
//
//  Created by Vedant Patil on 19/11/23.
//

import SwiftUI
import MapKit

enum DisplayMode {
    case list
    case detail
}


struct ContentView: View {
    
    @State private var query: String = ""
    @State private var selectedDetent: PresentationDetent = .fraction(0.20)
    @State private var locationManger = LocationManager.shared
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var isSearching: Bool = false
    @State private var mapItems: [MKMapItem] = []
    @State private var visibleregion : MKCoordinateRegion?
    @State private var selectedMapItem : MKMapItem?
    @State private var displayMode : DisplayMode = .list
    @State private var lookAroundScene : MKLookAroundScene?
    @State private var route : MKRoute?
    
    private func search() async{
        
        do{
            mapItems = try await performSearch(for: query, region: visibleregion)
            isSearching = false
        }catch{
            mapItems = []
            print(error.localizedDescription)
            isSearching = false
        }
        
    }
    
    private func requestCalculateDirections() async{
        route = nil
        
        if let selectedMapItem{
            guard let currentLocation = locationManger.manager.location else{
                return
            }
            
            let startingMapItem = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation.coordinate))
            
                self.route = await calculateDirections(from: startingMapItem, to: selectedMapItem)
        }
    }
    
    var body: some View {
        ZStack {
            Map(position: $position,selection: $selectedMapItem){
                //makers to represnt destinations
                ForEach(mapItems , id: \.self){place in
                    Marker(item: place)
                }
                
                //displaying the route on the map
                if let route {
                    MapPolyline(route)
                        .stroke(.blue,lineWidth: 4)
                }
                
                //users current location
                UserAnnotation()
            }
            .task(id: isSearching, {
                if isSearching{
                    await search()
                }
            })
            .onChange(of: selectedMapItem){
                if selectedMapItem != nil {
                    displayMode = .detail
                }
                else{
                    displayMode = .list
                }
            }
            .task(id: selectedMapItem){
                await requestCalculateDirections()
            }
            .onMapCameraChange { context in
                visibleregion = context.region
            }
            .onChange(of: locationManger.region, {
                withAnimation{
                    position = .region(locationManger.region)
                }
            })
            .sheet(isPresented: .constant(true), content: {
                //MARK: Vstack
                VStack {
                    
                    switch displayMode {
                    case .list:
                        //Search feild
                        TextField("Search", text: $query)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                            .onSubmit {
                                isSearching = true
                            }
                        
                        //Search Options
                        SearchOptionsView(query: $query,isSearching: $isSearching)
                            .padding(.horizontal)
                        PlaceListView(mapItems: mapItems,selectedMapItem: $selectedMapItem)
                    //place detail view
                    case .detail:
                        PlaceDetailView(mapItem: $selectedMapItem)
                        if let selectedMapItem{
                            ActionButton(mapItem : selectedMapItem)
                                .padding(.leading)
                        }
                        if selectedDetent == .large || selectedDetent == .medium
                        {
                            LookAroundPreview(initialScene: lookAroundScene)
                                    .task(id: selectedMapItem) {
                                        lookAroundScene = nil
                                        if let selectedMapItem {
                                            do {
                                                let request = MKLookAroundSceneRequest(mapItem: selectedMapItem)
                                                lookAroundScene = try await request.scene
                                            } catch {
                                                print("Look Around scene not available for this location: \(error.localizedDescription)")
                                                // Handle the error, maybe show an alert to the user
                                            }
                                        }
                                    }
                        }
                            
                    }//:Switch Statement
                    
                    Spacer()
                }//:VStack
                .presentationDetents([.fraction(0.20), .medium, .large], selection: $selectedDetent)
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled()
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                .padding(.top)
            })
            
        }//:ZStack
    }
}

#Preview {
    ContentView()
}
