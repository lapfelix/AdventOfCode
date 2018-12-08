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

guard let line = string.components(separatedBy: "\n").filter({(line: String) in
    return line.count != 0
}).first else { exit(0) }

let strArray : [UInt8] = []

extension String {
    func at(_ i: Int) -> Character? {
        if (i < 0 || i >= count) {
            return nil
        }
        
        return self[index(startIndex, offsetBy: i)]
    }
}

extension Character {
    var isAscii: Bool {
        return unicodeScalars.first?.isASCII == true
    }
    var ascii: UInt32? {
        return isAscii ? unicodeScalars.first?.value : nil
    }
}

extension StringProtocol {
    var ascii: [UInt32] {
        return compactMap { $0.ascii }
    }
}

var lineNum = line.ascii

func findCouples(_ str: [UInt32]) -> [UInt32] {
    var startOver = false
    var skipNext = false
    var out = ""
    
    var string = str

    var i = -1
    while i < string.count {

        i += 1
        guard !skipNext else { skipNext = false; continue }

        guard string.count > i+1 else { break; }

        let a = string[i]
        let b = string[i+1]

        if (abs(Int(a) - Int(b)) == 32) {
            startOver = true

            string.remove(at: i)
            string.remove(at: i)
            i -= 1
        }
    }

    if (startOver) {
        return findCouples(string)
    }
    else {
        return string
    }
}

let result = findCouples(lineNum)

var str = ""
for num in result {
    str.append(Character(UnicodeScalar(num)!))
}

// part 1

print("Part 1: \(str.count)")


//part 2

var least = Int.max
for i in 65...90 {
    var treated = lineNum.filter({(num) in 
        return num != i && num - 32 != i
    })

    let count = findCouples(treated).count
    if (count < least) {
        least = count
    }
}

print("Part 2: \(least)")

