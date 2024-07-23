//
//  PlaceListView.swift
//  NearMe
//
//  Created by Vedant Patil on 19/11/23.
//

import SwiftUI
import MapKit

struct PlaceListView: View {
    let mapItems: [MKMapItem]
    @Binding var selectedMapItem : MKMapItem?
    
    private var sortedItems : [MKMapItem]{
        
        guard let userLocation = LocationManager.shared.manager.location else{
            return mapItems
        }
        
        return mapItems.sorted{lhs , rhs in
            
            guard let lhslocation = lhs.placemark.location,
                  let rhslocation = rhs.placemark.location else{
                      return false
            }
            
            let lhsDistance = userLocation.distance(from: lhslocation)
            let rhsDistance = userLocation.distance(from: rhslocation)
            
            return lhsDistance < rhsDistance
            
        }
    }
    
    var body: some View {
        //List of searched options
            List(sortedItems, id: \.self,selection: $selectedMapItem){mapitem in
                PlaceView(mapItem: mapitem)
            }
    }
}

//#Preview {
//    PlaceListView(mapItems: )
//}
