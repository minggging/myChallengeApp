//
//  customView.swift
//  myChallengeApp
//
//  Created by 정민경 on 2022/11/08.
//

import Foundation
import UIKit

// 스토리보드에서 하단 코드에 대한 변화를 바로 확인할 수 있음
@IBDesignable
// 커스텀뷰가 UI뷰를 상속받음
class CustomView : UIView {
// 스토리보드 내부 inspertor에 cornerRadius를 설정하는 부분을 만듦
    @IBInspectable
    // cornerRadius는 CGFloat를 상속받고, 기본 설정은 0이다
    var cornerRadius: CGFloat = 0 {
        didSet{
            self.clipsToBounds = true
            self.layer.cornerRadius = cornerRadius

        }
    }
    
    // 위의 코드와 같음, 테두리 두께 설정
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    // 위의 코드와 같음, 테두리 색깔 설정, borderColor는 UIColor를 상속 받고, 기본 설적은 투명이다
    @IBInspectable
    var borderColor: UIColor = .clear {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    // 그림자 설정, 기본 설정은 false(off)이다.
    @IBInspectable
    var hasShadow : Bool = false {
        didSet{
            // hasShadow가 on 이면, applyShadow가 실행된다
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
            self.clipsToBounds = true
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
class CustomTextView : UITextView {
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet{
            self.clipsToBounds = true
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
class CustomLabel : UILabel {
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet{
            self.clipsToBounds = true
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
class CustomTextField : UITextField {
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet{
            self.clipsToBounds = true
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
