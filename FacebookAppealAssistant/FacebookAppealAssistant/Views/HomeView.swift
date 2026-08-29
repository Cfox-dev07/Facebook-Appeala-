import SwiftUI
import PhotosUI

struct HomeView: View {
    @StateObject private var login = FacebookLoginManager()
    @State private var selectedItem: PhotosPickerItem?
    @State private var screenshot: UIImage?
    @State private var manualText = ""
    @State private var result: AppealResult?
    @State private var isOCRRunning = false
    @State private var errorMessage: String?

    private let ocr = OCRAnalyzer()
    private let finder = AppealFinder()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {

                    // MARK: - Header

                    Image(systemName: "checkmark.shield.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(.tint)

                    Text("Facebook Appeal Assistant")
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)

                    Text("Mở Facebook chính thức, sau đó đưa screenshot thông báo khóa vào đây để phân tích.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)

                    // MARK: - Open Facebook

                    Button {
                        login.openFacebookLogin()
                    } label: {
                        Label(
                            "Mở Facebook",
                            systemImage: "person.crop.circle"
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

                    // MARK: - Screenshot Picker

                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images
                    ) {
                        Label(
                            "Chọn screenshot",
                            systemImage: "photo"
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .onChange(of: selectedItem) { _, newValue in
                        Task {
                            await loadImage(from: newValue)
                        }
                    }

                    // MARK: - Screenshot Preview

                    if let screenshot {
                        Image(uiImage: screenshot)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 360)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 14)
                            )

                        Button {
                            analyzeScreenshot(screenshot)
                        } label: {
                            if isOCRRunning {
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                            } else {
                                Label(
                                    "OCR + Phân tích",
                                    systemImage: "text.viewfinder"
                                )
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(isOCRRunning)
                    }

                    // MARK: - Manual Text

                    Divider()

                    Text("Hoặc dán thông báo khóa")
                        .font(.headline)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )

                    TextEditor(text: $manualText)
                        .frame(minHeight: 150)
                        .padding(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    .gray.opacity(0.3)
                                )
                        )

                    Button {
                        result = finder.analyze(text: manualText)
                        errorMessage = nil
                    } label: {
                        Label(
                            "Phân tích thông báo",
                            systemImage: "magnifyingglass"
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .disabled(
                        manualText
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                            .isEmpty
                    )

                    // MARK: - Error

                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                    }

                    // MARK: - Result

                    if let result {
                        ResultView(result: result)
                    }

                    // MARK: - Privacy Notice

                    Text(
                        "Ứng dụng không thu thập mật khẩu/cookie/token " +
                        "và không tự gửi kháng cáo. Facebook có thể hiển thị " +
                        "quy trình review khác nhau tùy tài khoản."
                    )
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                    // MARK: - Developer Credits

                    VStack(spacing: 6) {

                        Text("Facebook Appeal Assistant")
                            .font(
                                .footnote.weight(.semibold)
                            )

                        Text("Developer: Fox C")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 14) {

                            Link(
                                "Telegram: @FoxC_dev",
                                destination: URL(
                                    string: "https://t.me/FoxC_dev"
                                )!
                            )

                            Link(
                                "X: @Hunz09",
                                destination: URL(
                                    string: "https://x.com/Hunz09"
                                )!
                            )

                            Link(
                                "GitHub: @Cfox-dev07",
                                destination: URL(
                                    string: "https://github.com/Cfox-dev07"
                                )!
                            )
                        }
                        .font(.caption2)
                        .multilineTextAlignment(.center)

                        Text(appVersion)
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                    .padding(.bottom, 12)
                }
                .padding()
            }
            .navigationTitle("Appeal Assistant")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - App Version

    private var appVersion: String {
        let version =
            Bundle.main.object(
                forInfoDictionaryKey:
                    "CFBundleShortVersionString"
            ) as? String ?? "1.0.0"

        let build =
            Bundle.main.object(
                forInfoDictionaryKey:
                    "CFBundleVersion"
            ) as? String ?? "1"

        return "Version \(version) (\(build))"
    }

    // MARK: - Load Screenshot

    private func loadImage(
        from item: PhotosPickerItem?
    ) async {
        guard let item else {
            return
        }

        do {
            guard
                let data = try await item.loadTransferable(
                    type: Data.self
                ),
                let image = UIImage(data: data)
            else {
                return
            }

            await MainActor.run {
                screenshot = image
                result = nil
                errorMessage = nil
            }

        } catch {
            await MainActor.run {
                errorMessage =
                    error.localizedDescription
            }
        }
    }

    // MARK: - OCR

    private func analyzeScreenshot(
        _ image: UIImage
    ) {
        isOCRRunning = true
        errorMessage = nil

        ocr.recognize(image: image) { output in

            DispatchQueue.main.async {
                isOCRRunning = false

                switch output {

                case .success(let text):
                    manualText = text
                    result = finder.analyze(
                        text: text
                    )

                case .failure(let error):
                    errorMessage =
                        "OCR lỗi: \(error.localizedDescription)"
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    HomeView()
}
