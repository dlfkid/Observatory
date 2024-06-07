//
//  File.swift
//  
//
//  Created by ravendeng on 2024/5/9.
//

import Foundation
import Dispatch

public struct SandBoxDataWriter {
    private static let semaphoreChannel = DispatchSemaphore(value: 1)
    
    public static func saveDataToSandBox(searchPath: FileManager.SearchPathDirectory, subDir: String, fileName: String, _ data: Data, completion: @escaping (_ error: Error?) -> Void) {
        let dirPath = SandBoxManage.prefixPath(searchPath: searchPath).appending(subDir)
        DispatchQueue.global().async {
            SandBoxDataWriter.semaphoreChannel.wait()
            do {
                guard SandBoxManage.createDirAtPathIfNeeded(dirPath) else {
                    SandBoxDataWriter.semaphoreChannel.signal()
                    completion(ObservatoryError.fileManage(msg: "Unable to create sub directory"))
                    return
                }
                let fullPath = dirPath.appending(fileName)
                guard SandBoxManage.createFileAtPathIfNeeded(fullPath) else {
                    SandBoxDataWriter.semaphoreChannel.signal()
                    completion(ObservatoryError.fileManage(msg: "Unable to create file"))
                    return
                }
                guard let handle = FileHandle(forWritingAtPath: fullPath) else {
                    SandBoxDataWriter.semaphoreChannel.signal()
                    completion(ObservatoryError.fileManage(msg: "Unable to create file cursor handle"))
                    return
                }
                if #available(iOS 13.4, *) {
                    try handle.seekToEnd()
                    try handle.write(contentsOf: data)
                    SandBoxDataWriter.semaphoreChannel.signal()
                    try handle.write(contentsOf: "\n".data(using: .utf8)!)
                    completion(nil)
                } else {
                    handle.seekToEndOfFile()
                    handle.write(data)
                    SandBoxDataWriter.semaphoreChannel.signal()
                    handle.write("\n".data(using: .utf8)!)
                    completion(nil)
                }
            } catch {
                SandBoxDataWriter.semaphoreChannel.signal()
                completion(error)
            }
        }
    }
}

public struct SandBoxManage {
    
    public static func prefixPath(searchPath: FileManager.SearchPathDirectory) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(searchPath, .userDomainMask, true)
        return paths.first ?? ""
    }
    
    public static func readFileContent(_ filePath: String) -> Data? {
        return FileManager.default.contents(atPath: filePath)
    }
    
    public static func removeFileAtPath(_ filePath: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: filePath)
            return true
        } catch {
            return false
        }
    }
    
    public static func fileExistsAtPath(_ path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    @discardableResult
    public static func createFileAtPathIfNeeded(_ path: String) -> Bool {
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        if fileManager.fileExists(atPath: path, isDirectory: &isDirectory) {
            return !isDirectory.boolValue
        }
        let ret = fileManager.createFile(atPath: path, contents: nil)
        return ret
    }
    
    @discardableResult
    public static func createDirAtPathIfNeeded(_ path: String) -> Bool {
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        if fileManager.fileExists(atPath: path, isDirectory: &isDirectory) {
            isDirectory.boolValue
        }
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
            return true
        } catch {
            return false
        }
    }
}
