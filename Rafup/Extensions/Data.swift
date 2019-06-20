//
//  Data.swift
//  EzyParent
//
//  Created by Ashish on 06/03/18.
//  Copyright © 2018 Ashish. All rights reserved.
//

import Foundation

extension Data {
    
    func hexString() -> String {
        return self.reduce("") { string, byte in
            string + String(format: "%02X", byte)
        }
    }
}

//TODO: - These are accepted mimetype, may be chnage in future, so need to be update.
extension Data {
    
    enum MimeType : String {
        case imageJPEG              = "image/jpeg"
        case imagePNG               = "image/png"
        case imageGIF               = "image/gif"
        case imageTIFF              = "image/tiff"
        case pdf                    = "application/pdf"
        case applicationVND         = "application/vnd"
        case textPlane              = "text/plain"
        case octetStream            = "application/octet-stream"
        
        case audioMp3               = "audio/mpeg"
        case audioM4a               = "audio/x-m4a"
        case audioMidi              = "audio/midi"
        case audioOgg               = "audio/ogg"
        
        case videoMkv               = "video/mkv"
        case videoMp4               = "video/mp4"
        case videoAvi               = "video/avi"
        case videoWmv               = "video/wmv"
        case videoFlv               = "video/x-flv"
        
    }
    
    private static let mimeTypeSignatures: [UInt8 : String] = [
        0xFF : "image/jpeg",
        0x89 : "image/png",
        0x47 : "image/gif",
        0x49 : "image/tiff",
        0x4D : "image/tiff",
        0x25 : "application/pdf",
        0xD0 : "application/vnd",
        0x46 : "text/plain",
        
        0x44 : "audio/mpeg",
        0x34 : "audio/x-m4a",
        0x54 : "audio/midi",
        0x4F : "audio/ogg",
        
        0x1A : "video/mkv",
        0x00 : "video/mp4",
        0x52 : "video/avi",
        0x30 : "video/wmv",
        0x4C : "video/x-flv",
        
        ]
    
    var mimeType: MimeType {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        return Data.MimeType(rawValue: Data.mimeTypeSignatures[c] ?? "application/octet-stream") ?? MimeType.octetStream
    }
}

extension Data {
    
    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.
    
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}

