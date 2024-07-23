//
//  PlaceView.swift
//  NearMe
//
//  Created by Vedant Patil on 19/11/23.
//

import SwiftUI
import MapKit

struct PlaceView: View {
    let mapItem : MKMapItem
    
    //building the address of the location
    private var address: String {
        let placemark = mapItem.placemark
        
        var addressComponents: [String] = []
        
        if let thoroughfare = placemark.thoroughfare {
            addressComponents.append(thoroughfare)
        }
        if let subThoroughfare = placemark.subThoroughfare {
            addressComponents.append(subThoroughfare)
        }
        if let locality = placemark.locality {
            addressComponents.append(locality)
        }
        if let administrativeArea = placemark.administrativeArea {
            addressComponents.append(administrativeArea)
        }
        if let postalCode = placemark.postalCode {
            addressComponents.append(postalCode)
        }
        if let country = placemark.country {
            addressComponents.append(country)
        }
        
        return addressComponents.joined(separator: ", ")
    }
    
    //calculating the distance from user location to destination
    private var distance : Measurement<UnitLength>? {
        guard let userLocation = LocationManager.shared.manager.location,
              let destinationLocation = mapItem.placemark.location else{
            return nil
        }
        
        return calculateDistance(from: userLocation, to: destinationLocation)
    }
    
    var body: some View {
        let placemark = mapItem.placemark
        
        VStack(alignment: .leading){
            Text(mapItem.name ?? "")
                .font(.title3)
            Text(address)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let distance {
                Text(distance, formatter: MeasurementFormatter.distance)
            }
        }
        
    }
}

//#Preview {
//    PlaceView()
//}
