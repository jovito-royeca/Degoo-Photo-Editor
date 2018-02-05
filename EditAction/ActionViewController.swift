//
//  ActionViewController.swift
//  EditAction
//
//  Created by Jovito Royeca on 05/02/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit
import MobileCoreServices
import PhotoEditorSDK

class ActionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // unlock Photo Editor with license
        if let licenseURL = Bundle.main.url(forResource: "ios_license", withExtension: "") {
            PESDK.unlockWithLicense(at: licenseURL)
            print("PESDK success!")
        }
        
        // Get the item[s] we're handling from the extension context.
        
        // For example, look for an image and place it into an image view.
        // Replace this with something appropriate for the type[s] your extension supports.
        var imageFound = false
        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! as! [NSItemProvider] {
                if provider.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
                    // This is an image. We'll load it, then place it in our image view.
                    
                    provider.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil, completionHandler: { (data, error) in
                        OperationQueue.main.addOperation {
                            var contentData: Data? = nil
                            
                            if let data = data as? Data {
                                contentData = data
                            } else if let url = data as? URL {
                                contentData = try? Data(contentsOf: url)
                            }else if let imageData = data as? UIImage {
                                contentData = UIImagePNGRepresentation(imageData)
                            }
                            if let contentData = contentData{
                                let photo = Photo(data: contentData)
                                self.presentPhotoEditorController(photoAsset: photo)
                            }
                        }
                    })
                    
                    imageFound = true
                    break
                }
            }
            
            if (imageFound) {
                // We only handle one image, so stop looking for more.
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Custom methods
    func presentPhotoEditorController(photoAsset: Photo) {
        let configuration = Branding.buildConfiguration()
        let photoEditViewController = PhotoEditViewController(photoAsset: photoAsset, configuration: configuration)
        photoEditViewController.delegate = self
        photoEditViewController.toolbar.backgroundColor = degooToolbarBlue
        
        present(photoEditViewController, animated: false, completion: nil)
    }
}

// MARK: PhotoEditViewControllerDelegate
extension ActionViewController: PhotoEditViewControllerDelegate {
    func photoEditViewController(_ photoEditViewController: PhotoEditViewController, didSave image: UIImage, and data: Data) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        if let extensionContext = extensionContext {
            extensionContext.completeRequest(returningItems: extensionContext.inputItems, completionHandler: nil)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func photoEditViewControllerDidFailToGeneratePhoto(_ photoEditViewController: PhotoEditViewController) {
        // Return any edited content to the host app.
        if let extensionContext = extensionContext {
            extensionContext.completeRequest(returningItems: extensionContext.inputItems, completionHandler: nil)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func photoEditViewControllerDidCancel(_ photoEditViewController: PhotoEditViewController) {
        // Return any edited content to the host app.
        if let extensionContext = extensionContext {
            extensionContext.completeRequest(returningItems: extensionContext.inputItems, completionHandler: nil)
        }
        dismiss(animated: true, completion: nil)
    }
}
