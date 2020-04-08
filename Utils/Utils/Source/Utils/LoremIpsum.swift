//
//  LoremIpsum.swift
//  Utils
//
//  Created by Konrad on 3/30/20.
//  Copyright © 2020 Limbo. All rights reserved.
//

import Foundation

extension Array {
    func last(number: Int) -> Array {
        var a = self
        let result = (0..<number).compactMap { _ in return a.popLast() }
        return result.reversed()
    }
    
    func first(number: Int) -> Array {
        return self
            .enumerated()
            .filter { idx, _ in return idx < number }
            .compactMap { return $0.element }
    }
}

public enum LoremIpsum {
    private static var randomGenerator = SystemRandomNumberGenerator()
    
    public static func firstSentence() -> String {
        return LoremIpsum.sentencify(arrayOfWords: self.words.first(number: self.numberOfWordsInVeryFirstSentence))
    }
    
    public static func word() -> String {
        return self.words.randomElement(using: &self.randomGenerator) ?? ""
    }
    
    public static func sentence() -> String {
        let length = Int(LoremIpsum.randomNormalLikeDistributedNumber(mean: 8, std_dev: 4))
        var words: [String] = []
        stride(from: 1, to: length, by: 1).forEach { _ in
            var w = word()
            while words.last(number: 2).contains(w) {
                w = word()
            }
            words.append(w)
        }
        return LoremIpsum.sentencify(arrayOfWords: LoremIpsum.commify(arrayOfWords: words))
    }
    
    public static func paragraph(sentences: Int? = nil) -> String {
        var length: Int = sentences.or(Int(randomNormalLikeDistributedNumber(mean: 30, std_dev: 19)))
        if length <= 1 { length = 2 }
        return stride(from: 1, to: length, by: 1).map { _ in return LoremIpsum.sentence() }.joined(separator: " ")
    }
    
    private static func generateParagraphsAsString(numberOfParagraphs: Int,
                                                   includingVeryFirstSentence: Bool) -> String {
        return generateParagraphs(numberOfParagraphs: numberOfParagraphs, includingVeryFirstSentence: includingVeryFirstSentence)
            .joined(separator: "\n\n")
    }
    
    private static func generateParagraphs(numberOfParagraphs: Int,
                                           includingVeryFirstSentence: Bool) -> [String] {
        guard numberOfParagraphs > 0 else { return [] }
        return stride(from: 1, through: numberOfParagraphs, by: 1).map { idx in
            var par = LoremIpsum.paragraph()
            if idx == 1 && includingVeryFirstSentence {
                par = LoremIpsum.firstSentence() + " " + par
            }
            return par
        }
    }
    
    private static func sentencify(arrayOfWords: [String]) -> String {
        guard let firstWord = arrayOfWords.first else { return "" }
        var array = arrayOfWords
        array[0] = firstWord.prefix(1).uppercased() + firstWord.dropFirst()
        
        return array.joined(separator: " ") + "."
    }
    
    private static func commify(arrayOfWords: [String]) -> [String] {
        let sentenceLength = arrayOfWords.count
        var array = arrayOfWords
        if sentenceLength > 4 {
            let mean = log(Double(sentenceLength))
            let std_dev = mean / 6
            let commas = Int(randomNormalLikeDistributedNumber(mean: mean, std_dev: std_dev))
            stride(from: 1, to: commas, by: 1).forEach { idx in
                let wrd = Int(idx * sentenceLength / (commas + 1))
                if wrd < sentenceLength - 1 && wrd > 0 {
                    array[wrd] = array[wrd] + ","
                }
            }
        }
        
        return array
    }
    
    private static func randomNormalLikeDistributedNumber(mean: Double, std_dev: Double) -> Double {
        let x = Double.random(in: ClosedRange(uncheckedBounds: (0, 1)), using: &LoremIpsum.randomGenerator)
        let y = Double.random(in: ClosedRange(uncheckedBounds: (0, 1)), using: &LoremIpsum.randomGenerator)
        let z = sqrt(-2 * log(x)) * cos(2 * Double.pi * y)
        return z * std_dev + mean
    }
    
    private static let numberOfWordsInVeryFirstSentence: Int = 8
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
