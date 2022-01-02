//
//  ListRow.swift
//  Learning
//
//  Created by Derek Yeung on 18/9/2021.
//

import SwiftUI

struct DatingRowView: View {
    var dating: Dating
    
    var body: some View {
        HStack() {
            VStack(alignment: .leading, spacing: 2.0) {
                Text(dating.activities.filter{activity in
                    return activity.isMain == true
                }[0].description)
                    .font(.body)
                Text(dating.activities.filter{activity in
                    return activity.isMain == true
                }[0].location)
                    .font(.footnote)
                    .foregroundColor(Color.gray)
            }
            Spacer()
            VStack() {
                Spacer()
                Text(dating.date, style:.date)
                    .font(.footnote)
                Spacer()
            }
        }
    }
}

struct DatingRow_Previews: PreviewProvider {
    static var previews: some View {
        DatingRowView(dating: datings[0])
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
