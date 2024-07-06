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
    
    public static func formattedDataForExport(_ filePath: URL) throws -> Data? {
        let rawContent = try String(contentsOf: filePath)
        let resultString = rawContent.trimmingCharacters(in: .whitespacesAndNewlines)
        let outputStr = removeLastComma(in: resultString)
        return String("[\(outputStr)]").data(using: .utf8)
    }
    
    private static func removeLastComma(in string: String) -> String {
        let targetEnding = "},"
        
        // Check if the string ends with "},\n"
        guard string.hasSuffix(targetEnding) else {
            return string
        }
        
        // Find the range of the last occurrence of "},\n"
        if let range = string.range(of: targetEnding, options: .backwards) {
            // Remove the last comma by creating a new substring without the comma
            let beforeTargetEnding = string[..<range.lowerBound]
            let newEnding = "}"
            return beforeTargetEnding + newEnding
        }
        
        return string
    }
    
    public static func exportSavedDataFromSandBox(searchPath: FileManager.SearchPathDirectory, subDir: String, fileNames: [String]? = nil, completion: @escaping (_ filePaths: [URL]?) -> Void) {
        let fileManager = FileManager.default
        guard let basePath = fileManager.urls(for: searchPath, in: .userDomainMask).first else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        var prefixPath = basePath
        if #available(iOS 16.0, *) {
            prefixPath = basePath.appending(path: subDir, directoryHint: .isDirectory)
        } else {
            prefixPath = basePath.appendingPathComponent(subDir, isDirectory: true)
        }
        guard let fileNames = fileNames, fileNames.count > 0 else {
            // if no filename as parameter were passed, just acquire all the file within subdir
            do {
                let fileNames = try fileManager.contentsOfDirectory(atPath: prefixPath.path)
                if fileNames.count > 0 {
                    // files acquired, recursion again
                    exportSavedDataFromSandBox(searchPath: searchPath, subDir: subDir, fileNames: fileNames, completion: completion)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            return
        }
        DispatchQueue.global().async {
            var results = [URL]()
            semaphoreChannel.wait()
            for fileName in fileNames {
                guard fileName != ".DS_Store" else {
                    continue
                }
                var fullPath = prefixPath
                if #available(iOS 16.0, *) {
                    fullPath = prefixPath.appending(path: fileName, directoryHint: .notDirectory)
                } else {
                    fullPath = prefixPath.appendingPathComponent(fileName, isDirectory: false)
                }
                guard fullPath.pathExtension != ".obtemp" else {
                    continue
                }
                var isDir: ObjCBool = false
                guard fileManager.fileExists(atPath: fullPath.path, isDirectory: &isDir) else {
                    continue
                }
                if isDir.boolValue == true {
                    continue
                }
                results.append(fullPath)
            }
            semaphoreChannel.signal()
            DispatchQueue.main.async {
                completion(results)
            }
        }
    }
    
    public static func saveDataToSandBox(searchPath: FileManager.SearchPathDirectory, subDir: String, fileName: String, _ data: Data, completion: @escaping (_ error: Error?) -> Void) {
        let dirPath = SandBoxManage.prefixPath(searchPath: searchPath).appending(subDir)
        DispatchQueue.global().async {
            SandBoxDataWriter.semaphoreChannel.wait()
            do {
                guard SandBoxManage.createDirAtPathIfNeeded(dirPath) else {
                    SandBoxDataWriter.semaphoreChannel.signal()
                    DispatchQueue.main.async {
                        completion(ObservatoryError.fileManage(msg: "Unable to create sub directory"))
                    }
                    return
                }
                let fullPath = dirPath.appending(fileName).appending(".obtemp")
                guard SandBoxManage.createFileAtPathIfNeeded(fullPath) else {
                    SandBoxDataWriter.semaphoreChannel.signal()
                    DispatchQueue.main.async {
                        completion(ObservatoryError.fileManage(msg: "Unable to create file"))
                    }
                    return
                }
                guard let handle = FileHandle(forWritingAtPath: fullPath) else {
                    SandBoxDataWriter.semaphoreChannel.signal()
                    DispatchQueue.main.async {
                        completion(ObservatoryError.fileManage(msg: "Unable to create file cursor handle"))
                    }
                    return
                }
                if #available(iOS 13.4, *) {
                    try handle.seekToEnd()
                    try handle.write(contentsOf: data)
                    try handle.write(contentsOf: ",\n".data(using: .utf8)!)
                    SandBoxDataWriter.semaphoreChannel.signal()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    handle.seekToEndOfFile()
                    handle.write(data)
                    handle.write(",\n".data(using: .utf8)!)
                    SandBoxDataWriter.semaphoreChannel.signal()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } catch {
                SandBoxDataWriter.semaphoreChannel.signal()
                DispatchQueue.main.async {
                    completion(error)
                }
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
            return true
        }
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
            return true
        } catch {
            return false
        }
    }
}
