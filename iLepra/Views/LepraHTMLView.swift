//
//  LepraHTMLView.swift
//  iLepra
//
//  Created by Maxim Potapov on 10.04.2023.
//

import SwiftSoup
import SwiftUI

struct LepraHTMLView: View {
    let html: String
    @Binding var isCompact: Bool

    var body: some View {
        if isCompact {
            #if os(iOS)
                let background = Color(.secondarySystemGroupedBackground)
            #elseif os(macOS)
                let background = Color(.textBackgroundColor)
            #endif
            content
                .frame(maxHeight: 100)
                .background(background)
                .mask(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [
                                background.opacity(1),
                                background.opacity(0),
                            ]
                        ),
                        startPoint: .init(x: 0.5, y: 0.25),
                        endPoint: .bottom
                    )
                )
                .clipped()
        } else {
            content
        }
    }

    private var content: some View {
        do {
            let doc = try SwiftSoup.parse(html)
            guard let body = doc.body() else { throw HTMLError() }
            if isCompact {
                return try Text(body.text()).eraseToAny()
            } else {
                return body.getChildNodes().toView().eraseToAny()
            }
        } catch {
            return Text(html).eraseToAny()
        }
    }
}

struct LepraHTMLView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            LepraHTMLView(
                html: "<code>hello world!</code>",
                isCompact: .constant(true)
            )
        }
    }
}
