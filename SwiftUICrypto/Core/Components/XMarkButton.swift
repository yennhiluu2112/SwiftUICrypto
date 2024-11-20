//
//  XMarkButton.swift
//  SwiftUICrypto
//
//  Created by Luu Yen Nhi on 20/11/24.
//

import SwiftUI

struct XMarkButton: View {
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }

    }
}

#Preview {
    XMarkButton()
}
