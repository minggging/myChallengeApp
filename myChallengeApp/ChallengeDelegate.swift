//
//  AddChallengeDelegate.swift
//  myChallengeApp
//
//  Created by 정민경 on 2022/12/04.
//

import Foundation
import UIKit

// 1. 버튼들 지정
protocol ChallengeDelegate {
    
    /// 챌린지가 추가되었다는 액션
    func addChallenge(added : Challenge)
    
    
    /// 첼린지 삭제
    /// - Parameter id: 삭제할 아이디
    func deleteChallenge(id: UUID)
    
    /// 데이터 전송
    func dataSend()
    
    /// 데이터 수정
    func editChallenge(edited: Challenge)
}


//class MyVC : ChallengeDelegate {
//
//    func challengeAdded(added: Challenge) {
//        <#code#>
//    }
//}
