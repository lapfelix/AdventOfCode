import Foundation

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
var twoLettersCount = 0
var threeLettersCount = 0

let lines = string.components(separatedBy: "\n").filter({(line: String) in
    return line.count != 0
})

lines.forEach({(line: String) in
    var dict : [Character: Int] = [:]
    for character in line {
        if let currentCharCount = dict[character] {
            dict[character] = currentCharCount + 1
        } else {
            dict[character] = 1
        }
    }

    var hasTwo = false
    var hasThree = false

    for key in dict.keys {
        if (dict[key] == 2) {
            hasTwo = true
        }

        if (dict[key] == 3) {
            hasThree = true
        }
    }

    if (hasTwo) {
        twoLettersCount += 1
    }

    if (hasThree) {
        threeLettersCount += 1
    }
})

let checksum = twoLettersCount * threeLettersCount
print("Two: \(twoLettersCount)\nThree: \(threeLettersCount)\nChecksum: \(checksum)")

//part 2

struct Diff {
    let line : String
    let diffCount : Int
}

var diffDict : [String: Diff] = [:]
var lowestDiff = Int.max
var lowestString1 = ""
var lowestString2 = ""

for line in lines {
    var bestDiffCount = Int.max
    var bestCompared = ""
    for compared in lines {
        var diffCount = 0
        for i in 0..<line.count {
            let char1 = line[line.index(line.startIndex, offsetBy: i)]
            let char2 = compared[compared.index(compared.startIndex, offsetBy: i)]
            if (char1 != char2) {
                diffCount += 1
            }   
        }

        if (diffCount < bestDiffCount && diffCount != 0) {
            bestDiffCount = diffCount
            bestCompared = compared
        }
    }

    if (bestDiffCount < lowestDiff) {
        lowestDiff = bestDiffCount
        lowestString1 = line
        lowestString2 = bestCompared
    }
}

var final = ""
for i in 0..<lowestString1.count {
    let char1 = lowestString1[lowestString1.index(lowestString1.startIndex, offsetBy: i)]
    let char2 = lowestString2[lowestString2.index(lowestString2.startIndex, offsetBy: i)]
    if (char1 == char2) {
        final += String(char1)
    }   
}

print("l1: \(lowestString1)\nl2: \(lowestString2)\nn: \(lowestDiff)")
print("Common letters for most common string: \(final)")
print(final.dropFirst(3))