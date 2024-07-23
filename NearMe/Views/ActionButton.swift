//
//  ActionButton.swift
//  NearMe
//
//  Created by Vedant Patil on 19/11/23.
//

import SwiftUI
import MapKit

struct ActionButton: View {
    //MARK:- PROPERTIES
    let mapItem: MKMapItem
    
    //MARK:- VIEW
    var body: some View {
        HStack{
            //call button
            
            if let phone = mapItem.phoneNumber{
                Button(action: {
                        let numericPhoneNumber = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                        makeCall(phone: numericPhoneNumber)
                }, label: {
                    Image(systemName: "phone.fill")
                    Text("Call")
                })
                .buttonStyle(.bordered)
            }
            
            //take me there button
            Button(action: {
                MKMapItem.openMaps(with: [mapItem])
            }, label: {
                Image(systemName: "car.circle.fill")
                Text("Take me there")
            })
            .buttonStyle(.bordered)
            .tint(.green)
            
            Spacer()
        }
    }
}

//#Preview {
//    ActionButton()
//}
