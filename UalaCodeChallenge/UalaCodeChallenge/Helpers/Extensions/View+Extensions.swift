//
//  View+Extensions.swift
//  UalaCodeChallenge
//
//  Created by Gonzalo Fuentes on 19/01/2026.
//

import SwiftUI

extension View {
    var screenBounds: CGRect {
        let screen = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.screen
        
        return screen?.bounds ?? CGRect(x: 0, y: 0, width: 350, height: 700)
    }
}
