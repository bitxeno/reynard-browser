//
//  TabOverview.swift
//  Reynard
//
//  Created by Minh Ton on 5/3/26.
//

import UIKit

final class TabOverview {
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = PlatformCompatColor.gray6
        view.alpha = 0
        view.isHidden = true
        return view
    }()
    
    let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: PlatformCompatStyle.tabOverviewBlur))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
}
