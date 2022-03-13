//
//  MemojiViewModel.swift
//  Memoji-OpenCV
//
//  Created by anthony loroscio on 09/03/2022.
//

import Foundation
import SwiftUI
import SceneKit
import ARKit

class MemojiViewModel: NSObject,AVCaptureVideoDataOutputSampleBufferDelegate, ObservableObject {
    @Published var faceModel:FaceModel = FaceModel() // ViewModel have a Model
    @Published var noseReferentiel: Float = 0.0
    
    var scene: SCNScene! /*{
        //SCNScene(named: "Models.scnassets/Avatar.scn")
        SCNScene(named: "SceneKit Asset Catalog.scnassets/face-model.scn")
    }*/
    
    var contentNode: SCNReferenceNode? // Reference to the .scn file
    private lazy var model = contentNode!.childNode(withName: "model", recursively: true)! // Whole model including eyes (not used currently)
    private lazy var head = contentNode!.childNode(withName: "POLYWINK_Bella", recursively: true)! // Contains blendshapes
    
    private var node1:SCNNode!
    
    private var captureSession: AVCaptureSession = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()

    var cameraNode: SCNNode? {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0.2, z: 1.1)
        cameraNode.camera?.fieldOfView = 40;
        
        return cameraNode
    }
    
    override init() {
        super.init()
        initialize()
    }
    
    /**
    Initialize the bridge to the C++ code and the SceneKit elements
     */
    func initialize() {
        // Set up the Objective-C++ Bridge
        FaceToolsBridge().initialize()
        
        // Set up the SceneKit elements with the 3D model head
        setScene()
        setCamera()
    }
    
    
    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate -> where the stuff happens
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection) {
        
        guard let  imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags.readOnly)
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedFirst.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        guard let quartzImage = context?.makeImage() else { return }
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags.readOnly)
        let image = UIImage(cgImage: quartzImage)
            
            
            let jawOpen = FaceToolsBridge().getArrayOfLandmarks(from: image).map { $0.cgPointValue }
        faceModel.setArray(array: jawOpen)
            
            // Updating model blendshape in scene kit with the user's facial landmarks
            DispatchQueue.main.async {
                self.noseReferentiel = self.faceModel.noseReferentialLength
                
                self.node1?.morpher?.setWeight(CGFloat(self.faceModel.jawOpen), forTargetNamed: "jawOpen")
                
                self.node1?.morpher?.setWeight(CGFloat(self.faceModel.eyeBlinkRight), forTargetNamed: "eyeBlink_R")
                
                self.node1?.morpher?.setWeight(CGFloat(self.faceModel.eyeBlinkLeft), forTargetNamed: "eyeBlink_L")
            }
        }

    
    
    // MARK: Private functions to handle stuff
    
    private func addCameraInput() {
        guard let device = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
            mediaType: .video,
            position: .front).devices.first else {
                fatalError("No back camera device found, please make sure to run SimpleLaneDetection in an iOS device and not a simulator")
        }
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        self.captureSession.addInput(cameraInput)
    }
    
    private func getFrames() {
        videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera.frame.processing.queue"))
        self.captureSession.addOutput(videoDataOutput)
        guard let connection = self.videoDataOutput.connection(with: AVMediaType.video),
            connection.isVideoOrientationSupported else { return }
        connection.videoOrientation = .portrait
    }
    
    
    private func setScene() {
        if let filePath = Bundle.main.path(forResource: "face-model", ofType: "scn", inDirectory: "SceneKit Asset Catalog.scnassets") {
            let referenceURL = URL(fileURLWithPath: filePath)
            
            self.contentNode = SCNReferenceNode(url: referenceURL)
            self.contentNode?.load()
            self.head.morpher?.unifiesNormals = true // ensures the normals are not morphed but are recomputed after morphing the vertex instead. Otherwise the node has a low poly look.
            
            let scene = SCNScene(named: "SceneKit Asset Catalog.scnassets/face-model.scn")
            /*let scnView = SCNView()
            scnView.scene = scene*/
            self.scene = scene
            //self.scene.rootNode.addChildNode(self.contentNode!)
            
            let node = scene?.rootNode.childNode(withName: "POLYWINK_Bella", recursively: true)
            node1 = node
        
        }
    }
    
    private func setCamera() {
        self.addCameraInput()
        self.getFrames()
        self.captureSession.startRunning()
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
            if (granted) {
                //print("yes")
            } else {
                // If access is not granted, throw error and exit
                fatalError("This app needs Camera Access to function. You can grant access in Settings.")
            }
        }
    }
}
