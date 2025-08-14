//
//  ArtworkBinder.swift
//  Att
//
//  Created by 황정현 on 8/11/25.
//

import UIKit

final class ArtworkBinder {
    private let loader: ImageLoader
    private var task: Task<Void, Never>?
    private var currentURL: URL?
    private let placeholder: UIImage?

    init(loader: ImageLoader, placeholder: UIImage? = UIImage(named: "placeholder")) {
        self.loader = loader
        self.placeholder = placeholder
    }

    deinit { cancel() }

    /// 단일 타깃에 바인딩
    @MainActor
    func bind(url: URL?, apply: @MainActor @escaping (UIImage?) -> Void) {
        bind(url: url, applyMultiple: [apply])
    }

    /// 여러 타깃(예: 배경 + 썸네일)에 동시에 바인딩
    @MainActor
    func bind(url: URL?, applyMultiple appliers: [@MainActor (UIImage?) -> Void]) {
        // 초기 상태(플레이스홀더)
        appliers.forEach { $0(placeholder) }

        // 이전 작업 취소 및 최신 URL 기록
        task?.cancel()
        currentURL = url

        guard let url else { return }

        // 캐시 히트면 즉시 반영
        if let cached = loader.cachedImage(for: url) {
            appliers.forEach { $0(cached) }
            return
        }

        // 미스면 비동기 로드
        task = Task { [weak self] in
            guard let self = self else { return }
            let image = try? await self.loader.loadImage(from: url,
                                                         targetPointSize: CGSize(width: 500, height: 500),
                                                         screenScale: UIScreen.main.scale)
            // 레이스 가드(최신 URL인지 확인)
            guard self.currentURL == url else { return }
            await MainActor.run {
                appliers.forEach { $0(image ?? self.placeholder) }
            }
        }
    }

    func cancel() { task?.cancel() }
}
