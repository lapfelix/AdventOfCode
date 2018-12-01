import Foundation

// 1st half

let inputPath = "input.txt"

var string = ""

do {
    let data = try Data(contentsOf: URL(fileURLWithPath: inputPath))
    if let readString = String.init(data: data, encoding: .utf8) {
        string = readString
    }
} catch {
    print("Couldn't find file at path: \(inputPath)")
}

var result = 0
var numbers : [Int] = []
string.components(separatedBy: "\n").forEach({(value: String) in
    if let number = Int(value) {
        result += number
        numbers.append(number)
    }
    else if value.count > 0 {
        print("Failed reading number from string \"\(value)\"")
    }
})

print("Part 1:\nResult is \(result)")

// 2nd half

var frequenciesReached : [Int: Bool] = [0: true]
var currentFrequency = 0

var i = 0
while true {
    let number = numbers[i % numbers.count]

    currentFrequency += number

    if (frequenciesReached[currentFrequency] == true) {
        print("\nPart 2:\nFirst frequency reached twice is \(currentFrequency) after \(i) iterations")
        exit(0)
    } else {
        frequenciesReached[currentFrequency] = true
    }

    i += 1
}