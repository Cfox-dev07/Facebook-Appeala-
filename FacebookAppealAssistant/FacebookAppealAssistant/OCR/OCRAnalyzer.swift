import UIKit
import Vision
import ImageIO

final class OCRAnalyzer {
    enum OCRFailure: LocalizedError {
        case invalidImage
        case noText

        var errorDescription: String? {
            switch self {
            case .invalidImage: return "Ảnh không hợp lệ."
            case .noText: return "Không tìm thấy văn bản trong screenshot."
            }
        }
    }

    func recognize(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(.failure(OCRFailure.invalidImage))
            return
        }

        let request = VNRecognizeTextRequest { request, error in
            if let error {
                completion(.failure(error))
                return
            }

            let observations = request.results as? [VNRecognizedTextObservation] ?? []
            let text = observations
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")

            if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                completion(.failure(OCRFailure.noText))
            } else {
                completion(.success(text))
            }
        }

        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        request.minimumTextHeight = 0.01

        let handler = VNImageRequestHandler(
            cgImage: cgImage,
            orientation: CGImagePropertyOrientation(image.imageOrientation),
            options: [:]
        )

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                completion(.failure(error))
            }
        }
    }
}

private extension CGImagePropertyOrientation {
    init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .up: self = .up
        case .down: self = .down
        case .left: self = .left
        case .right: self = .right
        case .upMirrored: self = .upMirrored
        case .downMirrored: self = .downMirrored
        case .leftMirrored: self = .leftMirrored
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}
