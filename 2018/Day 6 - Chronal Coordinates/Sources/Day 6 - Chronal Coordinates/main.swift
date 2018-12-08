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

struct Point {
    let x: Int
    let y: Int
    let id: Int
}

var maxX = 0
var maxY = 0
var points : [Point] = []
for i in 0..<lines.count {
    let line = lines[i]
    let comps = line.components(separatedBy: ", ")
    let point = Point.init(x: Int(comps[1])!, y: Int(comps[0])!, id: i + 1)
    points.append(point)
    if (maxX < point.x) {
        maxX = point.x
    }

    if (maxY < point.y) {
        maxY = point.y
    }
}

let size = max(maxX, maxY) + 1
var intGrid : [[Int]] = Array<[Int]>.init(repeating: Array<Int>.init(repeating: 0, count: size), count: size)
var idGrid : [[Int]] = Array<[Int]>.init(repeating: Array<Int>.init(repeating: 0, count: size), count: size)

for point in points {
    idGrid[point.x][point.y] = point.id
    intGrid[point.x][point.y] = -1
}

var keepGoing = false
var radius = 0;

var blockedIds = Set<Int>()
var counts : [Int:Int] = [:]
for i in 0...Int.max {
    var addedAny = false

    radius += 1

    for point in points {
        if (blockedIds.contains(point.id)) {
            continue
        }

        var putAPoint = false
        for xOffset in -radius...radius {
            for yOffset in -radius...radius {
                if (abs(xOffset) + abs(yOffset) == radius) {
                    let x = point.x + xOffset
                    let y = point.y + yOffset

                    if (x < intGrid.count && x >= 0
                        && y < intGrid[x].count && y >= 0) {
                        let currentValue = intGrid[x][y]
                        let currentId = idGrid[x][y]
                        if (currentId > 0 && currentValue == radius && currentValue > -2) {
                            intGrid[x][y] = -2
                            idGrid[x][y] = -1
                        }
                        else if (currentId == 0 && currentValue >= 0) {
                            intGrid[x][y] = radius
                            idGrid[x][y] = point.id
                            putAPoint = true
                            addedAny = true
                            if let currentCount = counts[point.id] {
                                if (currentCount >= 0) {
                                    counts[point.id] = currentCount + 1
                                }
                            }
                            else {
                                counts[point.id] = 2 // because we count the middle point as 1 already
                            }
                        }
                    }
                }
            }
        }
        if (!putAPoint) {
            blockedIds.insert(point.id)
        }
    }

    if (!addedAny) {
        break
    }
}

var disqualifiedIds = Set<Int>()
for x in 0..<idGrid.count {
    let row = idGrid[x]
    for y in 0..<row.count {
        let value = row[y]
        if (x == 0 || y == 0 || idGrid.count - 1 == x || row.count - 1 == y)
            && value != -1 {
                disqualifiedIds.insert(value)
                counts[value] = 0
            }
    }
}

var largestCount = 0
var largestId = 0

let largest = counts.max(by: {a, b in
    a.value < b.value
})

print("Largest has a size of \(largest!.value)")

// Part 2

var distanceGrid : [[Int]] = Array<[Int]>.init(repeating: Array<Int>.init(repeating: 0, count: size), count: size)

var totalArea = 0
for x in 0..<idGrid.count {
    for y in 0..<idGrid[x].count {
        var totalDistance = 0
        for point in points {
            let distance = abs(point.x - x) + abs(point.y - y)
            totalDistance += distance
        }

        if (totalDistance < 10000) {
            distanceGrid[x][y] = 1
            totalArea += 1
        }
    }
}

print("Total area close to all points: \(totalArea)")