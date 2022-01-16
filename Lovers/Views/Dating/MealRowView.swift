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
                Text(dining.type + ": " + dining.restaurant)
            }
            Spacer()
            VStack(alignment: .leading) {
                Text(dining.location)
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
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
