//
//  GameViewController.swift
//  SimpleScene
//
//  Created by TSD040 on 2018-03-31.
//  Copyright © 2018 Paige Sun. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene()
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        // ******************************************************

        let ship = nodeFromResource(assetName: "shipFolder/ship", extensionName: "scn")
        scene.rootNode.addChildNode(ship)

        let stonesTreasureRoot = nodeFromResource(assetName: "stones_and_treasure", extensionName: "dae")
        let treeNode = stonesTreasureRoot.childNode(withName: "Tree_Fir", recursively: true)!
        treeNode.position = SCNVector3Make(1, 1, 1)
        scene.rootNode.addChildNode(treeNode)
        
        let potionsRoot = nodeFromResource(assetName: "potions/vzor", extensionName: "dae")
        let potion = potionsRoot.childNode(withName: "small_health_poti_purple", recursively: true)!
        potion.position = SCNVector3Make(1, 1, 1)
        scene.rootNode.addChildNode(potion)
        
        let bluePotion = potionsRoot.childNode(withName: "small_health_poti_blue", recursively: true)!
        bluePotion.position = SCNVector3Make(2, 1, 1)
        scene.rootNode.addChildNode(bluePotion)
        
// TODO figure out how to import obj
//        let url = Bundle.main.url(forResource: "art.scnassets/Sting-Sword", withExtension: "obj")!
////        let path = bundle.pathForResource("Sting-Sword", ofType: "obj")
////        let url = NSURL(fileURLWithPath: path!)
//        let asset: MDLObject = MDLAsset(url: url).object(at: 0)
//        print(asset)
////        scene.rootNode.addChildNode(swordNode)
        // ******************************************************
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}


func nodeFromResource(assetName: String, extensionName: String) -> SCNNode {
    let url = Bundle.main.url(forResource: "art.scnassets/\(assetName)", withExtension: extensionName)!
    let node = SCNReferenceNode(url: url)!
    
    node.name = assetName
    node.load()
    return node
}

