//
//  InterstitialAd.swift
//  Pomodoro
//
//  Created by Alfie on 16/08/2022.
//

import Foundation
import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

class AdsManager: NSObject, ObservableObject {
    
    private struct AdMobConstant {
        static let interstitialID = "ca-app-pub-4800768255188443/6422773974"
    }
    
    final class Interstitial: NSObject, GADFullScreenContentDelegate, ObservableObject {

        private var interstitial: GADInterstitialAd?
        
        override init() {
            super.init()
            requestInterstitialAds()
        }

        func requestInterstitialAds() {
            let request = GADRequest()
            request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                GADInterstitialAd.load(withAdUnitID: AdMobConstant.interstitialID, request: request, completionHandler: { [self] ad, error in
                    if let error = error {
                        print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                        return
                    }
                    interstitial = ad
                    interstitial?.fullScreenContentDelegate = self
                })
            })
        }
        
        func showAd() {
            let root = UIApplication.shared.keyWindow?.rootViewController
            if let fullScreenAds = interstitial {
                fullScreenAds.present(fromRootViewController: root!)
            } else {
                print("not ready")
            }
        }
        
    }
}


class AdsViewModel: ObservableObject {
    static let shared = AdsViewModel()
    @Published var interstitial = AdsManager.Interstitial()
    @Published var showInterstitial = false {
        didSet {
            if showInterstitial {
                interstitial.showAd()
                showInterstitial = false
            } else {
                interstitial.requestInterstitialAds()
            }
        }
    }
}

extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}
