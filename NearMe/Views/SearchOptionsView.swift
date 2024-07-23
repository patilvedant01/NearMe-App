//
//  SearchOptionsView.swift
//  NearMe
//
//  Created by Vedant Patil on 19/11/23.
//

import SwiftUI

struct SearchOptionsView: View {
    let searchOptions = ["Restaurants": "fork.knife",
                         "Hotels":"bed.double.fill",
                         "Coffee Shops":"cup.and.saucer.fill",
                         "Petrol Pumps":"fuelpump.fill",
                         "Gym":"dumbbell.fill",
                         "Parkings":"parkingsign.circle.fill",
                         "Bus Stops":"bus.fill"]
    
    let tintColors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]
    
    @Binding var query : String
    @Binding var isSearching : Bool
    
    //MARK:- VIEW
    var body: some View {
        ScrollView(.horizontal,showsIndicators: false){
            HStack{
                ForEach(searchOptions.sorted(by: >), id:\.0){key,value in
                    Button(action: {
                        query = key
                        isSearching = true
                    }, label: {
                        Image(systemName: value)
                        Text(key)
                    })
                    .buttonStyle(.borderedProminent)
                    .tint(Color(red: 236/255, green: 240/255 ,blue: 241/255, opacity: 1.0))
                    .foregroundStyle(.black)
                    .padding(4)
                }
            }
        }
    }
}

//#Preview {
//    SearchOptionsView
//}

                   
