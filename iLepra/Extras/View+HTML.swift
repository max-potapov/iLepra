//
//  View+HTML.swift
//  iLepra
//
//  Created by Maxim Potapov on 10.04.2023.
//

import SwiftSoup
import SwiftUI

#if canImport(AppKit)
    import AppKit
#endif

// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length

private struct HTMLError: Error {}

extension [Node] {
    func toView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(self, id: \.self) { node in
                node.toView()
            }
        }
    }
}

extension Node {
    func toView() -> some View {
        do {
            switch self {
            case let element as Element:
                return element.elementToView()
                    .eraseToAny()
            case let textNode as TextNode:
                return Text(textNode.text())
                    .eraseToAny()
            default:
                throw HTMLError()
            }
        } catch {
            return Text("[FIXME] \(description)")
                .eraseToAny()
        }
    }
}

extension Element {
    func elementToView() -> some View {
        do {
            let text = try text()
            switch tagNameNormal() {
            case "a":
                let link: String = try attr("href")
                if let url: URL = .init(string: link) {
                    if link.suffix(4).lowercased() == ".mp4" {
                        return LepraVideoView(url: url)
                            .eraseToAny()
                    } else {
                        return Link(text.isEmpty ? String(link.prefix(50)) : text, destination: url)
                            .onTapGesture {
                                #if os(iOS)
                                    UIApplication.shared.open(url)
                                #elseif os(macOS)
                                    NSWorkspace.shared.open(url)
                                #endif
                            }
                            .eraseToAny()
                    }
                } else {
                    return Text(link)
                        .eraseToAny()
                }
            case "b", "strong":
                return Text(text)
                    .bold()
                    .eraseToAny()
            case "br":
                return EmptyView()
                    .eraseToAny()
            case "code":
                return Text(text)
                    .foregroundColor(.green)
                    .monospaced()
                    .eraseToAny()
            case "h1", "h2", "h3":
                return Text(text)
                    .font(.title)
                    .eraseToAny()
            case "i":
                return Text(text)
                    .italic()
                    .eraseToAny()
            case "img":
                return try LepraImageView(url: .init(string: attr("src"))!)
                    .eraseToAny()
            case "p":
                return getChildNodes()
                    .toView()
                    .eraseToAny()
            case "span":
                let color: Color
                switch try className() {
                case "moderator":
                    color = .blue
                case "irony":
                    color = .red
                default:
                    color = .cyan
                }
                return Text(text)
                    .italic()
                    .foregroundColor(color)
                    .eraseToAny()
            case "sub":
                return Text(text)
                    .font(.caption2)
                    .baselineOffset(-10)
                    .eraseToAny()
            case "sup":
                return Text(text)
                    .font(.caption2)
                    .baselineOffset(10)
                    .eraseToAny()
            case "u":
                return Text(text)
                    .underline()
                    .eraseToAny()
            case "video":
                return try LepraImageView(url: .init(string: attr("data-orig"))!)
                    .eraseToAny()
            default:
                throw HTMLError()
            }
        } catch {
            return Text(description)
                .foregroundColor(.red)
                .eraseToAny()
        }
    }
}

// swiftlint:enable function_body_length
// swiftlint:enable cyclomatic_complexity
