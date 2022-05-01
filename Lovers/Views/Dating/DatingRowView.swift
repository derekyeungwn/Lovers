//
//  ListRow.swift
//  Learning
//
//  Created by Derek Yeung on 18/9/2021.
//

import SwiftUI

struct DatingRowView: View {
    var dating: DatingData.Dating
    
    var body: some View {
        HStack() {
            if dating.remark != "" {
                Circle()
                    .fill(Color.green.opacity(1))
                    .frame(width: 8, height: 8)
                    .padding(.leading, -5)
            } else {
                Circle()
                    .fill(Color.green.opacity(0))
                    .frame(width: 8, height: 8)
                    .padding(.leading, -5)
            }
            VStack(alignment: .leading, spacing: 2.0) {
                Text(dating.activities.filter{activity in
                    return activity.isMain == true
                }[0].description)
                    .font(.body)
                    .lineLimit(1)
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
            .preferredColorScheme(.dark)
    }
}
