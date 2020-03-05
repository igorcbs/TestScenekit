//
//  TesteVC.swift
//  SceneTestKit
//
//  Created by Igor de Castro on 02/03/20.
//  Copyright © 2020 Igor de Castro. All rights reserved.
//

import Foundation
import SceneKit

class TesteViewControler: UIViewController, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    
    let scene = SCNScene(named: "art.scnassets/ship.scn")!
    var box = SCNBox()
    let camera = SCNCamera()
    let cameraNode = SCNNode()
    let lightNode = SCNNode()
    let lightAmbient = SCNNode()
    let sceneBox = SCNScene()
    let floor = SCNNode()
    var ship = SCNNode()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
//        ship.position.z = -30.0
//        ship.eulerAngles.z = Float(.pi / 6.0)

        camera.usesOrthographicProjection = true
        camera.orthographicScale = 15.0
//        print(camera.orthographicScale)
        
        cameraNode.camera = camera
        
//        cameraNode.position = SCNVector3(x: 0.0, y: 0.0, z: 0.0)
//        cameraNode.position.x = 20.0
        cameraNode.position.z = 80.0
//        cameraNode.eulerAngles.x = -Float(Double.pi / 4)
        scene.rootNode.addChildNode(cameraNode)
        
        
//        scene.rootNode.addChildNode(<#T##child: SCNNode##SCNNode#>)
        
//        setCamera()
//        setLight()
//        setBox()
//        setFloor()
//        physics()
//        setGravity()
        let sceneView = self.view as! SCNView
        sceneView.scene = scene
//        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = UIColor.black
        sceneView.showsStatistics = true
        sceneView.delegate = self
        sceneView.isPlaying = true
        sceneView.scene?.physicsWorld.contactDelegate = self
//        sceneView.scene?.physicsWorld.gravity = SCNVector3(0, 0, -9.8)
        sceneView.debugOptions = [.showPhysicsShapes]
        
    }
    
    
    func setLight() {
        //light
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(0, 10, 10)
        scene.rootNode.addChildNode(lightNode)
        
        //Light Ambient
        lightAmbient.light = SCNLight()
        lightAmbient.light!.type = .ambient
        lightAmbient.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(lightAmbient)
    
    }
    
//    func setCamera(){
//        let distantConstraint = SCNDistanceConstraint(target: ship)
//        distantConstraint.maximumDistance = 60
//        distantConstraint.minimumDistance = 55
//
//        let lookAtConstraint = SCNLookAtConstraint(target: ship)
//        lookAtConstraint.isGimbalLockEnabled = true
//        camera.constraints = [lookAtConstraint, distantConstraint]
//        camera.camera = SCNCamera()
////        camera.position = SCNVector3(0, 0, 15)
//        ship.addChildNode(camera)
//
//    }
    
    func setBox(){
        let boxNode = SCNNode()
        box = SCNBox(width: 5, height: 5, length: 2, chamferRadius: 1)
        boxNode.geometry = box
        boxNode.position = SCNVector3(0, 4, -4)
        scene.rootNode.addChildNode(boxNode)
    }
    
    func setFloor() {
        let floorScn = SCNFloor()
        floorScn.reflectivity = 0.3
        floorScn.reflectionFalloffEnd = 3.0
        floorScn.reflectionFalloffStart = 0.0
        floorScn.reflectionResolutionScaleFactor = 0.0
        floorScn.firstMaterial?.diffuse.contents = UIColor.brown
        floor.geometry = floorScn
//        floor.geometry?.firstMaterial!.colorBufferWriteMask = []
//        floor.geometry?.firstMaterial!.readsFromDepthBuffer = true
//        floor.geometry?.firstMaterial!.writesToDepthBuffer = true
//        floor.geometry?.firstMaterial!.lightingModel = .constant
        floor.position = SCNVector3(0, -10, 0)
        
        
        let shape2 = SCNPhysicsShape(geometry: floor.geometry!, options: nil)
        floor.physicsBody = SCNPhysicsBody(type: .static, shape: shape2)
        floor.physicsBody?.collisionBitMask = 2
        floor.physicsBody?.contactTestBitMask = 2
        floor.physicsBody?.categoryBitMask = 1
        scene.rootNode.addChildNode(floor)
        
        let lightFloor = SCNNode()
        lightFloor.light = SCNLight()
        lightFloor.light?.type = .directional
        lightFloor.light?.shadowMode = SCNShadowMode(rawValue: 5)!
        lightFloor.light?.shadowColor = UIColor.black
        lightFloor.light?.color = UIColor.white
        lightFloor.light?.castsShadow = true
        lightFloor.light?.automaticallyAdjustsShadowProjection = true
        lightFloor.light?.shadowMode = .deferred
        lightFloor.position = SCNVector3(1, 1, 0)
        lightFloor.rotation = SCNVector4(1, 0, 0, .pi * 1.5)
        scene.rootNode.addChildNode(lightFloor)
        
        
    }
    
    func setPhysics() {
       

    }
    
    func setGravity() {
        //ship.physicsBody?.damping = 1.0
        //ship.physicsBody?.velocityFactor = SCNVector3Zero
        scene.physicsWorld.gravity = SCNVector3(.zero, -2, .zero)
//        ship.physicsField = .linearGravity()
        
    }
}
// MARK: - Physics
extension TesteViewControler{
    
    func physics(){
        let min = ship.boundingBox.min
        let max = ship.boundingBox.max

        
        let w = Float(max.x - min.x)
        let h = Float(max.y - min.y)
        let l = Float(max.z - min.z)

//        let geometry = SCNGeometry()
//        let bitMaskCollision = 1 << 2
//        let shape = SCNPhysicsShape(geometry: geometry, options: nil)
        ship.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.dynamic, shape: SCNPhysicsShape(geometry: SCNBox(width: CGFloat(w), height: CGFloat(h), length: CGFloat(l), chamferRadius: 0.0) , options:  [SCNPhysicsShape.Option.scale: ship.scale]))
        ship.physicsBody?.categoryBitMask = 2
        ship.physicsBody?.collisionBitMask = 1
        ship.physicsBody?.contactTestBitMask = 1
    }
    
}
