import SwiftUI
import HealthKit

struct HealthKitDetailPermissionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = HealthKitDetailPermissionViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    // Health App Icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.pink.opacity(0.1))
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "heart.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.pink)
                    }
                    
                    Text("Health Access")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                // Permission Request Text
                VStack(spacing: 8) {
                    Text("Health")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("\"RepsCount\" would like to access and update your Health data.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Turn On All Button
                Button {
                    viewModel.turnOnAllPermissions()
                } label: {
                    Text("Turn On All")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                        )
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                // Write Permissions Section
                VStack(spacing: 12) {
                    Text("Allow 'RepsCount' to write")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    VStack(spacing: 0) {
                        ForEach(viewModel.healthDataTypes) { dataType in
                            HealthDataTypeRow(
                                dataType: dataType,
                                isEnabled: viewModel.enabledTypes.contains(dataType.id)
                            ) {
                                viewModel.togglePermission(for: dataType.id)
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                    )
                    .padding(.horizontal, 20)
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button {
                        viewModel.allowPermissions()
                    } label: {
                        Text("Allow")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray5))
                            )
                    }
                    .disabled(!viewModel.hasAnyPermissionEnabled)
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("Don't Allow")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
        }
        .onReceive(viewModel.$permissionsGranted) { granted in
            if granted {
                dismiss()
            }
        }
    }
}

struct HealthDataTypeRow: View {
    let dataType: HealthDataType
    let isEnabled: Bool
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(dataType.color.opacity(0.1))
                    .frame(width: 32, height: 32)
                
                Image(systemName: dataType.icon)
                    .font(.system(size: 16))
                    .foregroundColor(dataType.color)
            }
            
            // Title
            Text(dataType.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isEnabled ? .primary : .secondary)
            
            Spacer()
            
            // Toggle
            Toggle("", isOn: .constant(isEnabled))
                .labelsHidden()
                .onTapGesture {
                    onToggle()
                }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Rectangle()
                .fill(Color.clear)
        )
    }
}

struct HealthDataType: Identifiable {
    let id: String
    let title: String
    let icon: String
    let color: Color
    let hkType: HKObjectType?
}

final class HealthKitDetailPermissionViewModel: ObservableObject {
    @Published var enabledTypes: Set<String> = []
    @Published var permissionsGranted = false
    
    let healthDataTypes: [HealthDataType] = [
        // Basic workout data
        HealthDataType(
            id: "workouts",
            title: "Workouts",
            icon: "figure.run",
            color: .blue,
            hkType: HKObjectType.workoutType()
        ),
        HealthDataType(
            id: "activeEnergy",
            title: "Active Energy",
            icon: "flame.fill",
            color: .orange,
            hkType: HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
        ),
        HealthDataType(
            id: "distance",
            title: "Distance",
            icon: "figure.walk",
            color: .green,
            hkType: HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
        ),
        HealthDataType(
            id: "heartRate",
            title: "Heart Rate",
            icon: "heart.fill",
            color: .red,
            hkType: HKObjectType.quantityType(forIdentifier: .heartRate)
        ),
        HealthDataType(
            id: "steps",
            title: "Steps",
            icon: "figure.walk",
            color: .purple,
            hkType: HKObjectType.quantityType(forIdentifier: .stepCount)
        ),
        
        // Recovery data
        HealthDataType(
            id: "sleep",
            title: "Sleep Analysis",
            icon: "bed.double.fill",
            color: .indigo,
            hkType: HKObjectType.categoryType(forIdentifier: .sleepAnalysis)
        ),
        HealthDataType(
            id: "heartRateVariability",
            title: "Heart Rate Variability",
            icon: "waveform.path.ecg",
            color: .pink,
            hkType: HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)
        ),
        HealthDataType(
            id: "restingHeartRate",
            title: "Resting Heart Rate",
            icon: "heart.circle.fill",
            color: .red,
            hkType: HKObjectType.quantityType(forIdentifier: .restingHeartRate)
        ),
        HealthDataType(
            id: "vo2Max",
            title: "VO2 Max",
            icon: "lungs.fill",
            color: .cyan,
            hkType: HKObjectType.quantityType(forIdentifier: .vo2Max)
        ),
        HealthDataType(
            id: "oxygenSaturation",
            title: "Blood Oxygen",
            icon: "drop.fill",
            color: .blue,
            hkType: HKObjectType.quantityType(forIdentifier: .oxygenSaturation)
        ),
        
        // Stress and wellness data
        HealthDataType(
            id: "respiratoryRate",
            title: "Respiratory Rate",
            icon: "lungs",
            color: .teal,
            hkType: HKObjectType.quantityType(forIdentifier: .respiratoryRate)
        ),
        HealthDataType(
            id: "bloodPressure",
            title: "Blood Pressure",
            icon: "heart.text.square.fill",
            color: .red,
            hkType: HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic)
        ),
        
        // Activity data for strain
        HealthDataType(
            id: "basalEnergy",
            title: "Basal Energy",
            icon: "flame",
            color: .orange,
            hkType: HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)
        ),
        HealthDataType(
            id: "exerciseTime",
            title: "Exercise Time",
            icon: "timer",
            color: .green,
            hkType: HKObjectType.quantityType(forIdentifier: .appleExerciseTime)
        ),
        HealthDataType(
            id: "standTime",
            title: "Stand Time",
            icon: "figure.stand",
            color: .blue,
            hkType: HKObjectType.quantityType(forIdentifier: .appleStandTime)
        ),
        
        // Body composition
        HealthDataType(
            id: "bodyMass",
            title: "Body Mass",
            icon: "scalemass.fill",
            color: .gray,
            hkType: HKObjectType.quantityType(forIdentifier: .bodyMass)
        ),
        HealthDataType(
            id: "bodyFat",
            title: "Body Fat %",
            icon: "percent",
            color: .brown,
            hkType: HKObjectType.quantityType(forIdentifier: .bodyFatPercentage)
        ),
    ]
    
    var hasAnyPermissionEnabled: Bool {
        !enabledTypes.isEmpty
    }
    
    func togglePermission(for id: String) {
        if enabledTypes.contains(id) {
            enabledTypes.remove(id)
        } else {
            enabledTypes.insert(id)
        }
    }
    
    func turnOnAllPermissions() {
        enabledTypes = Set(healthDataTypes.map { $0.id })
    }
    
    func allowPermissions() {
        Task {
            let success = await HealthKitManager.shared.requestPermissions()
            
            await MainActor.run {
                self.permissionsGranted = success
            }
        }
    }
}

#Preview {
    HealthKitDetailPermissionView()
} 
