/**
 This file is part of the Reductio package.
 (c) Sergio Fernández <fdz.sergio@gmail.com>

 For the full copyright and license information, please view the LICENSE
 file that was distributed with this source code.
 */

import Foundation

public struct Reductio {
    public init() {}

    /**

     Extract all keywords from text sorted by relevance

     - parameter text: Text to extract keywords.
     - parameter maxIteration: max iteration count to try to find convergence
     
     - returns: sorted keywords from text

     */
    public static func keywords(from text: String, maxIteration: Int, completion: ([String]) -> Void) {
        completion(Reductio.executeKeywords(text: text, maxIteration: maxIteration))
    }

    /**

     Extract first keywords from text sorted by relevance

     - parameter text: Text to extract keywords.
     - parameter count: Number of keywords to extract.
     - parameter maxIteration: max iteration count to try to find convergence

     - returns: sorted keywords from text

     */
    public static func keywords(from text: String, count: Int, maxIteration: Int, completion: ([String]) -> Void) {
        completion(Reductio.executeKeywords(text: text, maxIteration: maxIteration).slice(length: count))
    }

    /**

     Extract keywords from text sorted by relevance with a rate of compression

     - parameter text: Text to extract keywords.
     - parameter maxIteration: max iteration count to try to find convergence
     - parameter compression: Ratio of compression to extract keywords. From 0..<1.

     - returns: sorted keywords from text

     */
    public static func keywords(from text: String, maxIteration: Int, compression: Float, completion: ([String]) -> Void) {
        completion(Reductio.executeKeywords(text: text, maxIteration: maxIteration).slice(percent: compression))
    }

    /**

     Reordered text phrases by relevance on text

     - parameter text: Text to summarize.
     - parameter maxIteration: max iteration count to try to find convergence

     - returns: sorted phrases from text

     */
    public static func summarize(text: String, maxIteration: Int, completion: ([String]) -> Void) {
        completion(Reductio.executeSummarizer(text: text, maxIteration: maxIteration))
    }

    /**

     Reordered text phrases by relevance on text

     - parameter text: Text to summarize.
     - parameter maxIteration: max iteration count to try to find convergence
     - parameter count: Number of phrases to extract.

     - returns: sorted phrases from text

     */
    public static func summarize(text: String, maxIteration: Int, count: Int, completion: ([String]) -> Void) {
        completion(Reductio.executeSummarizer(text: text, maxIteration: maxIteration).slice(length: count))
    }

    /**

     Reordered text phrases by relevance on text

     - parameter text: Text to summarize.
     - parameter maxIteration: max iteration count to try to find convergence
     - parameter compression: Ratio of compression to extract phrases. From 0..<1.

     - returns: sorted phrases from text

     */
    public static func summarize(text: String, maxIteration: Int, compression: Float, completion: ([String]) -> Void) {
        completion(Reductio.executeSummarizer(text: text, maxIteration: maxIteration).slice(percent: compression))
    }
    
    /**

     Extract all keywords from text sorted by relevance

     - parameter text: Text to extract keywords.
     - parameter maxIteration: max iteration count to try to find convergence
     
     - returns: sorted keywords from text

     */
	public static func executeKeywords(text: String, maxIteration: Int) -> [String] {
    	return Keyword(text: text, maxIteration: maxIteration).execute()
	}
	
    /**

     Reordered text phrases by relevance on text

     - parameter text: Text to summarize.
     - parameter maxIteration: max iteration count to try to find convergence
     
     - returns: sorted phrases from text

     */
	public static func executeSummarizer(text: String, maxIteration: Int) -> [String] {
		return Summarizer(text: text, maxIteration: maxIteration).execute()
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

