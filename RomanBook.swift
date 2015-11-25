//: Playground - noun: a place where people can play

import UIKit

protocol RomanNumberConverter {
    func toRoman() -> String?
}

extension Int: RomanNumberConverter {
    static let romanValues = [ ("m", 1000), ("cm", 900), ("d", 500), ("cd", 400), ("c",100),
        ("xc", 90), ("l", 50), ("xl", 40), ("x", 10),
        ("ix", 9), ("v", 5), ("iv", 4), ("i",1) ]
    
    static func convertToRoman(var value: Int) -> String? {
        guard value > 0 else {
            return nil
        }
        
        var result = ""
        
        for (romanChar, arabicValue) in Int.romanValues {
            let count = value / arabicValue
            
            guard count > 0 else {
                continue
            }
            
            for _ in 1...count
            {
                result += romanChar
                value -= arabicValue
            }
        }
        
        return result
    }
    
    func toRoman() -> String? {
        guard self > 0 else {
            return nil
        }
        
        if self > 999 {
            let normalValue = self % 1000
            let overlineValue = (self - normalValue) / 1000
            
            switch (Int.convertToRoman(overlineValue), Int.convertToRoman(normalValue)) {
            case (let largeNumber, _) where normalValue == 0:
                return "\(largeNumber!)+"
            case (let largeNumber, let smallNumber):
                return "\(largeNumber!)+\(smallNumber!)"
            }
        } else {
            return Int.convertToRoman(self)
        }
        
        return nil
    }
}

struct RomanSource {
    var startingValue: Int = 1
    var maximumValue: Int
    var currentValue: Int = 1
    
    init(maximumValue: Int) {
        self.maximumValue = maximumValue
    }
    
    func isActive() -> Bool {
        return currentValue < maximumValue
    }
    
    func numWordsLeft() -> Int {
        return maximumValue - currentValue + 1
    }
    
    mutating func getWords(count: Int) -> [String]? {
        guard currentValue < maximumValue else {
            print("can't give more values")
            return nil
        }
        
        guard count > 0 else {
            print("asked for zero values")
            return nil
        }
        
        var results: [String] = []
        
        for value in currentValue..<currentValue + count {
            guard value <= maximumValue else {
                break
            }
            
            //results.append("Caeser")
            
            if let romanValue = value.toRoman() {
                results.append(romanValue)
                currentValue += 1
            }
        }
        
        //print("returning \(results.count) words")
        return results
    }
}

var source = RomanSource(maximumValue: 50_000)

/* struct RickSource {
    var maximumWords: Int
    var wordCount: Int
    
    let words = [ "never", "gonna", "give", "you", "up", "never", "gonna", "let", "you", "down", "never", "gonna", "turn", "around", "and", "desert", "you", "never", "gonna", "make", "you", "cry", "never", "gonna", "say", "goodbye", "never", "gonna", "tell", "a", "lie", "and", "hurt", "you" ]
    
    
    init(maxWords: Int) {
        maximumWords = maxWords
        wordCount = 0
    }
    
    func isActive() -> Bool {
        return wordCount < maximumWords
    }
    
    func numWordsLeft() -> Int {
        return maximumWords - wordCount + 1
    }
    
    mutating func getWords(count: Int) -> [String]? {
        guard wordCount < maximumWords else {
            print("can't give more values")
            return nil
        }
        
        guard count > 0 else {
            print("asked for zero values")
            return nil
        }
        
        var results: [String] = []
        
        for _ in 0...count {
            results.append(words[wordCount % words.count])
            wordCount += 1
        }
        
        return results
    }
}

var source = RickSource(maxWords: 200) */

extension Int {
    init(randomRange: Int) {
        self = Int(arc4random_uniform(UInt32(randomRange))) + 1
    }
}

enum SentenceEnd: String {
    case FullStop = "."
    case QuestionMark = "?"
    case ExclamationMark = "!"
    case Comma = ","
    
    init(fullStop: Int, questionMark: Int, exclamationMark: Int, comma: Int) {
        let result = Int(randomRange: 100)
        
        switch result { // yes there is a bug here, because it won't be zero
        case 0..<fullStop:
            self = .FullStop
        case fullStop..<questionMark+fullStop:
            self = .QuestionMark
        case questionMark+fullStop..<exclamationMark+questionMark+fullStop:
            self = .ExclamationMark
        case exclamationMark+questionMark+fullStop..<comma+exclamationMark+questionMark+fullStop:
            self = .Comma
        default:
            self = .FullStop
        }
    }
    
    init(percentages: Int...) {
        self = .FullStop
    }
}

enum SentenceType {
    case Phrase
    case Quote
    case PhraseQuote
    case QuotePhrase
    case QuotePhraseQuote
}

extension SentenceType {
    init(phraseWeight: Int, quoteWeight: Int, phraseQuoteWeight: Int, quotePhraseWeight: Int, quotePhraseQuoteWeight: Int) {
        let result = Int(randomRange: 100)
        
        let adjustedQuoteWeight = quoteWeight + phraseWeight
        let adjustedPhraseQuoteWeight = phraseQuoteWeight + adjustedQuoteWeight
        let adjustedQuotePhraseWeight = quotePhraseWeight + adjustedPhraseQuoteWeight
        let adjustedQuotePhraseQuoteWeight = quotePhraseQuoteWeight + adjustedQuotePhraseWeight
        
        switch result {
        case 1...phraseWeight:
            self = .Phrase
        case phraseWeight...adjustedQuoteWeight:
            self = .Quote
        case adjustedQuoteWeight...adjustedPhraseQuoteWeight:
            self = .PhraseQuote
        case adjustedPhraseQuoteWeight...adjustedQuotePhraseWeight:
            self = .QuotePhrase
        case adjustedQuotePhraseWeight...adjustedQuotePhraseQuoteWeight:
            self = .QuotePhraseQuote
        default:
            self = .Phrase
        }
    }
    
    init(percentages: Int...) {
        self = .Phrase
    }
}

enum WeightedChoice {
    case Yes, No
}

extension WeightedChoice {
    init(percentage: Int) {
        let result = Int(randomRange: 100)
        
        switch result {
        case 1...percentage:
            self = .Yes
        default:
            self = .No
        }
    }
}

extension String {
    var capitalizeFirst:String {
        var result = self
        result.replaceRange(startIndex...startIndex, with: String(self[startIndex]).capitalizedString)
        return result
    }
}

extension Array where Element:StringLiteralConvertible {
    func joinWithWeightedSpaces(weight: Int) -> String? {
        var combinedWords = ""
        
        guard self.count > 0 else {
            print("joinWithWeightedSpaces nil")
            return nil
        }
        
        combinedWords = self[0] as! String
        
        for word in self[1..<self.count] {
            let result = WeightedChoice(percentage: weight)
            
            if result == .Yes {
                combinedWords = combinedWords + ", " + (word as! String)
            } else {
                combinedWords = combinedWords + " " + (word as! String)
            }
        }
        
        return combinedWords
    }
}

struct Sentence: CustomStringConvertible {
    //var words: [String] = []
    var end: SentenceEnd = .FullStop
    var type: SentenceType = .Phrase
    
    var combinedWords: String = ""
    
    var description: String {
        get {
            return combinedWords// + end.rawValue
        }
    }
    
    mutating func formatPhrase(var words: [String]) {
        words[0] = words[0].capitalizeFirst
        
        guard let quoteText = words.joinWithWeightedSpaces(20) else {
            return
        }
        
        let quoteEnd = SentenceEnd(fullStop: 40, questionMark: 30, exclamationMark: 30, comma: 0)
        
        type = .Phrase
        combinedWords = quoteText + quoteEnd.rawValue
    }
    
    mutating func formatQuote(words: [String]) {
        formatPhrase(words)
        
        type = .Quote
        combinedWords = "\"" + combinedWords + "\""
    }
    
    mutating func formatPhraseQuote(var words: [String]) {
        guard words.count > 1 else {
            //print("not enough words for PQ")
            formatPhrase(words)
            return
        }
        
        words[0] = words[0].capitalizeFirst
        
        let split = Int(randomRange: words.count - 1)
        
        //print("PQ: split at \(split)")
        
        let phraseWords = Array(words[0..<split])
        var quoteWords = Array(words[split..<words.count])
        
        quoteWords[0] = quoteWords[0].capitalizeFirst
        
        let phraseText = phraseWords.joinWithWeightedSpaces(20)!
        let quoteText = quoteWords.joinWithWeightedSpaces(20)!
        let quoteEnd = SentenceEnd(fullStop: 40, questionMark: 30, exclamationMark: 30, comma: 0)
        
        type = .PhraseQuote
        combinedWords = "\(phraseText), \"\(quoteText)\(quoteEnd.rawValue)\""
    }
    
    mutating func formatQuotePhrase(var words: [String], phraseEnd: SentenceEnd = .FullStop) {
        let split = Int(randomRange: words.count - 1)
        
        guard words.count > 1 else {
            //print("not enough words for QP")
            formatQuote(words)
            return
        }
        
        words[0] = words[0].capitalizeFirst
        
        //print("QP: split at \(split)")
        
        let quoteWords = Array(words[0..<split])
        
        guard let quoteText = quoteWords.joinWithWeightedSpaces(20) else {
            return
        }
        let quoteEnd = SentenceEnd(fullStop: 10, questionMark: 30, exclamationMark: 30, comma: 30)
        
        var phraseWords = Array(words[split..<words.count])
        
        if quoteEnd != .Comma {
            phraseWords[0] = phraseWords[0].capitalizeFirst
        }
        
        guard let phraseText = phraseWords.joinWithWeightedSpaces(20) else {
            return
        }
        
        //let phraseEnd = SentenceEnd.FullStop //(fullStop: 40, questionMark: 30, exclamationMark: 30, comma: 0)
        
        type = .QuotePhrase
        combinedWords = "\"\(quoteText)\(quoteEnd.rawValue)\" \(phraseText)\(phraseEnd.rawValue)"
    }
    
    mutating func formatQuotePhraseQuote(var words: [String]) {
        guard words.count > 4 else {
            //print("not enough words for QPQ")
            formatQuote(words)
            return
        }
        
        words[0] = words[0].capitalizeFirst
        
        let split = Int(randomRange: words.count - 2)
        //print("QPQ: split at \(split)")
        
        let quotePhraseWords = Array(words[0..<split])
        let quoteWords = Array(words[split..<words.count])
        
        // NOTE: this sometimes will create same as Quote/PhraseQuote
        formatQuotePhrase(quotePhraseWords, phraseEnd: .Comma)
        
        let quoteText = quoteWords.joinWithWeightedSpaces(20)!
        let quoteEnd = SentenceEnd(fullStop: 10, questionMark: 30, exclamationMark: 30, comma: 30)
        
        guard type == .QuotePhrase else {
            formatQuote(words)
            return
        }
        
        type = .QuotePhraseQuote
        combinedWords = "\(combinedWords) \"\(quoteText)\(quoteEnd.rawValue)\""
        //combinedWords = "\"\(quoteText)\(quoteEnd.rawValue)\" \(combinedWords)"
    }
    
    init() {
        let sentenceType = SentenceType(phraseWeight: 45, quoteWeight: 10, phraseQuoteWeight: 15, quotePhraseWeight: 15, quotePhraseQuoteWeight: 15)
        
        prepareSentence(sentenceType)
    }
    
    init(sentenceType: SentenceType) {
        prepareSentence(sentenceType)
    }
    
    mutating func prepareSentence(sentenceType: SentenceType) {
        let numberOfWords = Int(randomRange: 30)
        
        guard let words = source.getWords(numberOfWords) else {
            print("Not able to get words")
            return
        }
        
        type = sentenceType
        end = SentenceEnd(fullStop: 80, questionMark: 10, exclamationMark: 10, comma: 0)
        
        switch sentenceType {
        case .Phrase:
            formatPhrase(words)
        case .Quote:
            formatQuote(words)
        case .PhraseQuote:
            formatPhraseQuote(words)
        case .QuotePhrase:
            formatQuotePhrase(words)
        case .QuotePhraseQuote:
            formatQuotePhraseQuote(words)
        }
    }
}

struct Paragraph: CustomStringConvertible {
    var sentences: [Sentence] = []
    
    var description: String {
        get {
            return sentences.reduce("", combine: {$0 + " " + $1.description})
        }
    }
    
    init() {
        let numberOfSentences = Int(randomRange: 7)
        
        var lastSentenceType: SentenceType?
        
        for _ in 0...numberOfSentences {
            let sentence: Sentence
            
            if let lastSentenceType = lastSentenceType where ((lastSentenceType == .PhraseQuote) || (lastSentenceType == .QuotePhraseQuote) || (lastSentenceType == .Quote)) {
                
                let forcedSentenceType = SentenceType(phraseWeight: 50, quoteWeight: 0, phraseQuoteWeight: 50, quotePhraseWeight: 0, quotePhraseQuoteWeight: 0)
                
                sentence = Sentence(sentenceType: forcedSentenceType)
                
            } else {
                sentence = Sentence()
            }
            
            sentences.append(sentence)
            lastSentenceType = sentence.type
        }
    }
}

//var paragraph = Paragraph()
//print(paragraph)

//var paragraph2 = Paragraph()
//print(paragraph2)

//var paragraph3 = Paragraph()
//print(paragraph3)

struct Chapter: CustomStringConvertible {
    var paragraphs: [Paragraph] = []
    
    var description: String {
        get {
            return paragraphs.reduce("  ", combine: {$0 + "\n\n" + $1.description})
        }
    }
    
    init() {
        let numberOfParagraphs = Int(randomRange: 40)
        
        for _ in 0...numberOfParagraphs {
            let paragraph = Paragraph()
            
            paragraphs.append(paragraph)
        }
    }
}

//var chapter = Chapter()
//var chapterText = chapter.description
//print(chapterText)

struct Book: CustomStringConvertible {
    var chapters: [Chapter] = []
    
    var description: String {
        get {
            return chapters.reduce("", combine: {$0 + "\n\n  *****  \n\n" + $1.description})
        }
    }
    
    init() {
        var chapterCount = 1
        
        while source.isActive() {
            print("creating Chapter \(chapterCount) (\(source.numWordsLeft()))")
            
            let chapter = Chapter()
            chapters.append(chapter)
            
            chapterCount += 1
        }
    }
}

var book = Book()
var bookText = book.description
print(bookText)
