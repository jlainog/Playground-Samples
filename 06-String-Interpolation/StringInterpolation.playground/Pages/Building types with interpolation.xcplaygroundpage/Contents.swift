//: [Previous](@previous)
import UIKit
import Foundation

//: # [ExpressibleByStringInterpolation](https://developer.apple.com/documentation/swift/expressiblebystringinterpolation)


struct ReadMe: CustomStringConvertible, ExpressibleByStringLiteral {
    var markdown: String
    var description: String {
        return markdown
    }
    
    init(stringLiteral value: String) {
        self.markdown = value
    }
}

extension ReadMe: ExpressibleByStringInterpolation {
    typealias StringInterpolation = ReadMe
    
    init(stringInterpolation: ReadMe) {
        self.markdown = stringInterpolation.markdown
    }
}

extension ReadMe: StringInterpolationProtocol {
    init(literalCapacity: Int, interpolationCount: Int) {
        markdown = ""
    }
    
    mutating func appendLiteral(_ literal: String) {
        markdown += literal
    }
    
    mutating func appendInterpolation(h1: String) {
        let literal = "# " + h1
        
        appendLiteral(literal)
    }
    
    mutating func appendInterpolation(h2: String) {
        let literal = "## " + h2
        
        appendLiteral(literal)
    }

    mutating func appendInterpolation(blockquote: String) {
        let literal = "> \(blockquote)"
        
        appendLiteral(literal)
    }
    
    mutating func appendInterpolation(reference title: String,
                                      link: String,
                                      comment: String? = nil) {
        let literal = "* [\(title)](\(link))"
            + (comment != nil ? " - \(comment!)" : "")
        
        appendLiteral(literal)
    }
}

let readMeMD: ReadMe = """
\(h1: "Swift Interpolation")
Some Content you may like to use here
\(blockquote: "Try out different ways to express string literals using the new Swift 5 string interpolation API.")
\(h2: "References")
\(reference: "Interpolation", link: "http://Wiki.com/Interpolation", comment: "Check Here more info")
\(reference: "Interpolation part 2", link: "http://Wiki.com/Interpolation", comment: "Check Here more info")
\(reference: "String Interpolation in Swift 5", link: "https://talk.objc.io/episodes/S01E143-string-interpolation-in-swift-5")
"""

print(readMeMD)




//: [Next](@next)
