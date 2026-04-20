//
//  Logger.swift
//  FriendZone
//
//  Created by williams saadi on 03/04/2026.
//

import Foundation

class AppLogger {
    static let shared = AppLogger()
    private let logFileURL: URL
    
    private init() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        logFileURL = documentsPath.appendingPathComponent("friendzone_log.txt")
    }
    
    func log(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .long)
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "\(timestamp) [\(fileName):\(line) \(function)]: \(message)\n"
        
        #if DEBUG
        print(logMessage)
        #endif
        
        // Écrire dans le fichier (sur device réel)
        if let data = logMessage.data(using: .utf8) {
            if FileManager.default.fileExists(atPath: logFileURL.path) {
                if let fileHandle = try? FileHandle(forWritingTo: logFileURL) {
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(data)
                    fileHandle.closeFile()
                }
            } else {
                try? data.write(to: logFileURL, options: .atomic)
            }
        }
    }
    
    func getLogs() -> String {
        if FileManager.default.fileExists(atPath: logFileURL.path),
           let data = try? Data(contentsOf: logFileURL),
           let content = String(data: data, encoding: .utf8) {
            return content
        }
        return "No logs available"
    }
    
    func clearLogs() {
        if FileManager.default.fileExists(atPath: logFileURL.path) {
            try? FileManager.default.removeItem(at: logFileURL)
        }
    }
}

// Macro pratique pour le logging
func log(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    AppLogger.shared.log(message, file: file, function: function, line: line)
}

// Fonctions de logging spécifiques
func logInfo(_ message: String) {
    log("ℹ️ INFO: \(message)")
}

func logWarning(_ message: String) {
    log("⚠️ WARNING: \(message)")
}

func logError(_ message: String) {
    log("❌ ERROR: \(message)")
}

func logSuccess(_ message: String) {
    log("✅ SUCCESS: \(message)")
}

func logDebug(_ message: String) {
    #if DEBUG
    log("🐛 DEBUG: \(message)")
    #endif
}