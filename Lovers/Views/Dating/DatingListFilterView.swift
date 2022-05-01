//
//  DatingListFilterView.swift
//  Lovers
//
//  Created by Derek Yeung on 5/3/2022.
//

import SwiftUI

struct DatingListFilterView: View {
    @Binding var isPresentFilter: Bool
    @Binding var datingFilterSelection: DatingData.Dating.DatingFilterSelection
    
    var body: some View {
        Form{
            Section(header: Text("")) {
                Toggle(isOn: $datingFilterSelection.isOnlyShowRemarkRecord) {
                    Text("僅顯示有備註的約會")
                }
            }
            HStack{
                Spacer()
                Button(action: {
                    isPresentFilter = false
                }){
                    Text("搜索")
                }
                Spacer()
            }
        }
    }
}

struct DatingListFilterView_Previews: PreviewProvider {
    static var previews: some View {
        DatingListFilterView(isPresentFilter: .constant(false), datingFilterSelection: .constant(DatingData.Dating.DatingFilterSelection()))
    }
}
