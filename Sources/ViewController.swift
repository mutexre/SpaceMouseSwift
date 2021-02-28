//
//  GameViewController.swift
//  3D Mouse Test Host
//
//  Created by Alexander Obuschenko on 21/10/2018.
//  Copyright © 2018 mutexre. All rights reserved.
//

import SceneKit
import QuartzCore

class ViewController: NSViewController
{
    private var node: SCNNode!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = NSColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        node = scene.rootNode.childNode(withName: "ship", recursively: true)!
        node.pivot = SCNMatrix4MakeRotation(.pi, 0, 1, 0)
        
        let scnView = self.view as! SCNView
        scnView.scene = scene
        scnView.allowsCameraControl = false
        scnView.showsStatistics = false
        scnView.backgroundColor = NSColor.black
        
        Mouse.shared()?.delegate = self
    }
}

extension ViewController: MouseDelegate
{
    func mouse(_ mouse: Mouse!, didReceiveTx tx: Float, ty: Float, tz: Float, rx: Float, ry: Float, rz: Float)
    {
//        print("\(tx) \(ty) \(tz) \(rx) \(ry) \(rz)")
//        node.eulerAngles = SCNVector3Make(CGFloat(rx), -CGFloat(rz), CGFloat(ry))
        
        let s: CGFloat = 0.1

        node.eulerAngles.x += s * CGFloat(rx)
        node.eulerAngles.y -= s * CGFloat(rz)
        node.eulerAngles.z += s * CGFloat(ry)
        
//        let rotX = SCNMatrix4MakeRotation(s * CGFloat(rx), 1, 0, 0)
//        let rotY = SCNMatrix4MakeRotation(-s * CGFloat(rz), 0, 1, 0)
//        let rotZ = SCNMatrix4MakeRotation(s * CGFloat(ry), 0, 0, 1)
//        node.transform = SCNMatrix4Mult(rotZ, SCNMatrix4Mult(rotY, SCNMatrix4Mult(rotX, node.transform)))
    }
}
