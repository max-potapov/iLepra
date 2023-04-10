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

    var body: some View {
        if let doc = try? SwiftSoup.parse(html), let body = doc.body() {
            body.getChildNodes().toView()
        } else {
            Text(html)
        }
    }
}

struct LepraHTMLView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            LepraHTMLView(
                html: "<code>hello world!</code>"
            )
        }
    }
}
