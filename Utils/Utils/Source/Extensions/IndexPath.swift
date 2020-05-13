//
//  IndexPath.swift
//  Utils
//
//  Created by Konrad on 4/10/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: IndexPath
public extension IndexPath {
    func advanced(_ indexPath: IndexPath) -> Self {
        return self.advanced(
            row: indexPath.row,
            section: indexPath.section)
    }
    
    func advanced(row: Int = 0,
                  section: Int = 0) -> Self {
        return IndexPath(
            row: self.row + row,
            section: self.section + section)
    }
    
    func range(to endIndex: IndexPath) -> [IndexPath] {
        let startIndex: IndexPath = self
        guard startIndex.section <= endIndex.section else { return [] }
        guard startIndex.row <= endIndex.row else { return [] }
        var indexes: [IndexPath] = []
        for s in startIndex.section...endIndex.section {
            for r in startIndex.row...endIndex.row {
                indexes.append(IndexPath(row: r, section: s))
            }
        }
        return indexes
    }
}
