//
//  Logger.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 18/01/2026.
//

protocol Logger {
    func log(_ message: String)
    func error(_ message: String)
}

struct ConsoleLogger: Logger {
    func log(_ message: String) {
        print("ℹ️ [LOG]: \(message)")
    }

    func error(_ message: String) {
        print("❌ [ERROR]: \(message)")
    }
}
