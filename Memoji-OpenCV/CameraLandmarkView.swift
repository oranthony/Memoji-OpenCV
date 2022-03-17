//
//  CameraLandmarkView.swift
//  Memoji-OpenCV
//
//  Created by anthony on 16/03/2022.
//

import SwiftUI
import SceneKit

struct CameraLandmarkView: View {
    @ObservedObject var memojiViewModel = MemojiViewModel(mode: "cam")

    var body: some View {
        
        if ((memojiViewModel.frame) != nil) {
            GeometryReader { geo in
                memojiViewModel.frame!
                    .resizable()
                    //.scaledToFit()
                    //.frame(width: geo.size.width, height: geo.size.height)
            }
        } else {
            EmptyView()
        }
    }
}

struct CameraLandmarkView_Previews: PreviewProvider {
    static var previews: some View {
        MemojiView()
    }
}
