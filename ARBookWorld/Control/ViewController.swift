//
//  ViewController.swift
//  ARBookWorld
//
//  Created by Mehmet Sahin on 2/16/19.
//  Copyright © 2019 Mehmet Sahin. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var navTitle = ""
    
    private var currentAngleY: Float = 0.0
    
    var trackedNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
        
        let rotate = UIRotationGestureRecognizer(target: self, action:     #selector(rotateNode(_:)))
        
        sceneView.addGestureRecognizer(rotate)
        
        navigationItem.title = navTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "History Cards", bundle: Bundle.main) {
            
            configuration.trackingImages = imageToTrack
            
            configuration.maximumNumberOfTrackedImages = 2
            
            print("Images Successfully Added")
            
            
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.eulerAngles.x = -.pi / 2
            
            node.addChildNode(planeNode)
            
            if imageAnchor.referenceImage.name == "triceratops-skull" {
                if let pokeScene = SCNScene(named: "art.scnassets/triceratops.scn") {

                    if let pokeNode = pokeScene.rootNode.childNodes.first {

                        //pokeNode.eulerAngles.x = .pi / 2
                        pokeNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/triceratops.jpeg")
                        planeNode.addChildNode(pokeNode)

                        trackedNode = planeNode
                        navTitle = "Triceratops Skull"
                    }
                }
            }
            
            if imageAnchor.referenceImage.name == "world" {
                if let pokeScene = SCNScene(named: "art.scnassets/earth.scn") {

                    if let pokeNode = pokeScene.rootNode.childNodes.first {
                        //pokeNode.geometry = SCNSphere(radius: 1)
                        pokeNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/world.jpg")
                        //pokeNode.eulerAngles.x = .pi / 2

                        planeNode.addChildNode(pokeNode)

                        trackedNode = planeNode
                        navTitle = "Earth"
                    }
                }
            }
            
            if imageAnchor.referenceImage.name == "dino" {
                if let pokeScene = SCNScene(named: "art.scnassets/dino.scn") {
                    
                    if let pokeNode = pokeScene.rootNode.childNodes.first {
                        
                        //pokeNode.eulerAngles.x = .pi / 2
                        
                        planeNode.addChildNode(pokeNode)
                        
                        trackedNode = planeNode
                        navTitle = "Dinozor"
                    }
                }
            }
            
            if imageAnchor.referenceImage.name == "heart" {
                if let pokeScene = SCNScene(named: "art.scnassets/Heart.scn") {
                    
                    if let pokeNode = pokeScene.rootNode.childNodes.first {
                        
                        //pokeNode.eulerAngles.x = .pi / 2
                        
                        planeNode.addChildNode(pokeNode)
                        
                        trackedNode = planeNode
                        navTitle = "Heart"
                    }
                }
            }
            
            if imageAnchor.referenceImage.name == "mammoth" {
                if let pokeScene = SCNScene(named: "art.scnassets/mammoth.scn") {
                    
                    if let pokeNode = pokeScene.rootNode.childNodes.first {
                        
                        //pokeNode.eulerAngles.x = .pi / 2
                        
                        planeNode.addChildNode(pokeNode)
                        
                        trackedNode = planeNode
                        navTitle = "Mammoth Skull"
                    }
                }
            }
            navigationItem.title = navTitle
        }
        return node
    }

    @objc func rotateNode(_ gesture: UIRotationGestureRecognizer){
        
        //1. Get The Current Rotation From The Gesture
        let rotation = Float(gesture.rotation)
        
        guard let tracked = trackedNode else { return }
        
        //2. If The Gesture State Has Changed Set The Nodes EulerAngles.y
        if gesture.state == .changed{
            
            tracked.eulerAngles.y = currentAngleY + rotation
        }
        
        //3. If The Gesture Has Ended Store The Last Angle Of The Cube
        if(gesture.state == .ended) {
            
            currentAngleY = tracked.eulerAngles.y
            
        }
    }
}
