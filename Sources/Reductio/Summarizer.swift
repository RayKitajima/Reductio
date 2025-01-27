/**
 This file is part of the Reductio package.
 (c) Sergio Fernández <fdz.sergio@gmail.com>

 For the full copyright and license information, please view the LICENSE
 file that was distributed with this source code.
 */

import Foundation

@available(iOS 12.0, *)
@available(macOS 10.14, *)
internal final class Summarizer {

    private let phrases: [Sentence]
    private let rank = TextRank<Sentence>()
    private let maxIteration: Int

    init(context: ReductioContext) {
		let text = context.text
    	self.maxIteration = context.maxIteration
        self.phrases = text.sentences.map( { Sentence(text: $0, context: context) } )
    }

    func execute() -> [String] {
        buildGraph()
        return rank.execute(maxIteration: maxIteration)
            .sorted { $0.1 > $1.1 }
            .map { $0.0.text }
    }

    private func buildGraph() {
        let combinations = self.phrases.combinations(length: 2)

        combinations.forEach { combo in
            add(edge: combo.first!, node: combo.last!)
        }
    }

    private func add(edge pivotal: Sentence, node: Sentence) {
        let pivotalWordCount: Float = pivotal.words.count
        let nodeWordCount: Float = node.words.count

        // calculate weight by co-occurrence of words between sentences
        var score: Float = pivotal.words.filter { node.words.contains($0) }.count
        score = score / (log(pivotalWordCount) + log(nodeWordCount))

        rank.add(edge: pivotal, to: node, weight: score)
        rank.add(edge: node, to: pivotal, weight: score)
    }
}
