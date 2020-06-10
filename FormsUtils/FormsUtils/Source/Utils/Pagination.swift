//
//  Pagination.swift
//  FormsUtils
//
//  Created by Konrad on 6/9/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: Pagination
public class Pagination<ID, D> {
    public typealias OnNextPageId = (_ pagination: Pagination<ID, D>, _ page: Page<ID, D>?) -> ID?
    
    public let firstPageId: ID?
    public let limit: Int
    public private(set) var nextPageId: ID?
    public private(set) var pages: [Page<ID, D>]
    public private(set) var isLoading: Bool
    
    public var onNextPageId: OnNextPageId?
    
    public var lastPageId: ID? {
        return self.lastPage?.pageId
    }
    public var lastPage: Page<ID, D>? {
        return self.pages.last(where: { $0.error.isNil })
    }
    public var data: [D] {
        return self.pages.flatMap { $0.data }
    }
    
    public init(of type: D.Type,
                firstPageId: ID? = nil,
                limit: Int = 20,
                pages: [Page<ID, D>] = [],
                onNextPageId: OnNextPageId? = nil) {
        self.firstPageId = firstPageId
        self.limit = limit
        self.nextPageId = nil
        self.pages = pages
        self.isLoading = false
        self.onNextPageId = onNextPageId
    }
    
    public func startLoading() -> ID? {
        self.isLoading = true
        let nextPage: ID? = self.onNextPageId?(self, self.lastPage)
        return nextPage
    }
    
    public func stopLoading(_ page: Page<ID, D>) {
        self.pages.append(page)
        self.isLoading = false
    }
    
    public func reset() {
        self.nextPageId = nil
        self.pages = []
        self.isLoading = false
    }
}

// MARK: Page
public class Page<ID, D> {
    public let pageId: ID?
    public let data: [D]
    public let isLast: Bool
    public let error: Error?
    
    public init(pageId: ID?,
                data: [D],
                isLast: Bool = false,
                error: Error? = nil) {
        self.pageId = pageId
        self.data = data
        self.isLast = isLast
        self.error = error
    }
}

// MARK: Builder
public extension Pagination {
    func with(onNextPageId: @escaping OnNextPageId) -> Self {
        self.onNextPageId = onNextPageId
        return self
    }
}
