import SwiftUI

// Backyard Birds design system — warm meadow palette, forced light appearance.
enum Aviary {
    static let cream = Color(hex: 0xFAF6EC)
    static let card = Color(hex: 0xFFFFFF)
    static let ink = Color(hex: 0x33302A)
    static let inkSoft = Color(hex: 0x6E6858)
    static let forest = Color(hex: 0x2E5E4E)
    static let forestDeep = Color(hex: 0x224638)
    static let amber = Color(hex: 0xE3A94C)
    static let amberDeep = Color(hex: 0xC98A2E)
    static let terracotta = Color(hex: 0xC96F4A)
    static let sage = Color(hex: 0x7B9E6B)
    static let sky = Color(hex: 0x6F9EC4)
    static let line = Color(hex: 0xE8E0CC)
    static let creamDark = Color(hex: 0xF1EADA)
    static let rose = Color(hex: 0xC24E5E)

    static let corner: CGFloat = 18

    static func title(_ size: CGFloat) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }
    static func body(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    static var contentMaxWidth: CGFloat { isPad ? 700 : .infinity }
}

extension Color {
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}

enum AviaryFormat {
    static let day: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "MMM d, yyyy"
        return f
    }()
    static let dayShort: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "MMM d"
        return f
    }()
    static let monthYear: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "MMMM yyyy"
        return f
    }()
    static let weekdayDay: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "EEEE, MMM d"
        return f
    }()

    static func monthName(_ month: Int) -> String {
        let names = ["January", "February", "March", "April", "May", "June",
                     "July", "August", "September", "October", "November", "December"]
        guard month >= 1 && month <= 12 else { return "" }
        return names[month - 1]
    }
    static func monthShort(_ month: Int) -> String {
        let names = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                     "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        guard month >= 1 && month <= 12 else { return "" }
        return names[month - 1]
    }
}
