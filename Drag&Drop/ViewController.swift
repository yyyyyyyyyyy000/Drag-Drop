//
//  ViewController.swift
//  Drag&Drop
//
//  Created by 无敌帅的yyyyy on 2019/1/25.
//  Copyright © 2019年 无敌帅的yyyy. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UIDropInteractionDelegate{

    @IBOutlet weak var Dropzone: UIView!
    
    
    @IBOutlet weak var emojiview: emojiView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Dropzone.addInteraction(UIDropInteraction(delegate: self))
    }

    var imagefetcher:ImageFetcher!
    
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        imagefetcher = ImageFetcher(handler: {(url,image) in
            DispatchQueue.main.async {
                self.emojiview.backgroundimage  = image
            }
            
        })
        session.loadObjects(ofClass: NSURL.self, completion: {urls in
            self.imagefetcher.fetch(urls.first as! URL)
        })
        session.loadObjects(ofClass: UIImage.self, completion: {images in
            self.imagefetcher.backup = images.first as? UIImage
        })
    }

}

