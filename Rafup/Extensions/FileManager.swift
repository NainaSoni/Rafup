//
//  FileManager.swift
//  Underwrite-it
//
//  Created by Ashish on 20/06/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import UIKit

extension FileManager {
    
    /// Application's home (top-level) directory
    public var homeURL : URL? {
        return URL(fileURLWithPath: NSHomeDirectory())
    }
    
    ///    Put user data in `Documents/`.
    ///    User data generally includes any files you might want to expose to the user—anything you might want the user to create, import, delete or edit.
    public var documentsURL : URL? {
        let paths =    urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first
    }
    
    static var documentPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
    
    static func documentPathForFile(_ named: String) -> String {
        return (documentPath as NSString).appendingPathComponent(named)
    }
    
    /// Put app-created support files in the `Library/Application support/` directory.
    ///    In general, this directory includes files that the app uses to run but that should remain hidden from the user.
    ///    This directory can also include data files, configuration files, templates and modified versions of resources loaded from the app bundle.
    public var applicationSupportURL : URL? {
        let paths =    urls(for: .applicationSupportDirectory, in: .userDomainMask)
        return paths.first
    }
    
    ///    Put temporary data in the `tmp/` directory.
    ///    Temporary data comprises any data that you do not need to persist for an extended period of time.
    ///    Remember to delete those files when you are done with them so that they do not continue to consume space on the user’s device.
    ///    The system will periodically purge these files when your app is not running; therefore, you cannot rely on these files persisting after your app terminates.
    public var temporaryURL : URL? {
        return homeURL?.appendingPathComponent("tmp", isDirectory: true)
        //        let path = try? url(for: .itemReplacementDirectory, in: .userDomainMask, appropriateFor: homeURL, create: true)
        //        return path
    }
    
    ///    Put data cache files in the `Library/Caches/` directory.
    ///    Cache data can be used for any data that needs to persist longer than temporary data, but not as long as a support file.
    ///
    ///    Generally speaking, the application does not require cache data to operate properly, but it can use cache data to improve performance.
    ///    Examples of cache data include (but are not limited to) database cache files and transient, downloadable content.
    ///    Note that the system may delete the `Caches/` directory to free up disk space, so your app must be able to re-create or download these files as needed.
    public var cacheURL : URL? {
        let paths =    urls(for: .cachesDirectory, in: .userDomainMask)
        return paths.first
    }
    
    
    public func printCommonURLs() {
        if let url = homeURL {
            print("Home:\n\(url)\n")
        }
        if let url = documentsURL {
            print("Documents:\n\(url)\n")
        }
        if let url = applicationSupportURL {
            print("ApplicationSupport:\n\(url)\n")
        }
        if let url = temporaryURL {
            print("Tmp:\n\(url)\n")
        }
        if let url = cacheURL {
            print("Caches:\n\(url)\n")
        }
    }
    
    public func lookupOrCreate(directoryAt url: URL) -> Bool {
        
        //    must use ObjCBool as the method method expects that. (yikes)
        var isDirectory : ObjCBool = false
        
        //    check if something exists with the supplied path
        if fileExists(atPath: url.path, isDirectory: &isDirectory) {
            //    if this is directory
            if isDirectory.boolValue {
                //    then all is fine
                return true
            }
            //    otherwise it's a file, so report back that it's NOT ok
            return false
        }
        
        //    ok, nothing exists at this path, so create this folder
        do {
            //    also create all required folders in between
            try createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            print(error)
            return false
        }
        
        return true
    }
    
    func fileSize(atPath path: String) -> Int64 {
        return (try? attributesOfItem(atPath: path)[.size] as! Int64) ?? 0
    }
    
    func folderSize(atPath path: String) -> Int64 {
        var size: Int64 = 0
        do {
            for file in try subpathsOfDirectory(atPath: path) {
                size += fileSize(atPath: (path as NSString).appendingPathComponent(file) as String)
            }
        } catch {
            print("Error reading directory.")
        }
        return size
    }
    
    static func contentsOfDirectory(atPath path: String) -> [String]? {
        guard let paths = try? FileManager.default.contentsOfDirectory(atPath: path) else { return nil}
        return paths.map { aContent in (path as NSString).appendingPathComponent(aContent)}
    }
    
    @discardableResult
    static func removeItem(atPath path: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    static func removeItem(at url: URL) -> Bool {
        return removeItem(atPath: url.path)
    }
    
    @discardableResult
    static func removeAllItemsInsideDirectory(atPath path: String) -> Bool {
        let enumerator = FileManager.default.enumerator(atPath: path)
        var result = true
        
        while let fileName = enumerator?.nextObject() as? String {
            let success = removeItem(atPath: path + "/\(fileName)")
            if !success { result = false }
        }
        
        return result
    }
    
    @discardableResult
    static func removeAllItemsInsideDirectory(at url: URL) -> Bool {
        return removeAllItemsInsideDirectory(atPath: url.path)
    }
    
    static func bundlePathForFile(_ named: String) -> String {
        return (Bundle.main.bundlePath as NSString).appendingPathComponent(named)
    }
    
    static func bundlePathForFile(_ named: String, type: String) -> String? {
        return Bundle.main.path(forResource: named, ofType: type)
    }
    
    static func bundleURLForFile(_ named: String, type: String) -> URL? {
        guard let path = bundlePathForFile(named, type: type) else { return nil }
        return URL(fileURLWithPath: path)
    }
    
    @discardableResult
    static func deleteFileWithPath(_ path: String) -> Bool {
        let exists = FileManager.default.fileExists(atPath: path)
        if exists {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch {
                debugPrint("error: \(error.localizedDescription)")
                return false
            }
        }
        return exists
    }
    
    // MARK:- Download File Method
    static func downloadFile(fromUrl:String, complition: ((_ tempURL: URL) -> Void)?) {
        guard let url = URL(string: fromUrl) else { return }
        
        URLSession.shared.downloadTask(with: url) { (urls, response, error) in
            if error != nil {
                print(error!)
                return
            }
            if let tempUrls = urls {
                complition?(tempUrls)
            }
            }.resume()
    }

    // MARK:- Move File to document directory with new name
    static func moveFileToDocumentDirectory(from:URL, nameWithExtension:String) {
        do {
            let path = documentPath
            let documentDirectory = URL(fileURLWithPath: path)
            let destinationPath = documentDirectory.appendingPathComponent(nameWithExtension)
            try FileManager.default.moveItem(at: from, to: destinationPath)
        } catch {
            print(error)
        }
    }
    
    // MARK:- Check file exits in document directory with name or not.
    static func isFileExistsInDocumentDirectoryWith(nameWithExtension:String) -> Bool {
        let path = documentPath
        let documentDirectory = URL(fileURLWithPath: path)
        let destinationPath = documentDirectory.appendingPathComponent(nameWithExtension)
        return FileManager.default.fileExists(atPath: "\(destinationPath)")
    }
    
    /// Delete file in Documents Path
    ///
    /// - parameter named: name of the file
    ///
    /// - returns: success or failed
    @discardableResult
    static func deleteFileWithName(_ named: String) -> Bool {
        let path = documentPath + named
        return deleteFileWithPath(path)
    }
    
    static func clearTempDirectory() {
        do {
            try tempContents.forEach() {
                try FileManager.default.removeItem(atPath: $0)
            }
        } catch {}
    }
    
    static var tempContents: [String] {
        let paths = (try? FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory())) ?? []
        return paths.map() {
            return (NSTemporaryDirectory() as NSString).appendingPathComponent($0)
        }
    }
    
    static func isDirectoryFor(_ path: String) -> Bool {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
    
    static var libraryPath: String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
    }
    
    static func libraryPathForFile(_ named: String) -> String {
        return (libraryPath as NSString).appendingPathComponent(named)
    }
    
}


var GlobalMainQueue: DispatchQueue {
    return DispatchQueue.main
}

var GlobalQuene: DispatchQueue {
    return DispatchQueue.global(qos: .default)
}

var GlobalUserInteractiveQueue: DispatchQueue {
    return DispatchQueue.global(qos: .userInteractive)
}

var GlobalUserInitiatedQueue: DispatchQueue {
    return DispatchQueue.global(qos: .userInitiated)
}

var GlobalUtilityQueue: DispatchQueue {
    return DispatchQueue.global(qos: .utility)
}

var GlobalBackgroundQueue: DispatchQueue {
    return DispatchQueue.global(qos: .background)
}


extension FileManager {
    
    static func fetchRootDirectoryForiCloud(completion: @escaping (URL?) -> ()) {
        GlobalQuene.async {
            guard let url = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") else {
                GlobalMainQueue.async {
                    completion(nil)
                }
                return
            }
            
            if !FileManager.default.fileExists(atPath: url.path, isDirectory: nil) {
                print("create directory")
                do {
                    try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print(error)
                }
            }
            
            GlobalMainQueue.async {
                completion(url)
            }
        }
    }
    
    static func documentPath(forResource: String, of type: String) -> URL {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let resourcePath = ((documentsDirectory as NSString).appendingPathComponent(forResource) as NSString).appendingPathExtension(type)
        return URL(fileURLWithPath: resourcePath!)
    }
}
