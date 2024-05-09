//
//  File.swift
//  
//
//  Created by ravendeng on 2024/5/9.
//

import Foundation
import Dispatch

struct SandBoxDataWriter {
    
    private static let semaphoreChannel = DispatchSemaphore(value: 1)
    
    static func saveDataToSandBox(searchPath: FileManager.SearchPathDirectory, path: String, _ data: Data, completion: @escaping (_ error: Error?) -> Void) {
        let fullPath = SandBoxManage.prefixPath(searchPath: searchPath).appending(path)
        DispatchQueue.global().async {
            SandBoxDataWriter.semaphoreChannel.wait()
            do {
                try SandBoxManage.createDirectoryAtPathIfNeeded(path)
                guard let handle = FileHandle(forWritingAtPath: path) else {
                    SandBoxDataWriter.semaphoreChannel.signal()
                    completion(nil)
                    return
                }
                if #available(iOS 13.4, *) {
                    try handle.seekToEnd()
                    try handle.write(contentsOf: data)
                    SandBoxDataWriter.semaphoreChannel.signal()
                    completion(nil)
                } else {
                    handle.seekToEndOfFile()
                    handle.write(data)
                    SandBoxDataWriter.semaphoreChannel.signal()
                    completion(nil)
                }
            } catch {
                SandBoxDataWriter.semaphoreChannel.signal()
                completion(error)
            }
        }
    }
}

struct SandBoxManage {
    
    static func prefixPath(searchPath: FileManager.SearchPathDirectory) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(searchPath, .userDomainMask, true)
        return paths.first ?? ""
    }
    
    static func readFileInfo(_ filePath: String) -> [FileAttributeKey : Any]? {
        return try? FileManager.default.attributesOfItem(atPath: filePath)
    }
    
    static func saveToDirectory(_ path: String, data: Data, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            let result = FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    static func readFileContent(_ filePath: String) -> Data? {
        return FileManager.default.contents(atPath: filePath)
    }
    
    static func removeFileAtPath(_ filePath: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: filePath)
            return true
        } catch {
            return false
        }
    }
    
    static func fileExistsAtPath(_ path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    static func createDirectoryAtPathIfNeeded(_ path: String) throws {
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        if fileManager.fileExists(atPath: path, isDirectory: &isDirectory) {
            return
        }
        var ret: ObjCBool = false
        try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
    }
}
