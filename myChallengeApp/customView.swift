//
//  customView.swift
//  myChallengeApp
//
//  Created by 정민경 on 2022/11/08.
//

import Foundation
import UIKit

@IBDesignable
class CustomView : UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .clear {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable
    var hasShadow : Bool = false {
        didSet{
            if hasShadow {
                layer.applyShadow()
            }
        }
    }
    
}
@IBDesignable
class CustomImgView : UIImageView {
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
            
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .clear {
        didSet{
            self.layer.borderColor = borderColor.cgColor
            
        }
    }
    
    @IBInspectable
    var hasShadow : Bool = false {
        didSet{
            if hasShadow {
                layer.applyShadow()
            }
        }
    }
}

@IBDesignable
class CustomTxtView : UITextView {
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
            
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .clear {
        didSet{
            self.layer.borderColor = borderColor.cgColor
            
        }
    }
    
    @IBInspectable
    var hasShadow : Bool = false {
        didSet{
            if hasShadow {
                layer.applyShadow()
            }
        }
    }
}
