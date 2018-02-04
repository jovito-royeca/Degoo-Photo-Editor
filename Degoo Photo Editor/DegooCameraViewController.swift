//
//  DegooCameraViewController.swift
//  Degoo Photo Editor
//
//  Created by Jovito Royeca on 02/02/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit
import PhotoEditorSDK

class DegooCameraViewController: CameraViewController {

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        customize()
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Custom methods
    
    func customize() {
        // handle photo selection from Photo Library
        completionBlock = { (_ image: UIImage?, url: URL?) in
            if let image = image {
                let photo = Photo(image: image)
                self.present(self.createPhotoEditViewController(with: photo), animated: true, completion: nil)
            }
        }
        
        // handle camera use
        dataCompletionBlock = { data in
            if let data = data {
                let photo = Photo(data: data)
                self.present(self.createPhotoEditViewController(with: photo), animated: true, completion: nil)
            }
        }
    }
    
    func createPhotoEditViewController(with photo: Photo) -> PhotoEditViewController {
        let configuration = Branding.buildConfiguration()
        var menuItems = PhotoEditMenuItem.defaultItems
        menuItems.removeLast() // Remove last menu item ('Magic')
        
        // Create a photo edit view controller
        let photoEditViewController = PhotoEditViewController(photoAsset: photo, configuration: configuration, menuItems: menuItems)
        photoEditViewController.toolbar.backgroundColor = degooBlue
        photoEditViewController.delegate = self
        
        return photoEditViewController
    }
}

// MARK: PhotoEditViewControllerDelegate
extension DegooCameraViewController {
    override func photoEditViewController(_ photoEditViewController: PhotoEditViewController, didSave image: UIImage, and data: Data) {
        dismiss(animated: true, completion: nil)
    }
    
    override func photoEditViewControllerDidFailToGeneratePhoto(_ photoEditViewController: PhotoEditViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func photoEditViewControllerDidCancel(_ photoEditViewController: PhotoEditViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

