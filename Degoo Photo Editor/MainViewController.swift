//
//  MainViewController.swift
//  Degoo Photo Editor
//
//  Created by Jovito Royeca on 05/02/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit
import PhotoEditorSDK

class MainViewController: UIViewController {

    // MARK: Variables
    var cameraViewController:CameraViewController?
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        if cameraViewController == nil {
            cameraViewController = createCameraViewController()
        }
        
        present(cameraViewController!, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Custom methods
    func createCameraViewController() -> CameraViewController {
        let configuration = Branding.buildConfiguration()
        let cvc = CameraViewController(configuration: configuration)
        
        // handle photo selection from Photo Library
        cvc.completionBlock = { (_ image: UIImage?, url: URL?) in
            if let image = image {
                let photo = Photo(image: image)
                let photoEditorViewController = self.createPhotoEditViewController(with: photo)
                
                cvc.present(photoEditorViewController, animated: true, completion: nil)
            }
        }
        
        // handle camera use
        cvc.dataCompletionBlock = { data in
            if let data = data {
                let photo = Photo(data: data)
                let photoEditorViewController = self.createPhotoEditViewController(with: photo)
                
                cvc.present(photoEditorViewController, animated: true, completion: nil)
            }
        }
        
        return cvc
    }
    
    func createPhotoEditViewController(with photo: Photo) -> PhotoEditViewController {
        let configuration = Branding.buildConfiguration()
        let menuItems = PhotoEditMenuItem.defaultItems
        
        // Create a photo edit view controller
        let photoEditViewController = PhotoEditViewController(photoAsset: photo, configuration: configuration, menuItems: menuItems)
        photoEditViewController.toolbar.backgroundColor = degooToolbarBlue
        photoEditViewController.delegate = self
        
        return photoEditViewController
    }
}

// MARK: PhotoEditViewControllerDelegate
extension MainViewController: PhotoEditViewControllerDelegate {
    func photoEditViewController(_ photoEditViewController: PhotoEditViewController, didSave image: UIImage, and data: Data) {
        // save the image to Photo Library
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }
    
    func photoEditViewControllerDidFailToGeneratePhoto(_ photoEditViewController: PhotoEditViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func photoEditViewControllerDidCancel(_ photoEditViewController: PhotoEditViewController) {
        dismiss(animated: true, completion: nil)
    }
}
