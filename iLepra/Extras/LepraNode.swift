//
//  LepraNode.swift
//  iLepra
//
//  Created by Maxim Potapov on 07.04.2023.
//

import Foundation

protocol LepraNodeable: Identifiable, Hashable {
    var parentId: ID? { get }
    var unread: Bool { get }
    var created: Date { get }
}

final class LepraNode<Value: LepraNodeable>: LepraNodeable {
    var id: Value.ID { value.id }
    var parentId: Value.ID? { value.parentId }
    var unread: Bool { value.unread }
    var created: Date { value.created }
    let value: Value
    var children: [LepraNode]?

    init(value: Value, children: [LepraNode]? = nil) {
        self.value = value
    }

    static func == (lhs: LepraNode<Value>, rhs: LepraNode<Value>) -> Bool {
        lhs.value == rhs.value
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }

    static func make<T: LepraNodeable>(from values: [T]) -> [LepraNode<T>] {
        let nodes: [LepraNode<T>] = values.map { .init(value: $0) }
        let tree: [LepraNode<T>] = remap(nodes: nodes)
        let unread: [LepraNode<T>] = unread(nodes: tree)
        let sorted: [LepraNode<T>] = unread.sorted { $0.created < $1.created }
        return sorted
    }

    private static func remap<T: LepraNodeable>(nodes: [LepraNode<T>]) -> [LepraNode<T>] {
        let nodeMap: [T.ID: LepraNode<T>] = nodes.reduce(into: [:]) { result, node in
            result[node.id] = node
        }

        return nodes.reduce(into: []) { result, node in
            if let parentId = node.parentId, let parentNode = nodeMap[parentId] {
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

    private static func unread<T: LepraNodeable>(nodes: [LepraNode<T>]) -> [LepraNode<T>] {
        nodes.reduce(into: []) { result, node in
            if node.unread {
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
