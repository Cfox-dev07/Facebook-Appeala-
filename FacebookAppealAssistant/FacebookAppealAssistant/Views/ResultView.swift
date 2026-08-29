import SwiftUI

struct ResultView: View {
    let result: AppealResult

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: result.status.icon)
                    .font(.title)
                VStack(alignment: .leading) {
                    Text(result.status.displayName)
                        .font(.headline)
                    Text("Độ tin cậy: \(Int(result.confidence * 100))%")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            if !result.signals.isEmpty {
                Text("Tín hiệu phát hiện")
                    .font(.headline)
                ForEach(result.signals, id: \.self) { signal in
                    Label(signal, systemImage: "checkmark.circle.fill")
                }
            }

            Text("Đường hỗ trợ phù hợp")
                .font(.headline)

            ForEach(result.recommendations) { item in
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.title).font(.headline)
                    Text(item.reason)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Link("Mở trang chính thức", destination: item.url)
                    Text(item.requiresLogin ? "🔐 Có thể yêu cầu đăng nhập" : "🌐 Có thể mở trực tiếp")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
    }
}
