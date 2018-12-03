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

let lines = string.components(separatedBy: "\n").filter({(line: String) in
    return line.count != 0
})

struct Claim {
    let id: Int
    let startX: Int
    let startY: Int
    let sizeX: Int
    let sizeY: Int
}

var claims : [Claim] = []

for line in lines {
    let components = line.components(separatedBy: " ")
    let id = Int(components[0].replacingOccurrences(of: "#", with: ""))
    let startString = components[2].components(separatedBy: ",")
    let startX = Int(startString[0])
    let startY = Int(startString[1].replacingOccurrences(of: ":", with: ""))
    let sizeString = components[3].components(separatedBy: "x")
    let sizeX = Int(sizeString[0])
    let sizeY = Int(sizeString[1])

    claims.append(Claim.init(id: id!, startX: startX!, startY: startY!, sizeX: sizeX!, sizeY: sizeY!))
}

var array = Array.init(repeating: Array.init(repeating: 0, count: 1000), count: 1000)

var countHigherThan1 = 0

for claim in claims {
    for x in claim.startX..<claim.startX+claim.sizeX {
        for y in claim.startY..<claim.startY+claim.sizeY {
            let currentValue = array[x][y]
            array[x][y] = currentValue + 1
            if (currentValue + 1 == 2) {
                countHigherThan1 += 1
            }
        }
    }
}

print(countHigherThan1)

//part 2

var array2 = Array.init(repeating: Array.init(repeating: 0, count: 1000), count: 1000)

var overlapped : Set<Int> = Set()
for claim in claims {
    var didOverlap = false
    for x in claim.startX..<claim.startX+claim.sizeX {
        for y in claim.startY..<claim.startY+claim.sizeY {
            let currentValue = array2[x][y]
            if (currentValue != 0) {
                didOverlap = true
                overlapped.insert(currentValue)
            }
            else {
                array2[x][y] = claim.id
            }
        }
    }
    if (didOverlap) {
        overlapped.insert(claim.id)
    }
}

for claim in claims {
    if !overlapped.contains(claim.id) {
        print("No overlap for \(claim.id)")
    }
}