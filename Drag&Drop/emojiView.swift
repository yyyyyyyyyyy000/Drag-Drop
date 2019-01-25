//
//  emojiView.swift
//  Drag&Drop
//
//  Created by 无敌帅的yyyyy on 2019/1/25.
//  Copyright © 2019年 无敌帅的yyyy. All rights reserved.
//

import UIKit

class emojiView: UIView {
    var backgroundimage:UIImage?{
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        backgroundimage?.draw(in: bounds)
    }
    

}
