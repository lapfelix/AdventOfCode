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

let line = string.components(separatedBy: "\n").filter({(line: String) in
    return line.count != 0
}).first!

let comps = line.components(separatedBy: " ")
let readPlayerCount = UInt(comps[0] ?? "")!
let readLastMarbleWorth = UInt(comps[6] ?? "")!

class MarbleNode {
    var prev : MarbleNode {
        get {
            return previous!
        }
        set {
            previous = newValue
        }
    }
    var next : MarbleNode {
        get {
            return nextOne!
        }
        set {
            nextOne = newValue
        }
    }

    private var previous : MarbleNode?
    private var nextOne : MarbleNode?
    var value : Int = 0

    init(prev p: MarbleNode, next n: MarbleNode) {
        previous = p
        nextOne = n
    }

    init() {
        previous = nil
        nextOne = nil
    }
}

func playerScores(playerCount: UInt, lastMarbleWorth: UInt) -> [UInt] {
    var marbles : [UInt] = []
    var currentMarbleIndex : UInt = 0
    var playerScores = Array<UInt>.init(repeating: 0, count: Int(playerCount))
    var currentPlayer : UInt = 0//UInt.max

    var rootMarble = MarbleNode.init()
    rootMarble.next = rootMarble
    rootMarble.prev = rootMarble
    var currentMarble = rootMarble
    var nextMarbleValue = 1

    while nextMarbleValue != lastMarbleWorth + 1{
        if (nextMarbleValue % 23 == 0
        && currentMarble.value > 0) {
            let marbleMinusSeven = currentMarble.prev.prev.prev.prev.prev.prev.prev

            let currentScore = playerScores[Int(currentPlayer)]
            let scoreToAdd = UInt(marbleMinusSeven.value + nextMarbleValue)
            playerScores[Int(currentPlayer)] = currentScore + scoreToAdd
            // we remove the current marble -7
            marbleMinusSeven.next.prev = marbleMinusSeven.prev
            marbleMinusSeven.prev.next = marbleMinusSeven.next
            //current marble becomes the one to the right
            currentMarble = marbleMinusSeven.next
        }
        else {

            let clockwise1Marble = currentMarble.next
            let clockwise2Marble = clockwise1Marble.next

            let newMarble = MarbleNode.init(prev: clockwise1Marble, next: clockwise2Marble)
            clockwise1Marble.next = newMarble
            clockwise2Marble.prev = newMarble
            newMarble.value = nextMarbleValue
            currentMarble = newMarble
        }

        nextMarbleValue += 1
        currentPlayer = (currentPlayer + 1) % UInt(playerCount)

        /*
        var nextMarble = rootMarble
        while true {
            if (nextMarble.value == currentMarble.value) {
                        print("[\(nextMarble.value)]", terminator: " ")

            }
            else {
                        print(nextMarble.value, terminator: " ")

            }
            if (nextMarble.next.value == rootMarble.value) {
                break
            }

            nextMarble = nextMarble.next
        }
        print("")
        */
    }

    return playerScores
}

//part 1
print("\nPart 1: Max score: \(playerScores(playerCount: readPlayerCount, lastMarbleWorth: readLastMarbleWorth).max()!)")

//part 2
print("\nPart 2: Max score: \(playerScores(playerCount: readPlayerCount, lastMarbleWorth: readLastMarbleWorth * 100).max()!)")
