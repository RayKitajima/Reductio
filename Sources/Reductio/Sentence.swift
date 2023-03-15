/**
 This file is part of the Reductio package.
 (c) Sergio Fernández <fdz.sergio@gmail.com>

 For the full copyright and license information, please view the LICENSE
 file that was distributed with this source code.
 */

import Foundation

@available(macOS 10.14, *)
internal struct Sentence {

    let text: String
    let words: [String]
    
    var context: ReductioContext

    init(text: String, context: ReductioContext) {
    	self.context = context
        self.text = text
		self.words = Stemmer.stemmingWordsInText(text, context: context)
    }
}

@available(macOS 10.14, *)
extension Sentence: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }

    public static func == (lhs: Sentence, rhs: Sentence) -> Bool {
        return lhs.text == rhs.text
    }
}

internal extension String {

    var sentences: [String] {
        var tokenRanges = [Range<String.Index>]()
        let linguisticTags = self.linguisticTags(
            in: self.startIndex ..< self.endIndex,
            scheme: NSLinguisticTagScheme.lexicalClass.rawValue,
            options: [],
            tokenRanges: &tokenRanges
        )
        var result = [String]()

        let sentenceTerminatorsIndexes = linguisticTags.enumerated().filter {
            $0.1 == "SentenceTerminator"
        }.map { tokenRanges[$0.0].lowerBound }

        var previousIndex = self.startIndex
        for currentIndex in sentenceTerminatorsIndexes {
            let sentenceRange = previousIndex ... currentIndex
            result.append(
                self[sentenceRange].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            )
            previousIndex = currentIndex
        }
        return result
    }
}
