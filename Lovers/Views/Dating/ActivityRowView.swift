//
//  ActivityRow.swift
//  Learning
//
//  Created by Derek Yeung on 18/9/2021.
//

import SwiftUI

struct ActivityRowView: View {
    var activity: DatingData.Dating.Activity
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading, spacing: 2.0) {
                Text(activity.description)
                    .font(.subheadline)
                if activity.location != "" && activity.area != "" {
                    Text("\(activity.location) - \(activity.area)")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                } else if activity.location != "" {
                    Text(activity.location)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                } else{
                    Text(activity.area)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                }
            }
            Spacer()
            if activity.isMain {
                Image(systemName: "star.fill")
                    .foregroundColor(Color.yellow)
            }
        }
    }
}

struct ActivityRow_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRowView(activity: datings[0].activities[0])
            .previewLayout(.fixed(width: 300, height: 70))
            .preferredColorScheme(.dark)
    }
}
