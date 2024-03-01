//
//  ToastView.swift
//  CSCIHW4
//
//  Created by Jiawei Guo on 12/2/23.
//

import SwiftUI

struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .padding()
            .background(Color.black)
            .foregroundColor(Color.white)
            .cornerRadius(10)
    }
}

