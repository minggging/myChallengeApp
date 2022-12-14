//
//  CALayer+Ext.swift
//  myChallengeApp
//
//  Created by 정민경 on 2022/11/09.
//

import Foundation
import UIKit

// ViewController에서 작성해도 되지만, 코드가 길어지고 복잡해지므로
// CALayer와 관련된 부분을 새 파일로 만들어서 작성함 (이후 찾기도 쉬울듯)
extension CALayer {
    /// 그림자 적용
    /// - Parameters:
    ///   - color: 그림자 색깔
    ///   - alpha: 투명도
    ///   - x: 가로 위치
    ///   - y: 세로 위치
    ///   - blur: 블러
    ///   - spread: 퍼짐 정도
  func applyShadow(
    color: UIColor = UIColor(named: "ShadowColor") ?? .black,
    alpha: Float = 0.3,
    x: CGFloat = 0,
    y: CGFloat = 20,
    blur: CGFloat = 35,
    spread: CGFloat = 0)
  {
      // 그림자 설정 시 꼭 설정해줘야 함
    masksToBounds = false
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / 2.0
    if spread == 0 {
      shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
}
