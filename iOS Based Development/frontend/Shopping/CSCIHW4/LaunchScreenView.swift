//
//  LaunchScreenView.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 11/14/23.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Powered by")
                    .font(.headline) // font style of the words
                    .foregroundColor(.black) // color

                Image("eBayLogo") //
                    .resizable() // zoom in / out the image
                    .scaledToFit() // keep
                    .frame(width: 100, height: 50) // size of the pic
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}


#Preview {
    LaunchScreenView()
}
