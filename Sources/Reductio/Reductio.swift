/**
 This file is part of the Reductio package.
 (c) Sergio Fernández <fdz.sergio@gmail.com>

 For the full copyright and license information, please view the LICENSE
 file that was distributed with this source code.
 */

import Foundation
import NaturalLanguage

@available(macOS 10.14, *)
public class ReductioContext {
    var text: String
    var maxIteration: Int
    var lang: String
    var stopwordsDic: StopWords
    var stopwords: [String] {
    	return self.stopwordsDic[self.lang]
	}
	init(text: String, maxIteration: Int) {
        self.text = text
        self.maxIteration = maxIteration
        self.lang = NLLanguageRecognizer.dominantLanguage(for: text)?.rawValue ?? "en"
        self.stopwordsDic = StopWords()
    }
}

@available(macOS 10.14, *)
public struct Reductio {
    public init() {}

    /**

     Extract all keywords from text sorted by relevance

     - parameter text: Text to extract keywords.
     - parameter maxIteration: max iteration count to try to find convergence
     
     - returns: sorted keywords from text

     */
    public static func keywords(from text: String, maxIteration: Int, completion: ([String]) -> Void) {
        let context = ReductioContext(text: text, maxIteration: maxIteration)
        completion(Reductio.executeKeywords(context: context))
    }

    /**

     Extract first keywords from text sorted by relevance

     - parameter text: Text to extract keywords.
     - parameter count: Number of keywords to extract.
     - parameter maxIteration: max iteration count to try to find convergence

     - returns: sorted keywords from text

     */
    public static func keywords(from text: String, count: Int, maxIteration: Int, completion: ([String]) -> Void) {
    	let context = ReductioContext(text: text, maxIteration: maxIteration)
        completion(Reductio.executeKeywords(context: context).slice(length: count))
    }

    /**

     Extract keywords from text sorted by relevance with a rate of compression

     - parameter text: Text to extract keywords.
     - parameter maxIteration: max iteration count to try to find convergence
     - parameter compression: Ratio of compression to extract keywords. From 0..<1.

     - returns: sorted keywords from text

     */
    public static func keywords(from text: String, maxIteration: Int, compression: Float, completion: ([String]) -> Void) {
    	let context = ReductioContext(text: text, maxIteration: maxIteration)
        completion(Reductio.executeKeywords(context: context).slice(percent: compression))
    }

    /**

     Reordered text phrases by relevance on text

     - parameter text: Text to summarize.
     - parameter maxIteration: max iteration count to try to find convergence

     - returns: sorted phrases from text

     */
    public static func summarize(text: String, maxIteration: Int, completion: ([String]) -> Void) {
    	let context = ReductioContext(text: text, maxIteration: maxIteration)
        completion(Reductio.executeSummarizer(context: context))
    }

    /**

     Reordered text phrases by relevance on text

     - parameter text: Text to summarize.
     - parameter maxIteration: max iteration count to try to find convergence
     - parameter count: Number of phrases to extract.

     - returns: sorted phrases from text

     */
    public static func summarize(text: String, maxIteration: Int, count: Int, completion: ([String]) -> Void) {
    	let context = ReductioContext(text: text, maxIteration: maxIteration)
        completion(Reductio.executeSummarizer(context: context).slice(length: count))
    }

    /**

     Reordered text phrases by relevance on text

     - parameter text: Text to summarize.
     - parameter maxIteration: max iteration count to try to find convergence
     - parameter compression: Ratio of compression to extract phrases. From 0..<1.

     - returns: sorted phrases from text

     */
    public static func summarize(text: String, maxIteration: Int, compression: Float, completion: ([String]) -> Void) {
    	let context = ReductioContext(text: text, maxIteration: maxIteration)
        completion(Reductio.executeSummarizer(context: context).slice(percent: compression))
    }
    
    /**

     Extract all keywords from text sorted by relevance

     - parameter text: Text to extract keywords.
     - parameter maxIteration: max iteration count to try to find convergence
     
     - returns: sorted keywords from text

     */
	public static func executeKeywords(context: ReductioContext) -> [String] {
    	return Keyword(context: context).execute()
	}
	
    /**

     Reordered text phrases by relevance on text

     - parameter text: Text to summarize.
     - parameter maxIteration: max iteration count to try to find convergence
     
     - returns: sorted phrases from text

     */
	public static func executeSummarizer(context: ReductioContext) -> [String] {
		return Summarizer(context: context).execute()
	}
}

/*
public extension String {
    var keywords: [String] {
        return Keyword(text: self).execute()
    }

    var summarize: [String] {
        return Summarizer(text: self).execute()
    }
}
*/

