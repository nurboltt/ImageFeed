//
//  ProgessHUDConfigurator.swift
//  ImageFeed
//
//  Created by Nurbol on 11.10.2024.
//

import ProgressHUD

final class ProgressHUDConfigurator {
    static func configure() {
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.colorHUD = .black
        ProgressHUD.colorAnimation = .lightGray
    }
}
