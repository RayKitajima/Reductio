#!/usr/bin/env swift

/* 
swift script for making stopwords for each language from stop_words_iso.json

usage: 
$ ./stopwords.swift

input stop_words_iso.json file spec:

{
    "en": [list of stop words],
    "ja": [list of stop words],
    ...
}

output StopWords.swift spec:

struct StopWords {
    lazy var en: [String] = [ ... ]
    lazy var ja: [String] = [ ... ]
    ...
    getStopWords(language: String) -> [String] {
        switch language {
        case "en": return en
        case "ja": return ja
        ...
        default: return []
        }
    }
}
*/

import Foundation

let inputFileName = "stop_words_iso.json"
let outputFileName = "stop_words_iso.swift"

let inputFilePath = URL(fileURLWithPath: inputFileName)
let outputFilePath = URL(fileURLWithPath: outputFileName)

let data = try Data(contentsOf: inputFilePath)
let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: [String]]

let contents = """

import Foundation

class StopWords {
    static let shared = StopWords()

    subscript(key: String) -> [String] {
        switch key {
\(json.map { "        case \"\($0.key)\": return \($0.key)" }.joined(separator: "\n"))
        default: return []
        }
    }

\(json.map { "    var \($0.key): [String] {\($0.value)}" }.joined(separator: "\n"))
}

"""

// write out output
do {
    try contents.write(to: outputFilePath, atomically: true, encoding: .utf8)
} catch {
    print("Error writing to \(outputFilePath): \(error)")
}

