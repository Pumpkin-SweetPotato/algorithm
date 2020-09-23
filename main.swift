//
//  test.swift
//  
//
//  Created by eazel7 on 2020/09/14.
//

import Foundation

class Node {
  var visited = false
  var connections: [Connection] = []
}

class Connection {
  public let to: Node
  public let weight: Int
  
  public init(to node: Node, weight: Int) {
    assert(weight >= 0, "weight has to be equal or greater than zero")
    self.to = node
    self.weight = weight
  }
}

class Path {
  public let cumulativeWeight: Int
  public let node: Node
  public let previousPath: Path?
  
  init(to node: Node, via connection: Connection? = nil, previousPath path: Path? = nil) {
    if
      let previousPath = path,
      let viaConnection = connection {
      self.cumulativeWeight = viaConnection.weight + previousPath.cumulativeWeight
    } else {
      self.cumulativeWeight = 0
    }
    
    self.node = node
    self.previousPath = path
  }
}

extension Path {
  var array: [Node] {
    var array: [Node] = [self.node]
    
    var iterativePath = self
    while let path = iterativePath.previousPath {
      array.append(path.node)
      
      iterativePath = path
    }
    
    return array
  }
}


public struct Stack<T> {
    fileprivate var array = [T]()
    
    public var isEmpty: Bool { array.isEmpty }
    
    public var count: Int { array.count }
    
    public mutating func push(_ element: T) {
        array.append(element)
    }
    
    public mutating func pop() -> T? {
        array.popLast()
    }
    
    public var top: T? {
        array.last
    }
}

extension Stack: Sequence {
    public func makeIterator() -> some IteratorProtocol {
        var curr = self
        return AnyIterator {
            return curr.pop()
        }
    }
}


extension Array {
    var combinationsWithoutRepetition: [[Element]] {
        guard !isEmpty else { return [] }
        return Array(self[1...]).combinationsWithoutRepetition.flatMap { [$0, [self[0]] + $0] }
    }
}

class Solution {
    func findMinMoves(_ machines: [Int]) -> Int {
        let total: Int = {
            return machines.reduce(0) { (sum, value) -> Int in
                return sum + value
            }
        }()
        
        guard total % machines.count == 0 else { return -1 }
        let average = total / machines.count
        
        var machines = machines
        var movingCounter = 0
        var sum = 0
        var maxAbsSum = 0
        var maxDiff = 0
        
        for i in 0 ..< machines.count - 1 {
            var diff = machines[i] - average
            maxDiff = max(maxDiff, diff)
            sum += diff
            maxAbsSum = max(maxAbsSum, abs(sum))
        }
        
        print("sum \(max(maxAbsSum, maxDiff))")
        
        return max(maxAbsSum, maxDiff)
    }
    
    func movieNumber(value: String) -> String {
        if let intValue = Int(value) {
            let numbering = String(Int(String(intValue - 1) + "666")!)
            return numbering
        } else {
            return ""
        }
    }
    

    func idChanger(_ new_id:String) -> String {
        var newId = refineId(new_id: new_id)
        
        // #7
        if newId.count < 3 {
            newId.append(String(newId.last!))
        }
        if newId.count < 3 {
            newId.append(String(newId.last!))
        }
        
        if newId.count < 3 {
            newId.append(String(newId.last!))
        }
        
        return newId
    }
    
    func refineId(new_id: String) -> String {
        
        // #1
        var newId = new_id.lowercased()
            
        
        // #2
        let pattern = #"[^a-z\d_\.\-]"#
    
        let IdRegex = try! NSRegularExpression(pattern: pattern, options: [])
        var nsRange = NSRange(newId.startIndex ..< newId.endIndex, in: newId)
        
        newId = IdRegex.stringByReplacingMatches(in: newId, options: [], range: nsRange, withTemplate: "")
        
        // #3
        let dotPattern = #"\.{2,}"#
        let dotRegex = try! NSRegularExpression(pattern: dotPattern, options: [])
        nsRange = NSRange(newId.startIndex ..< newId.endIndex, in: newId)
        
        newId = dotRegex.stringByReplacingMatches(in: newId, options: [], range: nsRange, withTemplate: ".")
        
        // #4
        let firstAndLastDotPattern = #"(^\.|\.$)"#
        let firstAndLastDotRegex = try! NSRegularExpression(pattern: firstAndLastDotPattern, options: [])
        nsRange = NSRange(newId.startIndex ..< newId.endIndex, in: newId)
        
        newId = firstAndLastDotRegex.stringByReplacingMatches(in: newId, options: [], range: nsRange, withTemplate: "")
        
        // #5
        if newId == "" {
            newId = "a"
        }
        
        
        // #6
        if newId.count >= 16 {
            let startIndex = newId.index(newId.startIndex, offsetBy: 0)
            let endIndex = newId.index(newId.startIndex, offsetBy: 15)
                
            newId = String(newId[startIndex..<endIndex])
            
            let lastDotPattern = #"\.$"#
            let lastDotRegex = try! NSRegularExpression(pattern: lastDotPattern, options: [])
            nsRange = NSRange(newId.startIndex ..< newId.endIndex, in: newId)
            
            newId = lastDotRegex.stringByReplacingMatches(in: newId, options: [], range: nsRange, withTemplate: "")
        }
        
        return newId
    }
    
    func findCourseMenus(_ orders:[String], _ course:[Int]) -> [String] {
        let sortedOrders = orders.sorted(by: { $0.count < $1.count })
        
        var possibleCourses: [String: Int] = [:]
        
        for index in 0 ..< sortedOrders.count {
            for index2 in index + 1 ..< sortedOrders.count {
                let isSubset: Bool = {
                    var _isSubset: Bool = false
                    let characters = sortedOrders[index]
                    
                    for charactor in characters {
                        _isSubset = sortedOrders[index2].contains(charactor)
                        
                        if !_isSubset { return false }
                    }
                    
                    return _isSubset
                }()
                
                if isSubset {
                    if possibleCourses[sortedOrders[index]] != nil {
                        possibleCourses[sortedOrders[index]]! += 1
                    } else {
                        possibleCourses[sortedOrders[index]] = 2
                    }
                }
                
                
            }
        }
        
        let result = Array(possibleCourses.filter { course.contains($0.key.count) }.keys).sorted(by: <)
        
        print(result)
        return result
    }
    
    func combinationsWithoutRepetition(array: [String]) -> [[String]] {
        guard !array.isEmpty else { return [[]] }
        
        return combinationsWithoutRepetition(array: Array(array[1...])).flatMap { [$0, [array[0]] + $0] }
    }
    
    func findParticipants(from info: [String], with queries: [String]) -> [Int] {
        let conditions = queries.map { getConditionFromQuery(query: $0)}
        
        var results: [Int] = [Int].init(repeating: 0, count: conditions.count)
        
//        for index in 0 ..< info.count {
//            let participant = info[index]
            
            for cIndex in 0 ..< conditions.count {
                let count = info.filter({ compare(info: $0, with: conditions[cIndex])}).count
                
//                let count = info.filter(where: { compare(info: $0, with: conditions[cIndex])})
                
                results[cIndex] = count
//                if compare(info: participant, with: conditions[cIndex]) {
//                    results[cIndex] += 1
//                }
            }
//        }
        
        print(results)
        
//        for condition in conditions {
//            var passedParticipantNumber: Int = 0
//
//            for participant in info {
//                if compare(info: participant, with: condition) {
//                    passedParticipantNumber += 1
//                }
//            }
//
//
//            results.append(passedParticipantNumber)
//        }
//
        return results
    }
    
    func getConditionFromQuery(query: String) -> (String, String, String, String, String) {
        let conditions = query.components(separatedBy: " and ")
        let lastCondition = conditions[3].components(separatedBy: " ")
        
        let condition = (conditions[0], conditions[1], conditions[2], lastCondition[0], lastCondition[1])
        
        return condition
    }
    
    func compare(info: String, with conditions: (String, String, String, String, String)) -> Bool {
        let infoConditions = info.components(separatedBy: " ")
        
        
        return (conditions.0 == "-" || (infoConditions[0] == conditions.0))
        && (conditions.1 == "-" || (infoConditions[1] == conditions.1))
        && (conditions.2 == "-" || (infoConditions[2] == conditions.2))
        && (conditions.3 == "-" || (infoConditions[3] == conditions.3))
        && (conditions.4 == "-" || (Int(infoConditions[4])! >= Int(conditions.4)!))
    }
    
    

    

    func shortestPath(source: Node, destination: Node) -> Path? {
      var frontier: [Path] = [] {
        didSet { frontier.sort { return $0.cumulativeWeight < $1.cumulativeWeight } } // the frontier has to be always ordered
      }
      
      frontier.append(Path(to: source)) // the frontier is made by a path that starts nowhere and ends in the source
      
      while !frontier.isEmpty {
        let cheapestPathInFrontier = frontier.removeFirst() // getting the cheapest path available
        guard !cheapestPathInFrontier.node.visited else { continue } // making sure we haven't visited the node already
        
        if cheapestPathInFrontier.node === destination {
          return cheapestPathInFrontier // found the cheapest path 😎
        }
        
        cheapestPathInFrontier.node.visited = true
        
        for connection in cheapestPathInFrontier.node.connections where !connection.to.visited { // adding new paths to our frontier
          frontier.append(Path(to: connection.to, via: connection, previousPath: cheapestPathInFrontier))
        }
      } // end while
      return nil // we didn't find a path 😣
    }

    // **** EXAMPLE BELOW ****
    class MyNode: Node {
      let name: String
      
      init(name: String) {
        self.name = name
        super.init()
      }
    }

    func findShortestPath() {
        let nodeA = MyNode(name: "A")
        let nodeB = MyNode(name: "B")
        let nodeC = MyNode(name: "C")
        let nodeD = MyNode(name: "D")
        let nodeE = MyNode(name: "E")

        nodeA.connections.append(Connection(to: nodeB, weight: 1))
        nodeB.connections.append(Connection(to: nodeC, weight: 3))
        nodeC.connections.append(Connection(to: nodeD, weight: 1))
        nodeB.connections.append(Connection(to: nodeE, weight: 1))
        nodeE.connections.append(Connection(to: nodeC, weight: 1))

        let sourceNode = nodeA;
        let destinationNode = nodeD;

        var path = shortestPath(source: sourceNode, destination: destinationNode);

        if let succession: [String] = path?.array.reversed().flatMap({ $0 as? MyNode}).map({$0.name}) {
         print("🏁 Quickest path: \(succession)")
        } else {
         print("💥 No path between \(sourceNode.name) & \(destinationNode.name)")
        }
    }
    
    func findShortestPath(_ n:Int, _ s:Int, _ a:Int, _ b:Int, _ fares:[[Int]]) -> Int {
        var nodes: [MyNode] = []
        
        for index in 0 ..< n {
            nodes.append(MyNode(name: "\(index + 1)"))
        }
        //
        
        for fare in fares {
            nodes[fare[0] - 1].connections.append(Connection(to: nodes[fare[1] - 1], weight: fare[2] ))
        }
        
        
        
        let aPath = shortestPath(source: nodes[s - 1], destination: nodes[a - 1])
        if let succession: [String] = aPath?.array.reversed().flatMap({ $0 as? MyNode}).map({$0.name}) {
            print("🏁 Quickest path: \(succession)")
        } else {
            print("💥 No path between \(nodes[s - 1].name) & \(nodes[a - 1].name)")
        }
        let bPath = shortestPath(source: nodes[s - 1], destination: nodes[b - 1])
        
        if let succession: [String] = bPath?.array.reversed().flatMap({ $0 as? MyNode}).map({$0.name}) {
            print("🏁 Quickest path: \(succession)")
        } else {
            print("💥 No path between \(nodes[s - 1].name) & \(nodes[a - 1].name)")
        }
        
        
        return 1
    }
    
//    func makeNodes(fares:[[Int]]) -> [String: MyNode] {
//        var nodes: [String: MyNode] = [:]
//
//        for fare in fares {
//            let stringName = String(fare[0])
//            if nodes[stringName] == nil {
//                nodes[stringName] = MyNode(name: stringName)
//            } else {
//
//            }
//        }
//
//
//        return nodes
//    }
    
    func findAdvertisementSections(_ play_time:String, _ adv_time:String, _ logs:[String]) -> String {
        var advStartTimes: [String] = []
        var weights: [Int] = Array<Int>.init(repeating: 0, count: logs.count)
        
        let playTimeFormatter = DateFormatter()
        playTimeFormatter.dateFormat = "HH:mm:ss"
        
        let logTimes = logs.compactMap { playTimeFormatter.date(from: $0)}
            .sorted(by: <)
        
        
        let playTime = playTimeFormatter.date(from: play_time)
        let advTime = playTimeFormatter.date(from: adv_time)
        
        for x in 0 ..< logs.count {
            for y in 0 ..< logs.count {
                if y == x { continue }
                
                if isHasInterSection(log1: logs[x], log2: logs[y]) {
                    weights[x] += 1
                }
                
            }
        }
        
        print("weights", weights)
        
        return  ""
    }
    
    func isHasInterSection(log1: String, log2: String) -> Bool {
        let playTimeFormatter = DateFormatter()
        playTimeFormatter.dateFormat = "HH:mm:ss"
        
        let log1StartTime = playTimeFormatter.date(from: log1.components(separatedBy: "-")[0])!
        let log1EndTime = playTimeFormatter.date(from: log1.components(separatedBy: "-")[1])!
        
        let log2StartTime = playTimeFormatter.date(from: log2.components(separatedBy: "-")[0])!
        let log2EndTime = playTimeFormatter.date(from: log2.components(separatedBy: "-")[1])!
        
        
        return (log1StartTime...log1EndTime).overlaps(log2StartTime...log2EndTime)
    }
    
    
    func findMaximumPrize(_ expression: String) -> Int64 {
        var (operators, operands): ([String], [String]) = {
            var startIndex: Int = 0
            var _operators: [String] = []
            var _operands: [String] = []
            
            expression.enumerated().forEach { (index, string) in
                if "+*-".contains(String(string)) {
                    let range = expression.index(expression.startIndex, offsetBy: startIndex)..<expression.index(expression.startIndex, offsetBy: index)
                    
                    _operands.append(String(expression[range]))
                    _operators.append(String(string))
                    startIndex = index + 1
                }
            }
            
            return (_operators, _operands)
        }()
        
        
        print(operators.combinationsWithoutRepetition)
        return .zero
    }
}


//Solution().idChanger("...!@BaT#*..y.abcdefghijklm")

//Solution().findCourseMenus(["ABCFG", "AC", "CDE", "ACDE", "BCFG", "ACDEH"], [2,3,4])

//Solution().findCourseMenus(["ABCDE", "AB", "CD", "ADE", "XYZ", "XYZ", "ACD"], [2,3,5])

//Solution().findParticipants(from:
//    ["java backend junior pizza 150",
//     "python frontend senior chicken 210",
//     "python frontend senior chicken 150",
//     "cpp backend senior pizza 260",
//     "java backend junior chicken 80",
//     "python backend senior chicken 50"], with: ["java and backend and junior and pizza 100","python and frontend and senior and chicken 200","cpp and - and senior and pizza 250","- and backend and senior and - 150","- and - and - and chicken 100","- and - and - and - 150"])

//Solution().findShortestPath(6, 4, 6, 2, [[4, 1, 10], [3, 5, 24], [5, 6, 2], [3, 1, 41], [5, 1, 24], [4, 6, 50], [2, 4, 66], [2, 3, 22], [1, 6, 25]])

//Solution().findAdvertisementSections("02:03:55", "00:14:15", ["01:20:15-01:45:14", "00:40:31-01:00:00", "00:25:50-00:48:29", "01:30:59-01:53:29", "01:37:44-02:02:30"])
Solution().findMaximumPrize("100-200*300-500+20")
