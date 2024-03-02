//
//  ReadableSpan.swift
//  Observatory
//
//  Created by LeonDeng on 2024/1/6.
//

import Foundation

public struct ReadableSpan {
    
    private let internalSpan: Span
    
    init(internalSpan: Span) {
        self.internalSpan = internalSpan
    }
}
