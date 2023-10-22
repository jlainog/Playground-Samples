import Foundation

let bullet =
isRoot && (count == 0 || !willExpand) ? ""
: count == 0    ? "- "
: maxDepth <= 0 ? "▹ " : "▿ "

let bullet1 =
if isRoot && (count == 0 || !willExpand) { "" }
else if count == 0 { "- " }
else if maxDepth <= 0 { "▹ " }
else { "▿ " }

let attributedName =
if let displayName, !displayName.isEmpty,
   let markdown = try? AttributedString(markdown: displayName) {
    markdown
} else {
    AttributedString(stringLiteral: "Untitled")
}

//: [Next](@next)


