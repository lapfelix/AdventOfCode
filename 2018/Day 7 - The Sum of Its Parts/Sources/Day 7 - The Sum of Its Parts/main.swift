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

struct Node {
    let name: Character
    let length: Int
    var dependencies: Set<Character>
}

var nodes: [Character: Node] = [:]
let alphabet: [Character] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"].compactMap({Character($0)})

for line in lines {
    var comps = line.replacingOccurrences(of: "Step ", with: "")
                   .replacingOccurrences(of: " can begin.", with: "")
                   .components(separatedBy: " must be finished before step ")

    let step = Character(comps[1])
    let dependencyStep = Character(comps[0])
    
    if nodes[dependencyStep] == nil {
        nodes[dependencyStep] = Node.init(name: dependencyStep, length: (alphabet.firstIndex(of: dependencyStep)!) + 61, dependencies: Set<Character>())
    }

    if var node = nodes[step] {
        node.dependencies.insert(dependencyStep)
        nodes[step] = node
    }
    else {
        nodes[step] = Node.init(name: step, length: (alphabet.firstIndex(of: step)!) + 61, dependencies: Set<Character>([dependencyStep]))
    }
}

// Navigate through the tree from our starting point
func navigate(nodesDict: [Character: Node]) -> String {
    var outString = ""
    var availableNodes = Set<Character>()
    for node in nodesDict {
        if node.value.dependencies.count == 0 {
            availableNodes.insert(node.key)
        }
    }

    if (availableNodes.count == 0) {
        return outString
    }

    var mutableNodes = nodesDict
    // execute the available nodes alphabetically
    for char in alphabet {
        if (availableNodes.contains(char)) {
            // go through all nodes and remove the one we just executed as a dependency
            for key in mutableNodes.keys {
                mutableNodes[key]!.dependencies.remove(char)
            }

            mutableNodes.removeValue(forKey: char)
            outString += String(char)
            break
        }
    }

    return outString + navigate(nodesDict: mutableNodes)
}

print("Part 1: \(navigate(nodesDict: nodes))")

struct Worker {
    var taskLength : Int
    var taskId : Character
    var working : Bool
}

var outString = ""
var nodesDict = nodes
var workers : [Worker] = Array<Worker>.init(repeating: Worker.init(taskLength: 0, taskId: " ", working: false), count: 5)

var timeElapsed = 0
while nodesDict.keys.count > 0 {
    var newWorkers: [Worker] = []
    var completedKeys: [Character] = []

    for aWorker in workers {
        var worker = aWorker
        if (worker.working) {
            worker.taskLength -= 1

            if (worker.taskLength == 0) {
                completedKeys.append(worker.taskId)
                worker.working = false
            }
        }

        newWorkers.append(worker)
    }

    workers = newWorkers

    var mutableNodes = nodesDict

    // delete tasks that were completed
    for char in completedKeys {
        // go through all nodes and remove the one we just executed as a dependency
            for key in mutableNodes.keys {
                mutableNodes[key]!.dependencies.remove(char)
            }

            mutableNodes.removeValue(forKey: char)
            outString += String(char)
    }

    var availableNodes = Set<Character>()
    for node in mutableNodes {
        if node.value.dependencies.count == 0 {
            availableNodes.insert(node.key)
        }
    }

    // execute the available nodes alphabetically

    //exclude ones already being worked on
    for worker in workers {
        if (worker.working && availableNodes.contains(worker.taskId)) {
            availableNodes.remove(worker.taskId)
        }
    }

    for char in alphabet {
        if (availableNodes.contains(char)) {
            // assign them to workers if some are available
            var newWorkers: [Worker] = []
            var foundWorker = false
            for aWorker in workers {
                var worker = aWorker
                if (!worker.working && !foundWorker) {
                    foundWorker = true
                    worker.taskId = char
                    worker.taskLength = mutableNodes[char]!.length
                    worker.working = true
                }

                newWorkers.append(worker)
            }
            workers = newWorkers
        }
    }

    timeElapsed += 1

    nodesDict = mutableNodes
}

print("Part 2:")
print("Time elapsed: \(timeElapsed)")
print(outString)

