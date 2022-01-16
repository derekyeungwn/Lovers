//
//  ActivityRow.swift
//  Learning
//
//  Created by Derek Yeung on 18/9/2021.
//

import SwiftUI

struct ActivityRowView: View {
    var activity: Dating.Activity
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading, spacing: 2.0) {
                Text(activity.description)
            }
            Spacer()
            if activity.isMain {
                Image(systemName: "star.fill")
                    .foregroundColor(Color.yellow)
            }
            Text(activity.location)
                .font(.subheadline)
                .foregroundColor(Color.gray)
        }
    }
}

struct ActivityRow_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRowView(activity: datings[0].activities[0])
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
