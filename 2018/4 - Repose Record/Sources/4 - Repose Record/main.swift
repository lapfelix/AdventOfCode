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

struct Event {
    let date : Date
    let minute : Int
    let content : String
}

// we need to sort first
var events : [Event] = []

let df = DateFormatter()
df.dateFormat = "'['y-MM-dd HH:mm"
let cal = Calendar.current

for line in lines {
    let comp = line.components(separatedBy: "]")
    let dateString = comp[0]

    guard let date = df.date(from: dateString) else {
        print("Failed to parse: \(dateString)")
        break
    }

    let minute = cal.component(.minute, from: date)
    
    events.append(Event.init(date: date, minute: minute, content: String(comp[1].dropFirst())))
}

events.sort(by: {(event1, event2) in 
    return event1.date < event2.date
})

struct Guard {
    let id : Int
    var minutes : [Int] = Array.init(repeating: 0, count: 60)
}

var guards : [Int: Guard] = [:]

var currentGuardId : Int = 0
var sleeps = false
var startSleepMinute = -1
for event in events {
    if (event.content == "wakes up") {
        sleeps = false
    } 
    else if (event.content == "falls asleep") {
        sleeps = true
        startSleepMinute = event.minute
    }
    else {
        if !sleeps && currentGuardId != 0 && startSleepMinute != -1 {
        var guardian = guards[currentGuardId]
        if (guardian == nil) {
            guardian = Guard.init(id: currentGuardId, minutes: Array.init(repeating: 0, count: 60))
        }

        guard var mutableGuard = guardian else { break }
        
        for i in max(0, startSleepMinute)..<event.minute {
            mutableGuard.minutes[i] += 1
        }

        guards[currentGuardId] = mutableGuard
        startSleepMinute = -1
    }
        // ugh we need to parse

        guard let id = Int(event.content.components(separatedBy: "#")[1].components(separatedBy: " ")[0]) else {
            print("can't parse id \(event.content)")
            break
        }
        sleeps = false
        currentGuardId = id
    }

    if !sleeps && currentGuardId != 0 && startSleepMinute != -1 {
        var guardian = guards[currentGuardId]
        if (guardian == nil) {
            guardian = Guard.init(id: currentGuardId, minutes: Array.init(repeating: 0, count: 60))
        }

        guard var mutableGuard = guardian else { break }
        
        for i in max(0, startSleepMinute)..<event.minute {
            mutableGuard.minutes[i] += 1
        }

        guards[currentGuardId] = mutableGuard
        startSleepMinute = -1
    }
}

var sleepyGuardian : Guard?
var consistentGuardian : Guard?
var mostSlept = 0

var mostSleptMin = 0
var mostSleptMinuteIndexTotal = 0

var mostPopMin = 0
var mostPopMinuteIndexTotal = 0

for guardian in guards.values {
    var totalSlept = 0
    var mostSleptMinute = 0
    var mostSleptMinuteIndex = 0
    for i in 0..<60 {
        var minute = guardian.minutes[i]
        totalSlept += minute
        if (mostSleptMinute < minute) {
            mostSleptMinute = minute
            mostSleptMinuteIndex = i
        }
    }

    if (totalSlept > mostSlept) {
        sleepyGuardian = guardian
        mostSlept = totalSlept
        //mostSleptMin = mostSleptMinute
        mostSleptMinuteIndexTotal = mostSleptMinuteIndex
    }

    if (mostSleptMinute > mostPopMin) {
        consistentGuardian = guardian
        mostPopMin = mostSleptMinute
        mostPopMinuteIndexTotal = mostSleptMinuteIndex
    }
}

// part 1
print("Sleepiest guardian is \(sleepyGuardian!.id).\n" + 
      "He slept \(mostSlept) minutes total.\n" +
      "Most slept minute is minute \(mostSleptMinuteIndexTotal).\n" +
      "Result is therefore \(sleepyGuardian!.id * mostSleptMinuteIndexTotal)")

// part 2
print("\nPart 2:\n\n" +
      "Most consistent guardian is \(consistentGuardian!.id).\n" + 
      "He slept \(mostSlept) minutes total.\n" +
      "Most slept minute is minute \(mostPopMinuteIndexTotal).\n" +
      "Result is therefore \(consistentGuardian!.id * mostPopMinuteIndexTotal)")