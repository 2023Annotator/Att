//
//  String+.swift
//  Att
//
//  Created by 황정현 on 2023/09/22.
//

import Foundation

extension String {
    func removeParticle() -> String {
        let koreanParticles = ["은", "는", "이", "가", "을", "를", "과", "와", "에게", "의", "에", "으로", "로", "에서", "이랑", "랑", "께서", "하고", "고"]
        
        for particle in koreanParticles where self.hasSuffix(particle) {
            let endIndex = self.index(self.endIndex, offsetBy: -particle.count)
            return String(self[..<endIndex])
        }
        return self
    }
    
    func removeSpecialCharacters() -> String {
            let pattern = "[^a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ\\s]"
            
            do {
                let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
                let range = NSRange(location: 0, length: self.utf16.count)
                return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
            } catch {
                print("정규표현식 오류: \(error.localizedDescription)")
                return self
            }
        }
}
