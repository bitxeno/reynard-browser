//
//  MakeButtons.swift
//  Reynard
//
//  Created by Minh Ton on 5/3/26.
//

import UIKit
import Darwin

enum MakeButtons {
    static let hasLiquidGlass = false
    
    static func makeToolbarButton(target: AnyObject, imageName: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: imageName), for: .normal)
        if imageName == "plus" {
            button.setPreferredSymbolConfiguration(
                UIImage.SymbolConfiguration(pointSize: 20, weight: .regular),
                forImageIn: .normal
            )
        }
        button.tintColor = .label
        button.addTarget(target, action: action, for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.cornerCurve = .continuous
        return button
    }
    
    static func makeToolbarButton(controller: BrowserViewController, imageName: String, action: Selector) -> UIButton {
        makeToolbarButton(target: controller, imageName: imageName, action: action)
    }
    
    static func makeTabOverviewBarButton(controller: BrowserViewController, imageName: String, isFilled: Bool, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.setPreferredSymbolConfiguration(
            UIImage.SymbolConfiguration(pointSize: 17, weight: .regular),
            forImageIn: .normal
        )
        button.tintColor = isFilled ? PlatformCompatColor.systemBackground : .label
        button.backgroundColor = isFilled ? .label : PlatformCompatColor.quaternaryFill
        button.layer.borderWidth = isFilled ? 0 : 1
        button.layer.borderColor = isFilled ? UIColor.clear.cgColor : PlatformCompatColor.systemFill.cgColor
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 21
        button.addTarget(controller, action: action, for: .touchUpInside)
        return button
    }
    
    static func makeTabOverviewBarButtonItem(controller: BrowserViewController, systemItem: UIBarButtonItem.SystemItem, action: Selector) -> UIBarButtonItem {
        let item = UIBarButtonItem(barButtonSystemItem: systemItem, target: controller, action: action)
        item.tintColor = .label
        return item
    }
}
