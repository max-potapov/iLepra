//
//  LepraSheetView.swift
//  iLepra
//
//  Created by Maxim Potapov on 29.04.2023.
//

import SwiftUI

struct LepraSheetView<Content: View>: View {
    @Environment(\.dismiss) private var dismiss
    @ViewBuilder private var content: Content
    private let detent: PresentationDetent

    var body: some View {
        VStack {
            content
            #if os(macOS)
                Button("Закрыть") {
                    dismiss()
                }
                .padding()
            #endif
        }
        .presentationDragIndicator(.visible)
        .presentationDetents([detent])
        .onTapGesture {
            dismiss()
        }
        #if os(macOS)
        .frame(minWidth: 500, minHeight: 500)
        #endif
    }

    @inlinable
    init(_ detent: PresentationDetent = .large, @ViewBuilder content: @escaping () -> Content) {
        self.detent = detent
        self.content = content()
    }
}

struct LepraSheetView_Previews: PreviewProvider {
    static var previews: some View {
        LepraSheetView {
            Text("kek")
        }
    }
}
