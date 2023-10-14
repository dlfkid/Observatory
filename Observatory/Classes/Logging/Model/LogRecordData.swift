//
//  LogRecordData.swift
//  Observatory
//
//  Created by LeonDeng on 2023/10/5.
//

import Foundation

struct LogRecordData {
    let timeUnixNano: TimeInterval
    let body: Data
    let traceID: Data
    let spanID: Data
    
}
