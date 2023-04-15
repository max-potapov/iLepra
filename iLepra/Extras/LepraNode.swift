//
//  LepraNode.swift
//  iLepra
//
//  Created by Maxim Potapov on 07.04.2023.
//

import Foundation

final class LepraNode: Identifiable, Hashable {
    var id: LepraComment.ID { value.id }
    let value: LepraComment
    var children: [LepraNode]?

    init(value: LepraComment, children: [LepraNode]? = nil) {
        self.value = value
    }

    static func == (lhs: LepraNode, rhs: LepraNode) -> Bool {
        lhs.value == rhs.value
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }

    static func make(from values: [LepraComment], sortByDate: Bool, showUnreadOnly: Bool) -> [LepraNode] {
        let nodes: [LepraNode] = values.map { .init(value: $0) }
        let tree: [LepraNode] = remap(nodes: nodes)
        let unread: [LepraNode] = showUnreadOnly ? unread(nodes: tree) : tree
        let sorted: [LepraNode] = sortByDate
            ? unread.sorted { $0.value.dateOrder < $1.value.dateOrder }
            : unread.sorted { $0.value.ratingOrder < $1.value.ratingOrder }

        return sorted
    }

    private static func remap(nodes: [LepraNode]) -> [LepraNode] {
        let nodeMap: [LepraComment.ID: LepraNode] = nodes.reduce(into: [:]) { result, node in
            result[node.id] = node
        }

        return nodes.reduce(into: []) { result, node in
            if let parentId = node.value.parentId, let parentNode = nodeMap[parentId] {
                if parentNode.children != nil {
                    parentNode.children?.append(node)
                } else {
                    parentNode.children = [node]
                }
            } else {
                result.append(node)
            }
        }
    }

    private static func unread(nodes: [LepraNode]) -> [LepraNode] {
        nodes.reduce(into: []) { result, node in
            if node.value.unread {
                result.append(node)
            } else if let children = node.children {
                let unreadChildren = unread(nodes: children)
                if !unreadChildren.isEmpty {
                    node.children = unreadChildren
                    result.append(node)
                }
            }
        }
    }
}
