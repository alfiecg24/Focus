//
//  UIDevice+Extension.swift
//  Focus
//
//  Created by Alfie on 10/09/2022.
//

import Foundation
import UIKit

public extension UIDevice {

   class var isPhone: Bool {
       return UIDevice.current.userInterfaceIdiom == .phone
   }

   class var isPad: Bool {
       return UIDevice.current.userInterfaceIdiom == .pad
   }

   class var isTV: Bool {
       return UIDevice.current.userInterfaceIdiom == .tv
   }

   class var isCarPlay: Bool {
       return UIDevice.current.userInterfaceIdiom == .carPlay
   }
}
