//: [Previous](@previous)

import Foundation

struct Article: Codable {
  var id: Int
  var name: String
  var publishedDate: Date
}

let article = Article(id: 25, name: "Formated Date", publishedDate: Date())

extension DateFormatter {
  static let regularDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yyyy"
    return formatter
  }()
}

let jsonEncoder = JSONEncoder()
jsonEncoder.outputFormatting = [.prettyPrinted, .sortedKeys]
jsonEncoder.keyEncodingStrategy = .useDefaultKeys

let jsonDecoder = JSONDecoder()
jsonDecoder.keyDecodingStrategy = .useDefaultKeys

jsonEncoder.dateEncodingStrategy = .formatted(.regularDateFormatter)
let data = try article.encode(using: jsonEncoder)
data.toString().print()

jsonDecoder.dateDecodingStrategy = .formatted(.regularDateFormatter)
try Article.decode(from: data, using: jsonDecoder)

//: [Next](@next)
