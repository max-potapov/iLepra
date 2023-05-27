//
//  LepraReplyView.swift
//  iLepra
//
//  Created by Maxim Potapov on 28.05.2023.
//

import SwiftUI

struct LepraReplyView: View {
    @State var text: String = ""

    var body: some View {
        NavigationStack {
            TextEditor(text: $text)
                .disableAutocorrection(true)
            #if os(iOS)
                .textInputAutocapitalization(.never)
            #endif
                .onSubmit {
                    // TODO: send
                }
            #if os(macOS)
                .scrollContentBackground(.hidden)
            #endif
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.quaternary, lineWidth: 1)
                )
                .padding(8)
            #if os(iOS)
                .toolbar(.visible, for: .navigationBar)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            // TODO: dismiss
                        } label: {
                            Image(systemName: "xmark.circle")
                        }
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            // TODO: send
                        } label: {
                            Image(systemName: "paperplane")
                        }
                    }
                }
            #endif
        }
    }
}

struct LepraReplyView_Previews: PreviewProvider {
    static var previews: some View {
        LepraReplyView(
            // swiftlint:disable:next line_length
            text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vehicula id orci at ullamcorper. Nam vestibulum consequat consequat. Vivamus rutrum nulla nec bibendum ultricies. Suspendisse et condimentum augue, quis gravida dui. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus et ultrices turpis. Sed pharetra varius justo id efficitur. Etiam ultricies ante felis, vel volutpat ante semper quis."
        )
    }
}
