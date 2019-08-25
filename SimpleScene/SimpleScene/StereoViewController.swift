//
//  StereoViewController.swift
//  SimpleScene
//
//  Created by Paige Sun on 2019-08-24.
//  Copyright © 2019 Paige Sun. All rights reserved.
//

import UIKit
import ARKit

class StereoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)

        // Constant for Retina Display iPads after iPad 3
        // 264 points per inch / 2 pixels per point / 2.54 cm per inch * 100 cm per meter
        let iPadPointsPerMeter = 5196.8503937008
        
        // Values for the Owl Stereoscopic Viewer -- To be Measured
        let owlDistBetweenEyes = 0.06 // Distance between the center of the lenses
        let owlEyeWidthInMeters = 0.066193939394 // Half of the width of the stereoscope box
        let owlEyeHeightInMeters = 0.06542424242
//        let owlDistanceFromEyeToScreen = 0.168 // 11.48 cm away from screen
        
        // Calculate Frame
        let owlEyeWidthInPoints = Int(owlEyeWidthInMeters * iPadPointsPerMeter) // 344
        let owlEyeHeightInPoints = Int(owlEyeHeightInMeters * iPadPointsPerMeter) // 340
        
        // Calculate Field of view -- Can't seem to change the right camera's FOV, and it's too laggy to run 3 cameras (left eye, right eye, and ARCamera)
        // So have to change your eye distance instead?
//        let owlFieldOfViewInRadians = atan(owlEyeWidthInMeters/owlDistanceFromEyeToScreen)
//        let owlFieldOfViewForOneEyeInDegrees = CGFloat(owlFieldOfViewInRadians) / CGFloat.pi * 180 // In degrees
//        // Technically, 43ish is the field of view, BUT the ARSCNView of the right eye is set to 60, so that means we should adjust the lens to fit the view then.
//        let owlFieldOfView: CGFloat = owlFieldOfViewForOneEyeInDegrees * 2 // 43
        
        // Create a scene with a ship inside
        let mainScene = SCNScene()
        let ship = nodeFromResource(assetName: "shipFolder/ship", extensionName: "scn")
        ship.position = SCNVector3(0, -0.2, -1.5)
        ship.scale = SCNVector3(0.2, 0.2, 0.2)
        mainScene.rootNode.addChildNode(ship)
        
        // Create an ARKit view for the right eye
        let rightARView = ARSCNView()
        rightARView.scene = mainScene
        rightARView.scene.background.contents = UIImage(named: "skymap")
        rightARView.showsStatistics = true
        rightARView.automaticallyUpdatesLighting = false
        rightARView.session.run(ARWorldTrackingConfiguration())
        // rightARView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        
        // Create a scene view for the left eye
        let leftView = SCNView()
        leftView.scene = rightARView.scene
        leftView.showsStatistics = true
        leftView.isPlaying = true
        
        // Display views for the left and right eye
        view.addSubview(leftView)
        view.addSubview(rightARView)
        let leftInset = 43
        leftView.frame = CGRect(
            x: leftInset, y: 0,
            width: owlEyeWidthInPoints, height: owlEyeHeightInPoints)
        rightARView.frame = CGRect(
            x: leftInset + owlEyeWidthInPoints, y: 0,
            width: owlEyeWidthInPoints, height: owlEyeHeightInPoints)
        
        // Get reference to the pointOfView and camera created by ARKit
        let rightEyePov = rightARView.pointOfView!
        let rightEyeCamera = rightEyePov.camera!

        // Make a camera for left eye
        let leftEyeCamera = SCNCamera()
        leftEyeCamera.zFar = rightEyeCamera.zFar
        leftEyeCamera.zNear = rightEyeCamera.zNear
        leftEyeCamera.fieldOfView = 50 //rightEyeCamera.fieldOfView
        leftEyeCamera.projectionDirection =  .horizontal// rightEyeCamera.projectionDirection

        // Create a node to hold the leftEyeCamera
        let leftCameraPov = SCNNode()
        leftCameraPov.camera = leftEyeCamera
        rightEyePov.addChildNode(leftCameraPov) // and add it to the rightEyeCamera
        // Move the leftEyeCamera a bit to the left of the rightEyeCamera
        leftCameraPov.position = SCNVector3(-owlDistBetweenEyes, 0, 0)
        leftView.pointOfView = leftCameraPov
    }
}
