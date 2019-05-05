/*:
 # [String Interpolation](https://docs.swift.org/swift-book/LanguageGuide/StringsAndCharacters.html)
 
 It is the process of evaluating a string literal containing one or more placeholders, yielding a result in which the placeholders are replaced with their corresponding values.
 String interpolation allows easier and more intuitive string formatting and content-specification compared with string concatenation.
 
 String interpolation is a way to construct a new String value from a mix of constants, variables, literals, and expressions by including their values inside a string literal. You can use string interpolation in both single-line and multiline string literals. Each item that you insert into the string literal is wrapped in a pair of parentheses, prefixed by a backslash (\):
 ```
 let multiplier = 3
 let message = "\(multiplier) times 2.5 is \(Double(multiplier) * 2.5)"
 // message is "3 times 2.5 is 7.5"
 ```
 In the example above, the value of multiplier is inserted into a string literal as \(multiplier). This placeholder is replaced with the actual value of multiplier when the string interpolation is evaluated to create an actual string.
 
 The value of multiplier is also part of a larger expression later in the string. This expression calculates the value of Double(multiplier) * 2.5 and inserts the result (7.5) into the string. In this case, the expression is written as \(Double(multiplier) * 2.5) when it’s included inside the string literal.
 */
//: [Next](@next)
