//アップキャスト、ダウンキャストの仕様確認

let aaa: Any = 1
let isInt = aaa is Int
print(isInt)

let any = "abc" as Any
print(type(of: any))

func separateBar() {
    print("----------")
}

separateBar()

//guard-let文外での変数の仕様

func someFunction() {
    let ad: Any = 1
    
    guard let int = ad as? Int else {
        print("aはInt型ではありません")
        return
    }
    
    print("値はInt型の\(int)です")
}

someFunction()

separateBar()

//for-if文の基本動作

var odds = [Int]()
let array = [1, 2, 3, 4, 5]

for element in array {
    if element % 2 == 1 {
        odds.append(element)
        continue
    }
    print("even: \(element)")
}

print("odds: \(odds)")

separateBar()

//autoclosure属性を用いた遅延評価

func or(_ lhs: Bool, _ rhs: @autoclosure () -> Bool)
    -> Bool {
    if lhs {
        print("true")
        return true
    } else {
        let rhs = rhs()
        print(rhs)
        return rhs
    }
}

func lhs() -> Bool {
    print("lhs()関数が実行されました")
    return true
}

func rhs() -> Bool {
    print("rhs()関数が実行されました")
    return false
}

or(lhs(), rhs())

separateBar()

//スタティックメソッドの実装

struct Greeting {
    static var signature = "Sent from iPhone"
    
    static func setSignature(withDeviceName deviceName: String) {
        signature = "Sent from \(deviceName)"
    }
    
    var to = "Naomichi Okada"
    var body: String {
        return "Hello, \(to)!\n\(Greeting.signature)"
    }
}

let greeting = Greeting()
print(greeting.body)
separateBar()

Greeting.setSignature(withDeviceName: "Xperia")
print(greeting.body)

separateBar()

//クラスの継承とオーバーライドの実装

class User {
    let id: Int
    var message: String {
        return "Hello."
    }
    
    init(id: Int) {
        self.id = id
    }
    
    func printProfile() {
        print("id: \(id)")
        print("message: \(message)")
    }
}

class RegisteredUser : User {
    let name: String
    
    override var message: String {
        return "Hello, my name is \(name)."
    }
    
    init(id: Int, name: String)  {
        self.name = name
        super.init(id: id)
    }
    
    override func printProfile() {
        super.printProfile()
        print("name: \(name)")
    }
}

let user = User(id: 1)
user.printProfile()

separateBar()

let registeredUser = RegisteredUser(id:2, name: "Naomichi Okada")
registeredUser.printProfile()

separateBar()

//参照型の値比較と参照先比較

class SomeClass : Equatable {
    static func ==(lhs: SomeClass, rhs: SomeClass) -> Bool {
        return true
    }
}

let aa = SomeClass()
let ab = SomeClass()
let ac = aa

aa == ab
aa === ab
aa === ac

//列挙型のローバリューに関するテスト

enum Symbol : Character {
    case sharp = "#"
    case dollar = "$"
    case percent = "%"
}

let symbol = Symbol(rawValue: "#")
let character = symbol?.rawValue
let symbol2 = Symbol(rawValue: "&")

//プロトコルの連想型における型制約

class SomeClass1 {}

protocol SomeProtocol {
    associatedtype AssociatedType : SomeClass1
}

class SomeSubClass : SomeClass1 {}

struct ConformedStruct : SomeProtocol {
    typealias AssociatedType = SomeSubClass
}

//デフォルト実装による実装の任意化

protocol Item {
    var name: String { get }
    var caution: String? { get }
}

extension Item {
    var caution: String? {
        return nil
    }
    
    var description: String {
        var description = "商品名: \(name)"
        if let caution = caution {
            description += "、注意事項: \(caution)"
        }
        return description
    }
}

struct Book : Item {
    let name: String
}

struct Fish : Item {
    let name: String
    
    var caution: String? {
        return "クール便での発送となります"
    }
}

let book = Book(name: "Swift実践入門")
print(book.description)

let fish = Fish(name: "秋刀魚")
print(fish.description)

separateBar()

//Conparableプロトコルの挙動テスト

struct Test : Comparable {
    let score: Int
    let answerer: String
    
    static func ==(lhs: Test, rhs: Test) -> Bool {
        return lhs.score == rhs.score && lhs.answerer == rhs.answerer
    }
    
    static func <(lhs: Test, rhs: Test) -> Bool {
        return lhs.score < rhs.score
    }
}

let a = Test(score: 90, answerer: "Tom")
let b = Test(score: 85, answerer: "Bob")

a < b
a <= b
a >= b
a > b

let array2 = [2, 1, 3]
let sortedArray = array2.sorted()

//Sequenceプロトコルの挙動テスト

struct IntIterator : IteratorProtocol {
    var count = 0
    
    mutating func next() -> Int? {
        guard count < 10 else {
            return nil
        }
        defer {
            count += 1
        }
        return count
    }
}

struct IntSequence : Sequence {
    func makeIterator() -> IntIterator {
        return IntIterator()
    }
}

let sequence = IntSequence()

var array3 = [Int]()
for element in sequence {
    //elementはInt型
    array3.append(element)
}
array3


let stringArray = sequence.map { element in
    return "\(element)"
}

let filteredArray = sequence.filter { element in
    return element % 2 == 0
}

//汎用的なプログラムとジェネリクス

func isEqual() -> Bool {
    return 1 == 1
}

func isEqual(_ x: Int, _ y: Int) -> Bool {
    return x == y
}

isEqual()
isEqual(1, 1)

//ジェネリクスを用いた記述
func isEqual<T: Equatable>(_ x: T, _ y: T) -> Bool {
    return x == y
}

isEqual("abc", "def")
isEqual(1.0, 3.14)
isEqual(false, false)

//型どうしの一致を要求する型制約

func concat<V: Collection, U: Collection>
    (_ argument1: V, _ argument2: U) -> [V.Iterator.Element]
    where V.Iterator.Element == U.Iterator.Element {
    
        return Array(argument1) + Array(argument2)
}

let array4 = [1, 2, 3]
let set = Set([1, 2, 3])
let result = concat(array4, set)
