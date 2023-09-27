//
//  WordAnalysisManager.swift
//  Att
//
//  Created by 황정현 on 2023/09/22.
//

import Foundation
import NaturalLanguage

final class WordAnalysisManager {
    private var wordFrequencyDictionary: [String: Int] = [:]
    
    func tokenizeText(_ rawTextList: [String?]) {
        wordFrequencyDictionary = [:]
        let tokenizer = NLTokenizer(unit: .word)
        
        for rawText in rawTextList {
            tokenizer.string = rawText
            guard let rawText = rawText else { continue }
            tokenizer.enumerateTokens(in: rawText.startIndex..<rawText.endIndex) { tokenRange, _ in
                let token = String(rawText[tokenRange])
                    .removeSpecialCharacters()
                    .removeParticle()
                
                if let word = wordFrequencyDictionary[token] {
                    wordFrequencyDictionary.updateValue(word + 1, forKey: token)
                } else {
                    wordFrequencyDictionary[token] = 1
                }
                return true
            }
        }
    }
    
    func getMostUsedWordDicionry() -> [String: Int] {
        let dictionary = wordFrequencyDictionary.sorted(by: {$0.value > $1.value})
        let mostUsedWordArray = Array(dictionary.prefix(3))
        return Dictionary(uniqueKeysWithValues: mostUsedWordArray)
    }
}
