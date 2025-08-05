import SwiftUI
import HealthKit

struct HealthKitPermissionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = HealthKitPermissionViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 24) {
                    // App Icon
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "heart.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.blue)
                    }
                    
                    // Title and Description
                    VStack(spacing: 12) {
                        Text("Access the latest updates")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("We're releasing new features and need more permissions to your Health data.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 60)
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Continue Button
                Button {
                    viewModel.requestHealthKitPermissions()
                } label: {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        
                        Text(viewModel.isLoading ? "Requesting..." : "Continue")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue)
                    )
                }
                .disabled(viewModel.isLoading)
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
        }
        .onReceive(viewModel.$permissionsGranted) { granted in
            if granted {
                dismiss()
            }
        }
    }
}

final class HealthKitPermissionViewModel: ObservableObject {
    @Published var permissionsGranted = false
    @Published var isLoading = false
    
    func requestHealthKitPermissions() {
        isLoading = true
        
        Task {
            let success = await HealthKitManager.shared.requestPermissions()
            
            await MainActor.run {
                self.isLoading = false
                self.permissionsGranted = success
            }
        }
    }
}

#Preview {
    HealthKitPermissionView()
} 