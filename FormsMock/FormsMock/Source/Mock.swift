//
//  Mock.swift
//  FormsMock
//
//  Created by Konrad on 5/19/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

private let kDateFormatter: DateFormatter = DateFormatter()

// MARK: Mock
public class Mock {
    fileprivate static var lastNames: [String] = ["Smith", "Jones", "Brown", "Johnson", "Williams", "Miller", "Taylor", "Wilson", "Davis", "White", "Clark", "Hall", "Thomas", "Thompson", "Moore", "Hill", "Walker", "Anderson", "Wright", "Martin", "Wood", "Allen", "Robinson", "Lewis", "Scott", "Young", "Jackson", "Adams", "Tryniski", "Green", "Evans", "King", "Baker", "John", "Harris", "Roberts", "Campbell", "James", "Stewart", "Lee", "County", "Turner", "Parker", "Cook", "Mc", "Edwards", "Morris", "Mitchell", "Bell", "Ward", "Watson", "Morgan", "Davies", "Cooper", "Phillips", "Rogers", "Gray", "Hughes", "Harrison", "Carter", "Murphy", "Collins", "Henry", "Foster", "Richardson", "Russell", "Hamilton", "Shaw", "Bennett", "Howard", "Reed", "Fisher", "Marshall", "May", "Church", "Washington", "Kelly", "Price", "Murray", "William", "Palmer", "Stevens", "Cox", "Robertson", "Miss", "Clarke", "Bailey", "George", "Nelson", "Mason", "Butler", "Mills", "Hunt", "Island", "Simpson", "Graham", "Henderson", "Ross", "Stone", "Porter", "Wallace", "Kennedy", "Gibson", "West", "Brooks", "Ellis", "Barnes", "Johnston", "Sullivan", "Wells", "Hart", "Ford", "Reynolds", "Alexander", "Co", "Cole", "Fox", "Holmes", "Day", "Chapman", "Powell", "Webster", "Long", "Richards", "Grant", "Hunter", "Webb", "Thomson", "Wm", "Lincoln", "Gordon", "Wheeler", "Street", "Perry", "Black", "Lane", "Gardner", "City", "Lawrence", "Andrews", "Warren", "Spencer", "Rice", "Jenkins", "Knight", "Armstrong", "Burns", "Barker", "Dunn", "Reid", "College", "Mary", "Hayes", "Page", "Rose", "Patterson", "Ann", "Crawford", "Arnold", "House"]
    fileprivate static var names: [String] = ["James", "John", "Robert", "Michael", "William", "David", "Richard", "Joseph", "Thomas", "Charles", "Christopher", "Daniel", "Matthew", "Anthony", "Donald", "Mark", "Paul", "Steven", "Andrew", "Kenneth", "Joshua", "George", "Kevin", "Brian", "Edward", "Ronald", "Timothy", "Jason", "Jeffrey", "Ryan", "Jacob", "Gary", "Nicholas", "Eric", "Stephen", "Jonathan", "Larry", "Justin", "Scott", "Brandon", "Frank", "Benjamin", "Gregory", "Samuel", "Raymond", "Patrick", "Alexander", "Jack", "Dennis", "Jerry", "Tyler", "Aaron", "Jose", "Henry", "Douglas", "Adam", "Peter", "Nathan", "Zachary", "Walter", "Kyle", "Harold", "Carl", "Jeremy", "Keith", "Roger", "Gerald", "Ethan", "Arthur", "Terry", "Christian", "Sean", "Lawrence", "Austin", "Joe", "Noah", "Jesse", "Albert", "Bryan", "Billy", "Bruce", "Willie", "Jordan", "Dylan", "Alan", "Ralph", "Gabriel", "Roy", "Juan", "Wayne", "Eugene", "Logan", "Randy", "Louis", "Russell", "Vincent", "Philip", "Bobby", "Johnny", "Bradley", "Mary", "Patricia", "Jennifer", "Linda", "Elizabeth", "Barbara", "Susan", "Jessica", "Sarah", "Karen", "Nancy", "Margaret", "Lisa", "Betty", "Dorothy", "Sandra", "Ashley", "Kimberly", "Donna", "Emily", "Michelle", "Carol", "Amanda", "Melissa", "Deborah", "Stephanie", "Rebecca", "Laura", "Sharon", "Cynthia", "Kathleen", "Helen", "Amy", "Shirley", "Angela", "Anna", "Brenda", "Pamela", "Nicole", "Ruth", "Katherine", "Samantha", "Christine", "Emma", "Catherine", "Debra", "Virginia", "Rachel", "Carolyn", "Janet", "Maria", "Heather", "Diane", "Julie", "Joyce", "Victoria", "Kelly", "Christina", "Joan", "Evelyn", "Lauren", "Judith", "Olivia", "Frances", "Martha", "Cheryl", "Megan", "Andrea", "Hannah", "Jacqueline", "Ann", "Jean", "Alice", "Kathryn", "Gloria", "Teresa", "Doris", "Sara", "Janice", "Julia", "Marie", "Madison", "Grace", "Judy", "Theresa", "Beverly", "Denise", "Marilyn", "Amber", "Danielle", "Abigail", "Brittany", "Rose", "Diana", "Natalie", "Sophia", "Alexis", "Lori", "Kayla", "Jane"]
    fileprivate static var paragraphs: [String] = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin in purus nec diam feugiat euismod a id arcu. Etiam nibh orci, mollis at pretium vitae, laoreet id leo. Etiam a arcu congue, aliquam ipsum at, porttitor felis. Aliquam quis tellus eu urna efficitur tincidunt ac sed sapien. Phasellus et ligula tempor, blandit justo ut, condimentum neque. Praesent finibus hendrerit lorem, eu ultrices velit ornare a. Nulla rutrum nunc nec augue finibus, non accumsan arcu lacinia", "Suspendisse potenti. Donec euismod luctus lacus a tempor. Phasellus quis scelerisque augue. Vestibulum et turpis a ante ultrices molestie. Praesent tincidunt pellentesque felis, quis suscipit erat eleifend at. Vestibulum sapien turpis, elementum sit amet ipsum non, blandit molestie sem. Vivamus finibus leo vitae tempus dictum. Suspendisse potenti. Nulla nec dolor quis lacus lacinia tempus. Aliquam tincidunt arcu nec lectus efficitur ultricies. Aliquam erat volutpat"]
    fileprivate static var sentences: [String] = {
        return Mock.paragraphs
            .joined(separator: ". ")
            .components(separatedBy: ". ")
            .map { $0.appending(".") }
    }()
    fileprivate static var words: [String] = {
        return Mock.sentences
            .joined(separator: ". ")
            .components(separatedBy: " ")
            .filter { ![".", ","].contains($0) }
    }()
    
    private func random(percent: Double) -> Int {
        let value: Int = Int(percent * 100)
        return Int.random(in: 0...value)
    }
    
    private func random<T>(_ array: [T]) -> T {
        let index: Int = Int.random(in: 0..<array.count)
        return array[index]
    }
    
    private func random(_ range: ClosedRange<Int>) -> Int {
        return Int.random(in: range)
    }
    
    private func random(_ range: Range<Int>) -> Int {
        return Int.random(in: range)
    }
    
    private func random(_ range: ClosedRange<Double>) -> Double {
        return Double.random(in: range)
    }
    
    private func random(_ range: Range<Double>) -> Double {
        return Double.random(in: range)
    }
    
    private func isNull(_ options: [MockOptions]) -> Bool {
        guard let chance: Double = options.nullableChance else { return false }
        return self.random(0.0..<1.0) < chance
    }
}

// MARK: Mock - Array
public extension Mock {
    func array<T>(of factory: @autoclosure () -> T,
                  count: Int,
                  options: [MockOptions] = [.none]) -> [T]! {
        guard !self.isNull(options) else { return nil }
        return (0..<count).map { _ in factory() }
    }
}

// MARK: Mock - Bool
public extension Mock {
    func bool(chance: Double = 0.5,
              options: [MockOptions] = [.none]) -> Bool! {
        guard !self.isNull(options) else { return nil }
        return self.random(0.0..<1.0) < chance
    }
}

// MARK: Mock - Date
public extension Mock {
    func date(from fromDate: String,
              fromFormat fromDateFormat: String = "yyyy-MM-dd",
              to toDate: String,
              toFormat toDateFormat: String = "yyyy-MM-dd",
              options: [MockOptions] = [.none]) -> Date! {
        guard !self.isNull(options) else { return nil }
        kDateFormatter.dateFormat = fromDateFormat
        guard let fromDate: Date = kDateFormatter.date(from: fromDate) else { return nil }
        kDateFormatter.dateFormat = toDateFormat
        guard let toDate: Date = kDateFormatter.date(from: toDate) else { return nil }
        return self.date(
            from: fromDate,
            to: toDate,
            options: options)
    }
    
    func date(from fromDate: Date,
              to toDate: Date,
              options: [MockOptions] = [.none]) -> Date! {
        guard !self.isNull(options) else { return nil }
        let time: TimeInterval = self.random(fromDate.timeIntervalSince1970...toDate.timeIntervalSince1970)
        return Date(timeIntervalSince1970: time)
    }
}

// MARK: Mock - Email
public extension Mock {
    func email(_ options: [MockOptions] = [.none]) -> String! {
        return self.email(
            name: nil,
            lastName: nil,
            options: options)
    }
    
    func email(name: String?,
               lastName: String?,
               options: [MockOptions] = [.none]) -> String! {
        guard !self.isNull(options) else { return nil }
        let length: MockOptions.Length = options.length ?? .regular
        switch length {
        case .short,
        .regular:
            let name: String = name ?? self.name([.length(.regular)])
            let lastName: String = lastName ?? self.lastName([.length(.regular)])
            return "\(name[name.startIndex])\(lastName)@domain.com".lowercased()
        case .long:
            let name: String = name ?? self.name([.length(.long)])
            let lastName: String = lastName ?? self.lastName([.length(.long)])
            return "\(name).\(lastName)@domain.com".lowercased()
        }
    }
}

// MARK: Mock - Item
public extension Mock {
    func item<T>(from items: [T],
                 options: [MockOptions] = [.none]) -> T! {
        guard !self.isNull(options) else { return nil }
        return self.random(items)
    }
}

// MARK: Mock - LastName
public extension Mock {
    func lastName(_ options: [MockOptions] = [.none]) -> String! {
        guard !self.isNull(options) else { return nil }
        let length: MockOptions.Length = options.length ?? .regular
        switch length {
        case .short,
             .regular:
            return self.random(Self.lastNames)
        case .long:
            return [
                self.random(Self.lastNames),
                self.random(Self.lastNames)
            ].joined(separator: "-")
        }
    }
}

// MARK: Mock - Name
public extension Mock {
    func name(_ options: [MockOptions] = [.none]) -> String! {
        guard !self.isNull(options) else { return nil }
        return self.random(Self.names)
    }
}

// MARK: Mock - Number
public extension Mock {
    func number(_ range: ClosedRange<Int>,
                _ options: [MockOptions] = [.none]) -> Int! {
        guard !self.isNull(options) else { return nil }
        return self.random(range)
    }
    
    func number(_ range: Range<Int>,
                _ options: [MockOptions] = [.none]) -> Int! {
        guard !self.isNull(options) else { return nil }
        return self.random(range)
    }
    
    func number(_ range: ClosedRange<Double>,
                _ options: [MockOptions] = [.none]) -> Double! {
        guard !self.isNull(options) else { return nil }
        return self.random(range)
    }
    
    func number(_ range: Range<Double>,
                _ options: [MockOptions] = [.none]) -> Double! {
        guard !self.isNull(options) else { return nil }
        return self.random(range)
    }
}

// MARK: Mock - PostCode
public extension Mock {
    func phone(prefix: String? = nil,
               length: Int = 9,
               groupingSeparator: String? = " ",
               options: [MockOptions] = [.none]) -> String! {
        guard !self.isNull(options) else { return nil }
        var string: String = ""
        for i in 0..<length {
            string.insert(contentsOf: String(i), at: string.startIndex)
            if let groupingSeparator: String = groupingSeparator,
            i % 3 == 2 && (i < length - 1 || prefix != nil) {
                string.insert(contentsOf: groupingSeparator, at: string.startIndex)
            }
        }
        if let prefix: String = prefix {
            string.insert(contentsOf: prefix, at: string.startIndex)
        }
        return string
    }
}

// MARK: Mock - PostCode
public extension Mock {
    func postCode(format: String = "DD-DDD",
                  options: [MockOptions] = [.none]) -> String! {
        guard !self.isNull(options) else { return nil }
        var string: String = ""
        for formatChar in format {
            let char = formatChar == "X"
                ? String(self.random(0...9))
                : String(formatChar)
            string.append(char)
        }
        return string
    }
}

// MARK: Mock - String
public extension Mock {
    func string(_ options: [MockOptions] = [.none]) -> String! {
        guard !self.isNull(options) else { return nil }
        let length: MockOptions.Length = options.length ?? .regular
        switch length {
        case .short:
            return self.random(Self.words)
        case .regular:
            return self.random(Self.sentences)
        case .long:
            return self.random(Self.paragraphs)
        }
    }
}

// MARK: Mock - URL
public extension Mock {
    func imageUrl(_ options: [MockOptions] = [.none]) -> URL! {
        guard !self.isNull(options) else { return nil }
        let id: Int = self.random(0..<1_000)
        let width: Int = self.random(200..<1_000)
        let height: Int = self.random(200..<1_000)
        return URL(string: "https://i.picsum.photos/id/\(id)/\(width)/\(height).jpg")
    }
}

// MARK: Mock - UUID
public extension Mock {
    func uuid(_ options: [MockOptions] = [.none]) -> String! {
        guard !self.isNull(options) else { return nil }
        return UUID().uuidString
    }
}
