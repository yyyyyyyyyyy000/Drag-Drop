//
//  ViewController.swift
//  Drag&Drop
//
//  Created by 无敌帅的yyyyy on 2019/1/25.
//  Copyright © 2019年 无敌帅的yyyy. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UIDropInteractionDelegate,UIScrollViewDelegate{

    @IBOutlet weak var Dropzone: UIView!
    
    
    var emojiview = emojiView()
    
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var width: NSLayoutConstraint!
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        height.constant = scrollView.contentSize.height
        width.constant = scrollView.contentSize.width
    }
    
    
    
    @IBOutlet weak var scrollview: UIScrollView!{
        didSet{
            scrollview.maximumZoomScale = 8
            scrollview.minimumZoomScale = 1/25
            scrollview.delegate = self
            scrollview.addSubview(emojiview)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return emojiview
    }
    private var backimage:UIImage?{
        set{
            scrollview?.zoomScale = 1
            emojiview.backgroundimage = newValue
            let size = newValue?.size ?? CGSize.zero
            height?.constant = size.height
            width?.constant = size.width
            emojiview.frame = CGRect(origin: CGPoint.zero, size: size)
            if let dropzone = self.Dropzone, size.width>0, size.height>0{
                scrollview?.zoomScale = max(dropzone.bounds.size.width/size.width,dropzone.bounds.size.height/size.height)
            }
        }
        get{
            return emojiview.backgroundimage
        }
    }
    
    
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
                self.backimage  = image
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

