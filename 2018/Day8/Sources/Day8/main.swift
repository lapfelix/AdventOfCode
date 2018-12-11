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

let values = string.components(separatedBy: "\n")
                   .filter({$0.count != 0}).first!
                   .components(separatedBy: " ")
                   .compactMap({Int($0)})

struct Node {
    let metadataCount : Int
    let metadata : [Int]
    let childCount : Int
    var childs : [Node]
    var value : Int
}

var baseNodes : [Node]

var rawNodes : [Node]
var nodeStartPosition = 0

var metadataTotal = 0
func getNodesFromData(startPoint: Int) -> (node: [Node], endIndex: Int) {
    let childCount = values[startPoint]
    let metadataCount = values[startPoint + 1]
    var cursor = startPoint + 2

    var childs : [Node] = []

    for _ in 0..<childCount {
        let result = getNodesFromData(startPoint: cursor)
        cursor = result.endIndex
        childs.append(contentsOf: result.node)
    }

    var value = 0

    var metadatas : [Int] = []
    for i in cursor..<cursor+metadataCount {
        let metadata = values[i]
        metadatas.append(metadata)
        metadataTotal += metadata
        cursor += 1

        if (childs.count > metadata - 1) {
            value += childs[metadata - 1].value
        }
        else if (childCount == 0) {
            value += metadata
        }
    }

    let node = Node.init(metadataCount: metadataCount,
                             metadata: metadatas, childCount: childCount, childs: childs, value: value)

    return (node: [node], endIndex: cursor)
}

let nodes = getNodesFromData(startPoint: 0)
print("Part 1: \(metadataTotal)")
print("Part 2: \(nodes.node.first!.value)")