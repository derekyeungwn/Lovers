//
//  MealRow.swift
//  Learning
//
//  Created by Derek Yeung on 18/9/2021.
//

import SwiftUI

struct MealRowView: View {
    var dining: Dating.Dining
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading) {
                Text(dining.type)
                    .font(.subheadline)
                    .foregroundColor(Color.indigo)
                Text(dining.restaurant)
                    .font(.subheadline)
                if dining.location != "" && dining.area != ""{
                    Text("\(dining.area) - \(dining.location)")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                } else if dining.location != "" {
                    Text("\(dining.location)")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                } else{
                    Text("\(dining.area)")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(dining.cuisine)
                    .font(.subheadline)
                    .foregroundColor(Color.orange)
            }
        }
    }
}

struct MealRow_Previews: PreviewProvider {
    static var previews: some View {
        MealRowView(dining: datings[0].dinner)
    }
}
