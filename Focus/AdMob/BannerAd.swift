//
//  BannerAd.swift
//  Pomodoro
//
//  Created by Alfie on 16/08/2022.
//

import Foundation
import SwiftUI
import GoogleMobileAds

struct GADBannerViewController: UIViewControllerRepresentable {
  
  func makeUIViewController(context: Context) -> some UIViewController {
    let view = GADBannerView(adSize: GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width))
    let viewController = UIViewController()
    let testID = "ca-app-pub-4800768255188443/5378668507"
      
    // Banner Ad
    view.adUnitID = testID
    view.rootViewController = viewController
    
    // View Controller
    viewController.view.addSubview(view)
    viewController.view.frame = CGRect(origin: .zero, size: GADAdSizeBanner.size)
    
    // Load an ad
    view.load(GADRequest())
    
    return viewController
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
  
}
