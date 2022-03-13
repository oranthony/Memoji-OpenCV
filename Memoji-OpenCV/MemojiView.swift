//
//  MemojiView.swift
//  Memoji-OpenCV
//
//  Created by anthony loroscio on 09/03/2022.
//

import SwiftUI
import SceneKit

struct MemojiView: View {
    @ObservedObject var memojiViewModel = MemojiViewModel()

    var body: some View {
        VStack {
            Text("\(memojiViewModel.noseReferentiel)")
                .padding()
            
            SceneView(
                scene: memojiViewModel.scene,
                    pointOfView: memojiViewModel.cameraNode,
                    options: [
                        .autoenablesDefaultLighting,
                        .temporalAntialiasingEnabled
                    ]
                )
        }
    }
}

struct MemojiView_Previews: PreviewProvider {
    static var previews: some View {
        MemojiView()
    }
}
