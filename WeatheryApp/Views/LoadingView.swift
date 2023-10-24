//
//  LoadingView.swift
//  WeatheryApp
//
//  Created by Deimante Valunaite on 03/09/2023.
//

import SwiftUI
import CoreLocation

struct LoadingView: View {
    var body: some View {
       ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .primary))
            .font(.system(size: 100))
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
