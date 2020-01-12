//
//  ViewController.swift
//  recipe-ar-nwhacks2020
//
//  Created by Winson Wong on 2020-01-11.
//  Copyright © 2020 Winson Wong. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, UITableViewDelegate, UITableViewDataSource {
    let bubbleDepth : Float = 0.01 // the 'depth' of 3D text
    var latestPrediction : String = "testing123"
    let dispatchQueue = DispatchQueue(label: "testing.recipe-ar-nwhacks2020")
    
    var isIngredientsMenuOn : Bool = false;
    var listOfIngredients : [String] = ["Ingredient 1", "Ingredient 2", "Ingredient 3"]
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var recipeTableView: UITableView!
    
    @IBOutlet weak var ingredientsUIStackView: UIStackView!
    
    @IBAction func recipeTableClickBtn(_ sender: Any) {
        recipeTableView.isHidden = !recipeTableView.isHidden
    }
    
    @IBAction func clearBtnClick(_ sender: Any) {
    sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in node.removeFromParentNode() }
    }
    
    @IBAction func ingredientsBtnClick(_ sender: Any) {
        if isIngredientsMenuOn {
            // remove subview ingredients from the stack menu
            ingredientsUIStackView.subviews.forEach({$0.removeFromSuperview()})
        } else {
            // menu is off
            ingredientsUIStackView.distribution = .fillEqually
            ingredientsUIStackView.spacing = 10
            
            for i in listOfIngredients {
                let button = IngredientsBtn()
                button.setTitle("\(i)", for: .normal)
                ingredientsUIStackView.addArrangedSubview(button)
            }
        }
        
        // toggle
        isIngredientsMenuOn = !isIngredientsMenuOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        
        // Tap action
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gestureRecognize:)))
        view.addGestureRecognizer(tapGesture)
        
        // Add view for ingredients UI stack
        view.addSubview(ingredientsUIStackView)
        
        // Recipe table
        recipeTableView.isHidden = true
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - Interactions
    @objc func handleTap(gestureRecognize: UITapGestureRecognizer) {
            // take a screenshot
        dispatchQueue.async {
            var base64EncodedImage : String? = self.sceneView.snapshot().pngData()?.base64EncodedString()
            
        //        let url = URL(string: "https://nwhacksripear.azurewebsites.net/graphql")!
        //        var request = URLRequest(url: url)
        //
        //        // TODO: set the appropriate values
        //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        request.httpMethod = "POST"
        //        request.HTTPBODY = "{ 'mutation': '{ analyzeImage(Input:'') { name } }' }"
        //
            let headers = ["content-type": "application/json"]
            let parameters = ["query": "mutation { analyzeImage(input: \"\(base64EncodedImage)\") { name  } }"] as [String : Any]
            
            do {
                let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])

                let request = NSMutableURLRequest(url: NSURL(string: "https://nwhacksripear.azurewebsites.net/graphql")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
                request.httpMethod = "POST"
                request.allHTTPHeaderFields = headers
                request.httpBody = postData as Data

                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
        //                let httpResponse = response as? HTTPURLResponse
        //                print(httpResponse)
                    
                    // Response has returned
                    let responseString = String(data: data!, encoding: .utf8)
                    print("responseString = \(responseString)")
                    
                    //            let screenCentre : CGPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
                    //
                    //            let arHitTestResults : [ARHitTestResult] = self.sceneView.hitTest(screenCentre, types: [.featurePoint]) // Alternatively, we could use '.existingPlaneUsingExtent' for more grounded hit-test-points.
                    //
                    //                   if let closestResult = arHitTestResults.first {
                    //                       // Get Coordinates of HitTest
                    //                       let transform : matrix_float4x4 = closestResult.worldTransform
                    //                       let worldCoord : SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
                    //
                    //                       // Create 3D Text
                    //                    let node : SCNNode = self.createNewBubbleParentNode(self.latestPrediction)
                    //                    self.sceneView.scene.rootNode.addChildNode(node)
                    //                       node.position = worldCoord
                    //                   }
                    
                 }
                })

                dataTask.resume()
            } catch {
                print("ERRORRRRRRRRRRR")
            }
        }
       
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data,
//                let response = response as? HTTPURLResponse,
//                error == nil else {                                              // check for fundamental networking error
//                print("error", error ?? "Unknown error")
//                return
//            }
//
//            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
//                print("statusCode should be 2xx, but is \(response.statusCode)")
//                print("response = \(response)")
//                return
//            }
//
//            // Response has returned
//            let responseString = String(data: data, encoding: .utf8)
//            print("responseString = \(responseString)")
//
//            let screenCentre : CGPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
//
//            let arHitTestResults : [ARHitTestResult] = self.sceneView.hitTest(screenCentre, types: [.featurePoint]) // Alternatively, we could use '.existingPlaneUsingExtent' for more grounded hit-test-points.
//
//                   if let closestResult = arHitTestResults.first {
//                       // Get Coordinates of HitTest
//                       let transform : matrix_float4x4 = closestResult.worldTransform
//                       let worldCoord : SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
//
//                       // Create 3D Text
//                    let node : SCNNode = self.createNewBubbleParentNode(self.latestPrediction)
//                    self.sceneView.scene.rootNode.addChildNode(node)
//                       node.position = worldCoord
//                   }
//        }
//
//        task.resume()
    }
    
    func createNewBubbleParentNode(_ text : String) -> SCNNode {

        // TEXT BILLBOARD CONSTRAINT
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y

        // BUBBLE-TEXT
        let bubble = SCNText(string: text, extrusionDepth: CGFloat(bubbleDepth))
        var font = UIFont(name: "Futura", size: 0.15)
        bubble.font = font

        bubble.firstMaterial?.diffuse.contents = UIColor.orange
        bubble.firstMaterial?.specular.contents = UIColor.white
        bubble.firstMaterial?.isDoubleSided = true
        // bubble.flatness // setting this too low can cause crashes.
        bubble.chamferRadius = CGFloat(bubbleDepth)

        // BUBBLE NODE
        let (minBound, maxBound) = bubble.boundingBox
        let bubbleNode = SCNNode(geometry: bubble)
        // Centre Node - to Centre-Bottom point
        bubbleNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, bubbleDepth/2)
        // Reduce default text size
        bubbleNode.scale = SCNVector3Make(0.2, 0.2, 0.2)

        // CENTRE POINT NODE
        let sphere = SCNSphere(radius: 0.005)
        sphere.firstMaterial?.diffuse.contents = UIColor.cyan
        let sphereNode = SCNNode(geometry: sphere)

        // BUBBLE PARENT NODE
        let bubbleNodeParent = SCNNode()
        bubbleNodeParent.addChildNode(bubbleNode)
        bubbleNodeParent.addChildNode(sphereNode)
        bubbleNodeParent.constraints = [billboardConstraint]

        return bubbleNodeParent
    }
    
    // MARK: - Recipe Table View protocols
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 0
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
       }
       

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
