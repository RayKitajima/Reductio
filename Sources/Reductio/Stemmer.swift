/**
 This file is part of the Reductio package.
 (c) Sergio Fernández <fdz.sergio@gmail.com>

 For the full copyright and license information, please view the LICENSE
 file that was distributed with this source code.
 */

import Foundation
import NaturalLanguage

@available(macOS 10.14, *)
internal struct Stemmer {

    typealias Language = String
    typealias Script = String

    private static var language: Language = "en"
    private static let script: Script = "Latn"
    private static let orthography = NSOrthography(dominantScript: script, languageMap: [script: [language]])

    /**
    multi-language stemming
    
      - detect language by NLLanguageRecognizer
      - split text by NLTokenizer
      - select appropriate stopwords and filter words

    */
    static func stemmingWordsInText(_ text: String, context: ReductioContext) -> [String] {
        let language = NLLanguage(rawValue: context.lang)
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.setLanguage(language)
        tokenizer.string = text
        let tokens = tokenizer.tokens(for: text.startIndex..<text.endIndex)
        var stems: [String] = []
        for token in tokens {
            let tokenText = String(text[token])
            stems.append(tokenText.lowercased())
        }
        stems = stems.filter { !context.stopwords.contains($0) }
        return stems
    }
}
