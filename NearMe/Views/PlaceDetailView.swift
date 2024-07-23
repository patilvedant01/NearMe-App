//
//  PlaceDetailView.swift
//  NearMe
//
//  Created by Vedant Patil on 19/11/23.
//

import SwiftUI
import MapKit

struct PlaceDetailView: View {
    @Binding var mapItem : MKMapItem?
    
    var body: some View {
        VStack{
            
            HStack{
                Spacer()
                
                Image(systemName: "xmark.circle.fill")
                    .opacity(0.5)
                    .onTapGesture {
                        mapItem = nil
                    }
                    .padding(.top)
            }
            
            if let mapItem{
                PlaceView(mapItem: mapItem)
            }
        }//:VStack
        .padding(.horizontal)
    }
}

//#Preview {
//    PlaceDetailView()
//}
