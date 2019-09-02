#!/usr/bin/swift

import Foundation

let arguments = CommandLine.arguments.dropFirst()
var input: String = arguments.first ?? ""

if input.isEmpty {
    print("input the number of lines.")
    input = readLine() ?? "error"
}

guard let n = Int(input) else {
    FileHandle.standardError.write("Error: the argument need to be an Integer".data(using: .utf8)!)
    exit(1)
}

// print the staircase
func printRow(numberOfSpaces: Int, numberOfHash: Int) {
    var characters : [Character] = []
    
    for _ in 0..<numberOfSpaces {
        characters.append(" ")
    }
    
    for _ in 0..<numberOfHash {
        characters.append("#")
    }
    
    print(String(characters))
}

func printStaircase(numberOfRows: Int) {
    for i in 1...numberOfRows {
        printRow(numberOfSpaces: numberOfRows-i, numberOfHash: i)
    }
}

printStaircase(numberOfRows: n)
