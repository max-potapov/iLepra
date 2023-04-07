//
//  String+HTML.swift
//  iLepra
//
//  Created by Maxim Potapov on 07.04.2023.
//

import Foundation
import SwiftSoup

extension String {
    func htmlToMarkdown() -> Self {
        do {
            let doc = try SwiftSoup.parse(self)
            guard let body = doc.body() else { return self }

            let nodes = body.getChildNodes()
            let markdown = nodes.map { node -> String in
                do {
                    return try node.toMarkdown()
                } catch {
                    return "\(node)"
                }
            }
            .filter { !$0.isEmpty }
            .joined(separator: "  \n")

            return markdown
        } catch {
            return self
        }
    }
}

extension Node {
    func toMarkdown() throws -> String {
        switch self {
        case let element as Element:
            let text = try element.text()
            switch element.tagNameNormal() {
            case "a":
                return try "[" + element.attr("href") + "](" + element.attr("href") + ")"
            case "b":
                return "**" + text + "**"
            case "br":
                return ""
            case "i":
                return "*" + text + "*"
            case "img":
                return try "![IMAGE](" + element.attr("src") + ")"
            case "span":
                return "```" + text + "```"
            default:
                return "[" + element.tagNameNormal() + "]" + text
            }
        case let textNode as TextNode:
            return textNode.text()
        default:
            return "N/A"
        }
    }
}
