//
//  UIExtension.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 30/07/23.
//

import SwiftUI

enum Gilroy: String {
    case regular = "Gilroy-Regular"
    case medium = "Gilroy-Medium"
    case semibold = "Gilroy-SemiBold"
    case bold = "Gilroy-Bold"
}

extension Font {
    
    static func customfont(_ font: Gilroy, fontSize: CGFloat) -> Font {
        switch font {
        case .regular:
            return .system(size: fontSize, weight: .regular)
        case .medium:
            return .system(size: fontSize, weight: .medium)
        case .semibold:
            return .system(size: fontSize, weight: .semibold)
        case .bold:
            return .system(size: fontSize, weight: .bold)
        }
    }
}

extension CGFloat {
    
    private static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }

    private static var currentScreen: UIScreen? {
        keyWindow?.windowScene?.screen
    }

    static var screenWidth: Double {
        Double(keyWindow?.bounds.width ?? currentScreen?.bounds.width ?? 390)
    }

    static var screenHeight: Double {
        Double(keyWindow?.bounds.height ?? currentScreen?.bounds.height ?? 844)
    }
    
    static func widthPer(per: Double) -> Double {
        return screenWidth * per
    }
    
    static func heightPer(per: Double) -> Double {
        return screenHeight * per
    }
    
    static var topInsets: Double {
        Double(keyWindow?.safeAreaInsets.top ?? 0)
    }
    
    static var bottomInsets: Double {
        Double(keyWindow?.safeAreaInsets.bottom ?? 0)
    }
    
    static var horizontalInsets: Double {
        guard let w = keyWindow else { return 0.0 }
        return Double(w.safeAreaInsets.left + w.safeAreaInsets.right)
    }
    
    static var verticalInsets: Double {
        guard let w = keyWindow else { return 0.0 }
        return Double(w.safeAreaInsets.top + w.safeAreaInsets.bottom)
    }
    
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB(12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension Color {
    
    static let primaryApp = Color(hex: "50C850")
    static let secondaryprimaryApp = Color(hex: "806848")
    
    static let primaryText = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(hex: "F3F3F3") : UIColor(hex: "030303")
    })
    
    static let secondaryText = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(hex: "AAAAAA") : UIColor(hex: "828282")
    })
    
    static let textTitle = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(hex: "BBBBBB") : UIColor(hex: "7C7C7C")
    })
    
    static let placeholder = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(hex: "555555") : UIColor(hex: "B1B1B1")
    })
    
    static let darkGray = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(hex: "CCCCCC") : UIColor(hex: "4C4F4D")
    })
    
    static let cardBackground = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(hex: "1C1C1E") : UIColor(hex: "F8F8FA")
    })
    
    static let bgDetail = Color(UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor(hex: "121212") : UIColor.white
    })
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
            case 3: // RGB(12 -bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct ShowButton: ViewModifier {
    @Binding var isShow: Bool
    
    public func body(content: Content) -> some View {
        
        HStack {
            content
            Button {
                isShow.toggle()
            } label: {
                Image(systemName: !isShow ? "eye.fill" : "eye.slash.fill" )
                    .foregroundColor(.textTitle)
            }

        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corner:  UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corers: corner))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corers: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corers, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension UIImage {
    func resizeImage(to size: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

private final class TabImageCache {
    static let shared = TabImageCache()
    private var cache = [String: Image]()
    private let lock = NSLock()
    
    func image(named name: String, isSelected: Bool) -> Image {
        let key = "\(name)_\(isSelected)"
        lock.lock()
        defer { lock.unlock() }
        
        if let cached = cache[key] {
            return cached
        }
        
        if let uiImage = UIImage(named: name) {
            let resized = uiImage.resizeImage(to: CGSize(width: 24, height: 24))
            let renderingMode: UIImage.RenderingMode = isSelected ? .alwaysOriginal : .alwaysTemplate
            let finalImage = Image(uiImage: resized.withRenderingMode(renderingMode))
            cache[key] = finalImage
            return finalImage
        }
        
        let fallback = Image(name)
        cache[key] = fallback
        return fallback
    }
}

extension Image {
    static func resizedTabImage(named name: String, isSelected: Bool) -> Image {
        TabImageCache.shared.image(named: name, isSelected: isSelected)
    }
}
