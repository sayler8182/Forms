//
//  LoremIpsum.swift
//  FormsUtils
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

// MARK: LoremIpsum
public enum LoremIpsum {
    private static var randomGenerator = SystemRandomNumberGenerator()
    
    public static var firstSentence: String {
        let words: [String] = self.words.first(count: 8)
        return LoremIpsum.sentencify(words: words)
    }
    
    public static var word: String {
        return self.words.randomElement(using: &self.randomGenerator) ?? ""
    }
    
    public static var sentence: String {
        let length: Int = LoremIpsum.randomNumber(5, 16)
        var words: [String] = []
        for _ in 0..<length {
            var word = self.word
            while words.last(count: 2).contains(word) { word = self.word }
            words.append(word)
        }
        let wordsWithCommas: [String] = LoremIpsum.commify(words: words)
        return LoremIpsum.sentencify(words: wordsWithCommas)
    }
    
    public static func paragraph(sentences: Int = 1) -> String {
        let length: Int = sentences
        var sentences: [String] = []
        for _ in 0..<length {
            sentences.append(self.sentence)
        }
        return sentences.joined(separator: " ")
    }
     
    private static func sentencify(words: [String]) -> String {
        guard let firstWord: String = words.first else { return "" }
        var words: [String] = words
        words[0] = firstWord.prefix(1).uppercased() + firstWord.dropFirst()
        return words.joined(separator: " ") + "."
    }
    
    private static func commify(words: [String]) -> [String] {
        let length = words.count
        guard length > 4 else { return words }
        var words: [String] = words
        let commasCount: Int = LoremIpsum.randomNumber(3, length)
        for i in 0..<commasCount {
            let wordIndex: Int = Int(i * length / (commasCount + 1))
            if wordIndex < length - 1 && wordIndex > 0 {
                words[wordIndex] = words[wordIndex] + ","
            }
        }
        
        return words
    }
    
    private static func randomNumber(_ from: Int, _ to: Int) -> Int {
        return Int.random(in: from...to)
    }
    
    private static let words: [String] = [
        "lorem", "ipsum", "dolor", "sit", "amet", "consectetur", "adipiscing", "elit",
        "a", "ac", "accumsan", "ad", "aenean", "aliquam", "aliquet", "ante",
        "aptent", "arcu", "at", "auctor", "augue", "bibendum", "blandit",
        "class", "commodo", "condimentum", "congue", "consequat", "conubia",
        "convallis", "cras", "cubilia", "curabitur", "curae", "cursus",
        "dapibus", "diam", "dictum", "dictumst", "dignissim", "dis", "donec",
        "dui", "duis", "efficitur", "egestas", "eget", "eleifend", "elementum",
        "enim", "erat", "eros", "est", "et", "etiam", "eu", "euismod", "ex",
        "facilisi", "facilisis", "fames", "faucibus", "felis", "fermentum",
        "feugiat", "finibus", "fringilla", "fusce", "gravida", "habitant",
        "habitasse", "hac", "hendrerit", "himenaeos", "iaculis", "id",
        "imperdiet", "in", "inceptos", "integer", "interdum", "justo",
        "lacinia", "lacus", "laoreet", "lectus", "leo", "libero", "ligula",
        "litora", "lobortis", "luctus", "maecenas", "magna", "magnis",
        "malesuada", "massa", "mattis", "mauris", "maximus", "metus", "mi",
        "molestie", "mollis", "montes", "morbi", "mus", "nam", "nascetur",
        "natoque", "nec", "neque", "netus", "nibh", "nisi", "nisl", "non",
        "nostra", "nulla", "nullam", "nunc", "odio", "orci", "ornare",
        "parturient", "pellentesque", "penatibus", "per", "pharetra",
        "phasellus", "placerat", "platea", "porta", "porttitor", "posuere",
        "potenti", "praesent", "pretium", "primis", "proin", "pulvinar",
        "purus", "quam", "quis", "quisque", "rhoncus", "ridiculus", "risus",
        "rutrum", "sagittis", "sapien", "scelerisque", "sed", "sem", "semper",
        "senectus", "sociosqu", "sodales", "sollicitudin", "suscipit",
        "suspendisse", "taciti", "tellus", "tempor", "tempus", "tincidunt",
        "torquent", "tortor", "tristique", "turpis", "ullamcorper", "ultrices",
        "ultricies", "urna", "ut", "varius", "vehicula", "vel", "velit",
        "venenatis", "vestibulum", "vitae", "vivamus", "viverra", "volutpat",
        "vulputate"
    ]
}

// MARK: Empty
public extension LoremIpsum {
    private static let scale: Int = 16
    static var emptyVeryShort: String {
        return LoremIpsum.empty(chars: LoremIpsum.scale)
    }
    static var emptyShort: String {
        return LoremIpsum.empty(chars: LoremIpsum.scale * 2)
    }
    static var emptyMedium: String {
        return LoremIpsum.empty(chars: LoremIpsum.scale * 4)
    }
    static var emptyLong: String {
        return LoremIpsum.empty(chars: LoremIpsum.scale * 8)
    }
    static var emptyVeryLong: String {
        return LoremIpsum.empty(chars: LoremIpsum.scale * 16)
    }
    
    static func empty(chars: Int) -> String {
        return String(repeating: " ", count: chars)
    }
    
    static func empty(lines: Int) -> String {
        return String(repeating: "\n", count: lines)
    }
}
