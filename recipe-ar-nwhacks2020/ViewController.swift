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
    var listOfIngredients : [String] = []
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var recipeTableView: UITableView!
    
    @IBOutlet weak var ingredientsUIStackView: UIStackView!
    
    @IBOutlet weak var IngredientsMenuBtn: UIButton!
    
    @IBOutlet weak var RecipeListBtn: UIButton!
    
    @IBOutlet weak var ClearBtn: UIButton!
    
    @IBAction func recipeTableClickBtn(_ sender: Any) {
        if recipeTableView.isHidden {
            dispatchQueue.async {
                let headers = ["content-type": "application/json"]
                
                // TODO: add the list of ingredeitns to the parameters
                let listOfIngredientsGraphQLString = self.convertListOfIngredientsToGraphQLString(listOfIngredients: self.listOfIngredients)
                print(listOfIngredientsGraphQLString)
                let parameters = ["query": "query { recipes(names: \(listOfIngredientsGraphQLString)) { name source instructions ingredients { edges { node { name } } } } }"] as [String : Any]
                
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
                            print("yay")
                            var responseString = String(data: data!, encoding: .utf8)!
                            print("responseString = \(responseString)")
                            /*
                             responseString = {"data":{"recipes":[{"name":"Khoresht Karafs","source":"/images/khoresht-karafs.png","instructions":"Wash the mint and parsley and make sure they are *completely dry*. A salad spinner helps, if you don\u2019t have one you can use paper towels., Finely chop the mint and parsley, then saut\u00e9 until just starting to turn crispy. Set aside., Saut\u00e9 the onion with enough butter or oil until golden, Add the garlic and saut\u00e9 for 1-2 more minutes, Add the turmeric and saut\u00e9 for 2 more minutes, Add the beef cubes and saut\u00e9 until browned on the outside, Pour in the beef stock and saut\u00e9ed mint and parsley and simmer, In a separate pan, saut\u00e9 the celery until *just* starting to turn brown. Set aside., After the stew has been simmering for 1.5 hour, pour in the saut\u00e9ed celery and simmer for another 30 minutes. This is done so that the celery doesn\u2019t become too mushy., Finish with the lemon juice and serve., ","ingredients":{"edges":[{"node":{"name":"large yellow onion"}},{"node":{"name":"garlic"}},{"node":{"name":"parsley"}},{"node":{"name":"fresh mint"}},{"node":{"name":"stew beef"}},{"node":{"name":"celery"}},{"node":{"name":"ground turmeric"}},{"node":{"name":"beef stock"}},{"node":{"name":"lemon"}},{"node":{"name":"butter or oil"}}]}}]}}
                
                             */
                            
                            let recipeJSONDict = try? JSONDecoder().decode(JSONRecipeList.self, from: responseString.data(using: .utf8)!)
                            
                            if recipeJSONDict != nil {
                                var recipeListJSONObj = recipeJSONDict!
                                print(recipeListJSONObj)
                                print(recipeListJSONObj.data)
                                print(recipeListJSONObj.data.recipes)
                                
                                if recipeListJSONObj.data.recipes.count <= 0 {
                                    return
                                }
                                
                                print(recipeListJSONObj.data.recipes[0].name)
                                print(recipeListJSONObj.data.recipes[0].source)
                                print(recipeListJSONObj.data.recipes[0].ingredients.edges[0])
                                print(recipeListJSONObj.data.recipes[0].ingredients.edges[0].node)
                                print(recipeListJSONObj.data.recipes[0].ingredients.edges[0].node.name)
                                
                                
                                /*
                                 JSONRecipeList(data: recipe_ar_nwhacks2020.ViewController.JSONRecipeData(recipes: [recipe_ar_nwhacks2020.ViewController.Recipe(name: "Khoresht Karafs", source: "/images/khoresht-karafs.png", instructions: "Wash the mint and parsley and make sure they are *completely dry*. A salad spinner helps, if you don’t have one you can use paper towels., Finely chop the mint and parsley, then sauté until just starting to turn crispy. Set aside., Sauté the onion with enough butter or oil until golden, Add the garlic and sauté for 1-2 more minutes, Add the turmeric and sauté for 2 more minutes, Add the beef cubes and sauté until browned on the outside, Pour in the beef stock and sautéed mint and parsley and simmer, In a separate pan, sauté the celery until *just* starting to turn brown. Set aside., After the stew has been simmering for 1.5 hour, pour in the sautéed celery and simmer for another 30 minutes. This is done so that the celery doesn’t become too mushy., Finish with the lemon juice and serve., ", ingredients: recipe_ar_nwhacks2020.ViewController.Ingredients(edges: [recipe_ar_nwhacks2020.ViewController.Edge(node: recipe_ar_nwhacks2020.ViewController.Node(name: "large yellow onion")), recipe_ar_nwhacks2020.ViewController.Edge(node: recipe_ar_nwhacks2020.ViewController.Node(name: "garlic")), recipe_ar_nwhacks2020.ViewController.Edge(node: recipe_ar_nwhacks2020.ViewController.Node(name: "parsley")), recipe_ar_nwhacks2020.ViewController.Edge(node: recipe_ar_nwhacks2020.ViewController.Node(name: "fresh mint")), recipe_ar_nwhacks2020.ViewController.Edge(node: recipe_ar_nwhacks2020.ViewController.Node(name: "stew beef")), recipe_ar_nwhacks2020.ViewController.Edge(node: recipe_ar_nwhacks2020.ViewController.Node(name: "celery")), recipe_ar_nwhacks2020.ViewController.Edge(node: recipe_ar_nwhacks2020.ViewController.Node(name: "ground turmeric")), recipe_ar_nwhacks2020.ViewController.Edge(node: recipe_ar_nwhacks2020.ViewController.Node(name: "beef stock")), recipe_ar_nwhacks2020.ViewController.Edge(node: recipe_ar_nwhacks2020.ViewController.Node(name: "lemon")), recipe_ar_nwhacks2020.ViewController.Edge(node: recipe_ar_nwhacks2020.ViewController.Node(name: "butter or oil"))]))]))
                                 */
                            }
                        }
                    })
                    dataTask.resume()
                } catch {
                    print("Error fetching recipe list")
                }
                    
            }
        } else {
            // recipe table is not hidden
        }
        
        recipeTableView.isHidden = !recipeTableView.isHidden
    }
    
    @IBAction func clearBtnClick(_ sender: Any) {
        listOfIngredients.removeAll()
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in node.removeFromParentNode() }
    }
    
    @IBAction func ingredientsBtnClick(_ sender: Any) {6
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
        
        // style buttons
        IngredientsMenuBtn.setTitleColor(.white, for: .normal)
        IngredientsMenuBtn.layer.cornerRadius = 5
        RecipeListBtn.setTitleColor(.white, for: .normal)
        RecipeListBtn.layer.cornerRadius = 5
        ClearBtn.setTitleColor(.white, for: .normal)
        ClearBtn.layer.cornerRadius = 5
        
        
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
            var base64EncodedImage : String = (self.resize(self.sceneView.snapshot()).pngData()?.base64EncodedString())!

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
                    let responseString = String(data: data!, encoding: .utf8)!
                    //print("responseString = \(responseString)")
                    
//                    let responseJSONDict = self.convertToDictionary(text: responseString)
                    
                    let responseJSONDict = try? JSONDecoder().decode(JSONResponseData.self, from: responseString.data(using: .utf8)!)
                    
                    let responseDetails = responseJSONDict?.data.analyzeImage.name
                    print(responseDetails)
                    
                    if responseDetails != nil {
                        print(responseDetails!)
                        
                        let responseStrArr = responseDetails!.components(separatedBy: ",")
                        let nameOfIngredient = responseStrArr[0].components(separatedBy: "=")[1]
                        let confidenceLevel = responseStrArr[1].components(separatedBy: "=")[1]
                        let caption = responseStrArr[2].components(separatedBy: "=")[1]
                        
                        DispatchQueue.main.async {
                            let screenCentre : CGPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)

                            let arHitTestResults : [ARHitTestResult] = self.sceneView.hitTest(screenCentre, types: [.featurePoint]) // Alternatively, we could use '.existingPlaneUsingExtent' for more grounded hit-test-points.

                            if let closestResult = arHitTestResults.first {
                                // Get Coordinates of HitTest
                                let transform : matrix_float4x4 = closestResult.worldTransform
                                let worldCoord : SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)

                                // Create 3D Text
                                let node : SCNNode = self.createNewBubbleParentNode("\(caption). Confidence: \(confidenceLevel)")
                                self.sceneView.scene.rootNode.addChildNode(node)
                                node.position = worldCoord
                                
                                if nameOfIngredient.lowercased() != "Not an ingredient".lowercased() {
                                    self.listOfIngredients.append(nameOfIngredient)
                                }
                            }
                        }
                    }
                 }
                })

                dataTask.resume()
            } catch {
                print("ERRORRRRRRRRRRR")
            }
        }
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
    
    // MARK: - Utility functions
    
    func resize(_ image: UIImage) -> UIImage {
        var actualHeight = Float(image.size.height)
        var actualWidth = Float(image.size.width)
        let maxHeight: Float = 300.0
        let maxWidth: Float = 400.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 0.5
        //50 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img?.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!) ?? UIImage()
    }
    
//    func convertToDictionary(text: String) -> [String: Any]? {
//        if let data = text.data(using: .utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        return nil
//    }
    
    func convertListOfIngredientsToGraphQLString(listOfIngredients : [String]) -> String {
        // Ex. list of ingredients to this string : [\"salt\", \"eggs\"]
        var graphQLString = "["
        
        for (index, element) in listOfIngredients.enumerated() {
            graphQLString.append("\"\(element)\"")
            
            // if not last element
            if index < (self.listOfIngredients.count - 1) {
                graphQLString.append(", ")
            }
        }
        
        graphQLString.append("]")
        return graphQLString
    }
    
    // MARK: - JSONResponseData
    struct JSONResponseData: Codable {
        let data: DataClass
    }

    // MARK: - DataClass
    struct DataClass: Codable {
        let analyzeImage: AnalyzeImage
    }

    // MARK: - AnalyzeImage
    struct AnalyzeImage: Codable {
        let name: String
    }
    
    // MARK: - JSONRecipeList
    struct JSONRecipeList: Codable {
        let data: JSONRecipeData
    }

    // MARK: - DataClass
    struct JSONRecipeData: Codable {
        let recipes: [Recipe]
    }

    // MARK: - Recipe
    struct Recipe: Codable {
        let name: String
        let source: String
        let instructions: String
        let ingredients: Ingredients
    }

    // MARK: - Ingredients
    struct Ingredients: Codable {
        let edges: [Edge]
    }

    // MARK: - Edge
    struct Edge: Codable {
        let node: Node
    }

    // MARK: - Node
    struct Node: Codable {
        let name: String
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
