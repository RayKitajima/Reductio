/**
 This file is part of the Reductio package.
 (c) Sergio Fernández <fdz.sergio@gmail.com>

 For the full copyright and license information, please view the LICENSE
 file that was distributed with this source code.
 */

import Foundation

@available(iOS 12.0, *)
@available(macOS 10.14, *)
internal final class Keyword {

    private let ngram: Int = 3
    private var words: [String]
    private let maxIteration: Int

    private let ranking = TextRank<String>()
    
    private var context: ReductioContext

    init(context: ReductioContext) {
    	self.context = context
		let text = self.context.text
        self.maxIteration = self.context.maxIteration
        self.words = Keyword.preprocess(text)
    }

    func execute() -> [String] {
        filterWords()
        buildGraph()
        return ranking.execute(maxIteration: maxIteration)
            .sorted { $0.1 > $1.1 }
            .map { $0.0 }
    }

    func filterWords() {
        self.words = self.words
            .filter(removeShortWords)
            .filter(removeStopWords)
    }

    func buildGraph() {
        for (index, node) in words.enumerated() {
            var (min, max) = (index-ngram, index+ngram)
            if min < 0 { min = words.startIndex }
            if max > words.count { max = words.endIndex }
            words[min..<max].forEach { word in
                ranking.add(edge: node, to: word)
            }
        }
    }
}

@available(iOS 12.0, *)
@available(macOS 10.14, *)
private extension Keyword {

    static func preprocess(_ text: String) -> [String] {
        return text.lowercased()
            .components(separatedBy: CharacterSet.letters.inverted)
    }

    func removeShortWords(_ word: String) -> Bool {
        return word.count > 2
    }

    func removeStopWords(_ word: String) -> Bool {
        return !self.context.stopwords.contains(word)
    }
}
