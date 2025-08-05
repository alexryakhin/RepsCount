import Foundation
import SwiftUI
import Combine

@MainActor
final class HealthKitPermissionService: ObservableObject {
    static let shared = HealthKitPermissionService()
    
    @Published var shouldShowPermissionFlow = false
    @Published var hasShownPermissionFlow = false
    
    private let healthKitManager = HealthKitManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        setupBindings()
    }
    
    private func setupBindings() {
        // Check if we should show permission flow
        healthKitManager.$authorizationStatus
            .map { status in
                status == .notDetermined && !self.hasShownPermissionFlow
            }
            .assign(to: \.shouldShowPermissionFlow, on: self)
            .store(in: &cancellables)
    }
    
    func checkPermissionStatus() {
        Task {
            await healthKitManager.checkAuthorizationStatus()
        }
    }
    
    func markPermissionFlowAsShown() {
        hasShownPermissionFlow = true
        shouldShowPermissionFlow = false
    }
    
    func resetPermissionFlow() {
        hasShownPermissionFlow = false
        shouldShowPermissionFlow = false
    }
}

// MARK: - View Modifier

struct HealthKitPermissionModifier: ViewModifier {
    @StateObject private var permissionService = HealthKitPermissionService.shared
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $permissionService.shouldShowPermissionFlow) {
                HealthKitPermissionView()
                    .onDisappear {
                        permissionService.markPermissionFlowAsShown()
                    }
            }
            .onAppear {
                permissionService.checkPermissionStatus()
            }
    }
}

extension View {
    func healthKitPermissionFlow() -> some View {
        modifier(HealthKitPermissionModifier())
    }
} 
