//
//  Array+Safe.swift
//  Reynard
//
//  Created by Minh Ton on 4/3/26.
//

import UIKit

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

enum PlatformCompatColor {
    static var systemBackground: UIColor {
#if os(tvOS)
    return .black
#else
    return .systemBackground
#endif
    }

    static var groupedBackground: UIColor {
#if os(tvOS)
    return UIColor(white: 0.12, alpha: 1)
#else
    return .systemGroupedBackground
#endif
    }

    static var secondaryBackground: UIColor {
#if os(tvOS)
    return UIColor(white: 0.16, alpha: 1)
#else
    return .secondarySystemBackground
#endif
    }

    static var tertiaryBackground: UIColor {
#if os(tvOS)
    return UIColor(white: 0.2, alpha: 1)
#else
    return .tertiarySystemBackground
#endif
    }

    static var gray3: UIColor {
#if os(tvOS)
    return UIColor(white: 0.42, alpha: 1)
#else
    return .systemGray3
#endif
    }

    static var gray4: UIColor {
#if os(tvOS)
    return UIColor(white: 0.35, alpha: 1)
#else
    return .systemGray4
#endif
    }

    static var gray6: UIColor {
#if os(tvOS)
    return UIColor(white: 0.16, alpha: 1)
#else
    return .systemGray6
#endif
    }

    static var quaternaryFill: UIColor {
#if os(tvOS)
    return UIColor(white: 1, alpha: 0.12)
#else
    return .quaternarySystemFill
#endif
    }

    static var systemFill: UIColor {
#if os(tvOS)
    return UIColor(white: 1, alpha: 0.2)
#else
    return .systemFill
#endif
    }
}

enum PlatformCompatStyle {
    static var listSidebarAppearance: UICollectionLayoutListConfiguration.Appearance {
#if os(tvOS)
    return .plain
#else
    return .sidebar
#endif
    }

    static var tableInsetGrouped: UITableView.Style {
#if os(tvOS)
    return .grouped
#else
    return .insetGrouped
#endif
    }

    static var tabOverviewBlur: UIBlurEffect.Style {
#if os(tvOS)
    return .regular
#else
    return .systemMaterial
#endif
    }

    static var modalPresentation: UIModalPresentationStyle {
#if os(tvOS)
    return .fullScreen
#else
    return .pageSheet
#endif
    }
}
