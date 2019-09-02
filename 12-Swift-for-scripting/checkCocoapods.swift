#!/usr/bin/swift

import Foundation

func path(for command: String) -> String {
    let pipe = Pipe()
    let which = Process()
    
    which.executableURL = URL(fileURLWithPath: "/usr/bin/which")
    which.arguments = [command]
    which.standardOutput = pipe
    try! which.run()
    which.waitUntilExit()
    
    return pipe.read()!
        .trimmingCharacters(in: .whitespacesAndNewlines)
}

func process(for command: String) -> Process {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: path(for: command))
    return process
}

extension Pipe {
    func read() -> String? {
        let data = self.fileHandleForReading.readDataToEndOfFile()
        
        return String(data: data, encoding: String.Encoding.utf8)
    }
}

let pipe = Pipe()
let gem = process(for: "gem")
    
gem.arguments = ["list", "-i", "cocoapods"]
gem.standardOutput = pipe
gem.terminationHandler = { (process) in
    print("Completed with exit code: \(process.terminationStatus)")
}

do {
    try gem.run()
    gem.waitUntilExit()
    print(pipe.read()!)
} catch {}
