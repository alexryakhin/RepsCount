import SwiftUI

/**
 A shape that unifies the entire map when combined with other `InteractiveShape`s.
 - Parameters :
 - pathData: A struct that holds everything about path (`id`, `name`, `path`, `boundingRect` and `svgBounds`),
 */
@available(iOS 13.0, macOS 10.15, *)
public struct InteractiveShape : Shape {
    let pathData : PathData
    
    public func path(in rect: CGRect) -> Path {
        let path = executeCommand(svgData : pathData, rect: rect)
        return path
    }
    
    public init (_ pathData: PathData) {
        self.pathData = pathData
    }
}


/// Default attributes for Map
@available(iOS 13.0, macOS 10.15, *)
public struct Attributes {
    public var strokeWidth : Double
    public var strokeColor : Color
    public var background: Color
    
    
    public init(
        strokeWidth : Double = 1.2,
        strokeColor: Color = .black,
        background: Color = Color(.sRGB, white: 0.5, opacity: 1)
    ) {
        self.strokeColor = strokeColor
        self.strokeWidth = strokeWidth
        self.background = background
    }
}

@available(iOS 13.0, macOS 10.15, *)
public struct InteractiveMap<Content> : View where Content : View {
    /// name of the SVG, can be written with or without file extension
    let svgName : String
    
    /// Closure that is needed to customize the map,
    var content: ((_ pathData: PathData) -> Content)
    
    
    public init(svgName: String, @ViewBuilder content: @escaping (_ pathData: PathData) -> Content) {
        self.svgName = svgName
        self.content = content
    }

    @State private var pathData = [PathData]()
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                // the data is not initialized yet. That is, we're waiting for .onAppear to be triggered.
                if !pathData.isEmpty {
                    ForEach(pathData) { pathData in
                        content(pathData)
                    }
                    
                }
            }
            .onAppear {
                // scaling paths to fit to screen
                let parser = MapParser(svgName: svgName, size: geo.size)
                pathData = parser.pathDatas 
            }
        }
    }
}


@available(iOS 13.0, macOS 10.15, *)
extension InteractiveShape {
    /// Uses default Attributes for coloring map
    /// - `strokeWidth : Double = 1.2,`
    /// - `strokeColor: Color = .black,`
    /// - `background: Color = Color(.sRGB, white: 0.5, opacity: 1)`
    public func initWithAttributes() -> some View {
        let attributes = Attributes()
        return self
            .stroke(attributes.strokeColor, lineWidth: attributes.strokeWidth)
            .background(self.fill(attributes.background))
    }
    
    public func initWithAttributes(_ attributes : Attributes) -> some View {
        self
            .stroke(attributes.strokeColor, lineWidth: attributes.strokeWidth)
            .background(self.fill(attributes.background))
    }
}

