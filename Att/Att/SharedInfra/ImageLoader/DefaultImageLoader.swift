//
//  DefaultImageLoader.swift
//  Att
//
//  Created by 황정현 on 8/11/25.
//

import UIKit
import ImageIO
import MobileCoreServices

public final class DefaultImageLoader: ImageLoader, @unchecked Sendable {
    private let mem = NSCache<NSURL, UIImage>()
    private let session: URLSession

    public init(configure: ((URLSessionConfiguration) -> Void)? = nil) {
        let config = URLSessionConfiguration.ephemeral
        // 디스크 캐시를 쓰지 않되, CDN/HTTP 캐시 헤더는 존중
        config.requestCachePolicy = .useProtocolCachePolicy
        config.waitsForConnectivity = true

        configure?(config)
        self.session = URLSession(configuration: config)

        mem.countLimit = 300
        mem.totalCostLimit = 64 * 1024 * 1024 // 64MB
    }

    public func cachedImage(for url: URL) -> UIImage? {
        mem.object(forKey: url as NSURL)
    }

    /// - Parameters:
    ///   - url: 원본 또는 템플릿 URL
    ///   - targetPointSize: 이 이미지를 보여줄 뷰의 pt 크기(예: 80x80pt). nil이면 원본 그대로 요청/디코딩
    ///   - screenScale: 기본은 UIScreen.main.scale
    public func loadImage(from url: URL,
                          targetPointSize: CGSize?,
                          screenScale: CGFloat) async throws -> UIImage {

        // 1) 요청 URL 정규화(템플릿/숫자 경로 모두 대응)
        let requestURL = sizedArtworkURL(url,
                                         targetPointSize: targetPointSize,
                                         scale: screenScale) ?? url

        // 2) 캐시 히트(⚠️ 사이즈별 URL이 다르므로 requestURL을 키로 사용)
        if let hit = mem.object(forKey: requestURL as NSURL) { return hit }

        // 3) 다운로드
        let (data, resp) = try await session.data(from: requestURL)
        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        // 4) 표시 크기 기반 다운샘플 디코딩(선명도/메모리 최적화)
        if let pts = targetPointSize, pts.width > 0, pts.height > 0 {
            let maxPx = max(ceil(pts.width * screenScale), ceil(pts.height * screenScale))
            if let down = Self.downsampledImage(from: data, maxPixelSize: maxPx) {
                mem.setObject(down, forKey: requestURL as NSURL, cost: data.count)
                return down
            }
        }

        // 5) 일반 디코딩
        guard let img = UIImage(data: data) else { throw URLError(.cannotDecodeContentData) }
        mem.setObject(img, forKey: requestURL as NSURL, cost: data.count)
        return img
    }

    // MARK: - URL 정규화(Apple Artwork 전용 + 일반 템플릿 모두 지원)

    /// 표시 크기(pt)와 화면 배율로 픽셀 계산 후:
    /// - 템플릿({w},{h})이면 문자열 치환
    /// - 숫자 경로(/NNNxMMMbb.(jpg|png))이면 정규식 교체
    /// 로 최종 요청 URL을 생성합니다. 실패 시 nil.
    private func sizedArtworkURL(_ url: URL,
                                 targetPointSize: CGSize?,
                                 scale: CGFloat) -> URL? {
        guard let pts = targetPointSize, pts.width > 0, pts.height > 0 else { return nil }
        let width = Int(ceil(pts.width * scale))
        let height = Int(ceil(pts.height * scale))
        var replacedUrl = url.absoluteString

        // 1) 템플릿 형태: .../{w}x{h}bb.jpg
        if replacedUrl.contains("{w}") || replacedUrl.contains("{h}") {
            replacedUrl = replacedUrl.replacingOccurrences(of: "{w}", with: "\(width)")
                 .replacingOccurrences(of: "{h}", with: "\(height)")
            return URL(string: replacedUrl)
        }

        // 2) 숫자 경로 형태: .../source/100x100bb.jpg 또는 .../100x100bb.png
        //    mzstatic 전용 패턴. 다른 호스트는 그대로 둡니다.
        if let host = url.host, host.contains("mzstatic.com") {
            let pattern = #"/(?:source/)?\d+x\d+bb\.(jpg|png)"#
            if let range = replacedUrl.range(of: pattern, options: .regularExpression) {
                let isPNG = replacedUrl[range].hasSuffix(".png")
                let ext = isPNG ? "png" : "jpg"
                let replacement = replacedUrl[range].contains("/source/")
                    ? "/source/\(width)x\(height)bb.\(ext)"
                    : "/\(width)x\(height)bb.\(ext)"
                replacedUrl.replaceSubrange(range, with: replacement)
                return URL(string: replacedUrl)
            }
        }

        // 3) 그 외는 손대지 않음
        return nil
    }

    // MARK: - Downsample Decode

    private static func downsampledImage(from data: Data, maxPixelSize: CGFloat) -> UIImage? {
        let cfData = data as CFData
        guard let src = CGImageSourceCreateWithData(cfData, nil) else { return nil }
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: Int(maxPixelSize)
        ]
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(src, 0, options as CFDictionary) else { return nil }
        return UIImage(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .up)
    }
}
