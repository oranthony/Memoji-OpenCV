//
//  FaceModel.swift
//  Memoji-OpenCV
//
//  Created by anthony loroscio on 10/03/2022.
//

import Foundation

class FaceModel {
    
    var nsArr: Array<CGPoint> = []
    
    var eyeBlinkLeft: Float = 0.0
    var eyeBlinkRight: Float = 1.0
    var jawOpen: Float = 0.0
    var noseReferentialLength: Float = 0.0

    
    func setArray(array: Array<CGPoint>) {
        nsArr = array
        computeJawOpen()
        computeEyeBlink()
        computeNoseReferentialLength()
    }
    
    private func computeJawOpen(){
        if (nsArr.count > 58) {
            print("enter compute jaw open if")
            var valJawOpen = Float(nsArr[57].y - nsArr[51].y)
            
            if (valJawOpen < 80) {
                valJawOpen = 0.0;
            } else if (valJawOpen > 90) {
                valJawOpen = 1.0;
            } else {
                valJawOpen = 0.5;
            }
            
            DispatchQueue.main.async {
                self.jawOpen = valJawOpen
            }
        }
    }
    
    private func computeEyeBlink() {
        if (nsArr.count > 58) {
            
            // Compute eye blink Left
            var valEyeBlinkLeft = Float(nsArr[41].y - nsArr[37].y)
            if (valEyeBlinkLeft > 30) {
                valEyeBlinkLeft = 0;
            } else if (valEyeBlinkLeft < 20) {
                valEyeBlinkLeft = 1;
            } else {
                valEyeBlinkLeft = 0.5;
            }
            
            // Compute eye blink Right
            var valEyeBlinkRight = Float(nsArr[46].y - nsArr[44].y)
            
            if (valEyeBlinkRight > 30) {
                valEyeBlinkRight = 0;
            } else if (valEyeBlinkRight < 20) {
                valEyeBlinkRight = 1;
            } else {
                valEyeBlinkRight = 0.5;
            }
            
            DispatchQueue.main.async {
                self.eyeBlinkLeft = valEyeBlinkLeft
                self.eyeBlinkRight = valEyeBlinkRight
            }
        }
    }
    
    private func computeNoseReferentialLength() {
        if (nsArr.count > 30) {
            let valNose = Float(nsArr[29].y - nsArr[27].y)
            print(valNose)
            DispatchQueue.main.async {
                self.noseReferentialLength = valNose
            }
        }
    }

}
