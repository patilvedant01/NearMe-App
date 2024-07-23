//
//  LocationSearch.swift
//  NearMe
//
//  Created by Vedant Patil on 19/11/23.
//

import Foundation
import MapKit

func makeCall(phone: String){
    if let url = URL(string: "tel://\(phone)"){
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        }
        else{
            print("This number can't be dialed.")
        }
    }
}

func calculateDirections(from: MKMapItem, to: MKMapItem) async -> MKRoute? {
    let directionsRequest = MKDirections.Request()
    directionsRequest.transportType = .automobile
    directionsRequest.source = from
    directionsRequest.destination = to
    
    let directions = MKDirections(request: directionsRequest)
    
    do {
        let response = try await directions.calculate()
        return response.routes.first
    } catch {
        print("Error calculating directions: \(error.localizedDescription)")
        return nil
    }
}

func calculateDistance(from: CLLocation,to: CLLocation) -> Measurement<UnitLength> {
    let distanceInMeters = from.distance(from: to)
    
    return Measurement(value: distanceInMeters, unit: .meters)
}

func performSearch(for query: String,region: MKCoordinateRegion?) async throws -> [MKMapItem]{
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = query
    request.resultTypes = .pointOfInterest
    
    guard let outputRegion = region else { return [] }
    request.region = outputRegion
    
    let search = MKLocalSearch(request: request)
    let response = try await search.start()
    
    return response.mapItems
}
