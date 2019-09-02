# Swift Script
Have you notice on pages like HackerRank you can add your code as a "Staircase.swift" file.  Let see an example:
```swift
import Foundation

// read the integer n
let n = Int(readLine()!)!

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
```
Now you can simple call it with `swift Staircase.swift`  in the terminal. This will wait for an input of type `Int` due to the code `readLine()` and once you type it you have: 
```bash
swift Staircase.swift   
7
      #
     ##
    ###
   ####
  #####
 ######
#######
```
Just like that you can call a swift file.

## Let’s turn it into a script.
First we need to add the path where swift is so the file is compiled using swift. This [shebang](https://bash.cyberciti.biz/guide/Shebang) indicate an interpreter for execution.
```sh
#!/usr/bin/swift
```
Second we need to make it executable
```sh
Chmod u+x Staircase.swift
```
And finally we can execute it:
```sh
./Staircase.swift
```
Notice that  `readLine()` expect an input so add the line before to print a message:
```swift
print("input the number of lines.")
let n = Int(readLine()!)!
```
If we want pass arguments during the call we use [CommandLine](https://developer.apple.com/documentation/swift/commandline) . To check the arguments passed add this line to the top of the file:
```swift
dump(CommandLine.arguments)
```
You see that each argument passed is dumped.
```swift
./Staircase.swift 8 5 6 jaime 
▿ 5 elements
  - "./Staircase.swift"
  - "8"
  - "5"
  - "6"
  - "jaime"
```
What if I want to use the argument if passed or ask for it if not… also if the argument passed is not a integer present an error and stop execution. For that we use [FileHandle.standardError](https://developer.apple.com/documentation/foundation/filehandle/1411001-standarderror):
```swift
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
```

 
## Handle executions of other commands
To execute a command we need to instantiate a [Process](https://developer.apple.com/documentation/foundation/process) , what if we want for example to check if  `Cocoapods`  gem is installed.
```swift
let gem = Process()
gem.executableURL = URL(fileURLWithPath: "/usr/bin/gem")
gem.arguments = ["list", "-i", "cocoapods"]
try gem.run()
```
Here we run the Gem command and pass the arguments to check if   `Cocoapods`  is available. 

To capture the output of the command we need to use a [Pipe](https://developer.apple.com/documentation/foundation/pipe) and pass it to  the process.
```swift
let gem = Process()
let pipe = Pipe()
gem.standardOutput = pipe
```

And to read it we call `fileHandleForReading.readDataToEndOfFile()` to get the data and covert it to string for example. We can create an extension to easily read the output as a string.
```swift
extension Pipe {
    func read() -> String? {
        let data = self.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: String.Encoding.utf8)
    }
}
```

## Checking the path for a command
If you want to check the path for a command you can use `which`. but since we are working with swift why not create a func that use it to retrieve the path you need.
```swift
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
```

## Finally 
To finish we can use all the mentioned before to create a func to retrieve a process for a command and then use it for our script to check for `cocoapods`
```swift
func process(for command: String) -> Process {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: path(for: command))
    return process
}

let pipe = Pipe()
let gem = process(for: "gem")
    
gem.arguments = ["list", "-i", "cocoapods"]
gem.standardOutput = pipe

do {
    try gem.run()
    gem.waitUntilExit()
    print(pipe.read()!)
} catch {}
```

### References
* [NSHipster - Swift-sh](https://nshipster.com/swift-sh/)
* [swift-sh](https://github.com/mxcl/swift-sh)
* [Scripting in Swift](https://krakendev.io/blog/scripting-in-swift)
* [Using Swift for Scripting](https://rderik.com/blog/using-swift-for-scripting/)
