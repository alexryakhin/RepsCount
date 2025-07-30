import SwiftUI
import Core

public struct MuscleMapImageView: View {
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Constants and Types
    private static let imageCache = NSCache<NSString, UIImage>()
    private static let aspectRatio: CGFloat = 0.35

    enum ColorStyle {
        case primary, secondary, notInvolved, background

        var color: Color {
            switch self {
            case .primary: return .primaryMuscleGroup
            case .secondary: return .secondaryMuscleGroup
            case .notInvolved: return Color(.quaternarySystemFill)
            case .background: return Color(.systemGroupedBackground)
            }
        }
    }

    // MARK: - Properties
    private let width: CGFloat
    private let primaryMuscleGroups: Set<MuscleGroup>
    private let secondaryMuscleGroups: Set<MuscleGroup>

    @State private var frontImage: Image?
    @State private var backImage: Image?

    // MARK: - Initializers
    public init(
        primaryMuscleGroups: [MuscleGroup],
        secondaryMuscleGroups: [MuscleGroup],
        width: CGFloat = 60
    ) {
        self.primaryMuscleGroups = Set(primaryMuscleGroups)
        self.secondaryMuscleGroups = Set(secondaryMuscleGroups)
        self.width = width
    }

    public init(exercises: [ExerciseModel], width: CGFloat = 60) {
        self.primaryMuscleGroups = Set(exercises.flatMap(\.primaryMuscleGroups))
        self.secondaryMuscleGroups = Set(exercises.flatMap(\.secondaryMuscleGroups))
        self.width = width
    }

    public init(exercise: ExerciseModel, width: CGFloat = 60) {
        self.primaryMuscleGroups = Set(exercise.primaryMuscleGroups)
        self.secondaryMuscleGroups = Set(exercise.secondaryMuscleGroups)
        self.width = width
    }

    // MARK: - Body
    public var body: some View {
        HStack(spacing: 8) {
            if let frontImage, let backImage {
                frontImageView(image: frontImage)
                backImageView(image: backImage)
            } else {
                loadingView
                    .onAppear {
                        loadImages()
                    }
            }
        }
        .task(id: cacheKey(for: "")) {
            frontImage = nil
            backImage = nil
        }
    }

    // MARK: - View Components
    private func frontImageView(image: Image) -> some View {
        image
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, alignment: .center)
    }

    private func backImageView(image: Image) -> some View {
        image
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, alignment: .center)
    }

    private var loadingView: some View {
        ZStack {
            Color(.systemGroupedBackground)
            ProgressView()
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Rendering Logic
    private func background(for shape: PathData) -> some View {
        let style: ColorStyle = {
            switch shape.name {
            case let name where primaryMuscleGroups.contains(where: { $0.id == name }):
                return .primary
            case let name where secondaryMuscleGroups.contains(where: { $0.id == name }):
                return .secondary
            case "background":
                return .background
            default:
                return .notInvolved
            }
        }()

        return InteractiveShape(shape)
            .fill(style.color)
    }

    private func renderMuscleMap(svgName: String) async -> UIImage {
        let cacheKey = cacheKey(for: svgName)

        if let cached = Self.imageCache.object(forKey: cacheKey) {
            return cached
        }

        let muscleMap = InteractiveMap(svgName: svgName) { shape in
            InteractiveShape(shape)
                .stroke(Color.accentColor, lineWidth: 1)
                .background(background(for: shape))
        }
        .padding(1)
        .environment(\.colorScheme, colorScheme)

        let renderer = ImageRenderer(content: muscleMap)
        renderer.proposedSize = ProposedViewSize(
            width: width,
            height: width / Self.aspectRatio
        )
        renderer.scale = UIScreen.main.scale

        let uiImage = renderer.uiImage ?? UIImage()
        Self.imageCache.setObject(uiImage, forKey: cacheKey)
        return uiImage
    }

    // MARK: - Helpers
    private func cacheKey(for svgName: String) -> NSString {
        let primary = primaryMuscleGroups.map(\.rawValue).sorted().joined(separator: ";")
        let secondary = secondaryMuscleGroups.map(\.rawValue).sorted().joined(separator: ";")
        return "\(svgName)|\(primary)|\(secondary)|\(width)|\(colorScheme)" as NSString
    }

    private func loadImages() {
        Task { @MainActor in
            async let front = renderMuscleMap(svgName: "front")
            async let back = renderMuscleMap(svgName: "back")
            let (frontResult, backResult) = await (front, back)

            frontImage = Image(uiImage: frontResult)
            backImage = Image(uiImage: backResult)
        }
    }
}
