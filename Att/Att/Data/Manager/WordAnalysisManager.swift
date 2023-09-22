//
//  WordAnalysisManager.swift
//  Att
//
//  Created by 황정현 on 2023/09/22.
//

import Foundation
import NaturalLanguage

final class WordAnalysisManager {
    private var rawTextList: [String] = []
    private var wordFrequencyDictionary: [String: Int] = [:]
    
    init(textList: [String]) {
        rawTextList = textList
        tokenizeInitialText()
    }
    
    private func tokenizeInitialText() {
        let tokenizer = NLTokenizer(unit: .word)
        
        for rawText in rawTextList {
            tokenizer.string = rawText

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
    
    private func sortWordFrequencyDictionary() -> [Dictionary<String, Int>.Element] {
        return wordFrequencyDictionary.sorted { $0.value > $1.value }
    }
}
