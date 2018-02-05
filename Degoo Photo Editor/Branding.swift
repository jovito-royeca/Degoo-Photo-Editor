//
//  Branding.swift
//  Degoo Photo Editor
//
//  Created by Jovito Royeca on 05/02/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit
import PhotoEditorSDK

let degooMenuBlue = UIColor(red:0.10, green:0.46, blue:0.72, alpha:1.0)
let degooToolbarBlue = UIColor(red:0.07, green:0.36, blue:0.63, alpha:1.0)

class Branding: NSObject {
    

    class func buildConfiguration() -> Configuration {
        let configuration = Configuration() { builder in
            // Configure the colors
            builder.menuBackgroundColor = degooMenuBlue
            
            // Configure camera
            builder.configureCameraViewController() { options in
                // Just enable Photos
                options.allowedRecordingModes = [.photo]
                options.backgroundColor = degooMenuBlue
                
                options.photoActionButtonConfigurationClosure = { button in
                    button.tintColor = UIColor.white
                }
                options.flashButtonConfigurationClosure = {button in
                    button.tintColor = UIColor.white
                }
                options.switchCameraButtonConfigurationClosure = {button in
                    button.tintColor = UIColor.white
                }
                options.filterSelectorButtonConfigurationClosure = {button in
                    button.tintColor = UIColor.white
                }
            }
            
            // Configure photo editor
            builder.configurePhotoEditorViewController() { options in
                options.backgroundColor = UIColor.black
            }
        }
        
        return configuration
    }
}
