//
//  ViewController.swift
//  SeeFood
//
//  Created by Clovis Magenta da Cunha on 14/01/19.
//  Copyright © 2019 CMC. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = imagePicked
            
            guard let ciimage = CIImage(image: imagePicked) else {
                fatalError("Could not convert to CIImage")
            }

            detect(image: ciimage)

        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect( image : CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError( "Error on use MLModel.")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Problems to get request result on VNCore")
            }
            if let firstResult = results.first {
                print(firstResult)
                if firstResult.identifier.contains("keyboard") {
                    self.navigationItem.title = "KeyBoard! :)"
                } else {
                    self.navigationItem.title = "Not a keyboard! :("
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try! handler.perform([request])
        } catch {
            print(error)
        }
        
        
        
    }
}

