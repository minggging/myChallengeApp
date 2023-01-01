//
//  UserDefaultsManager.swift
//  myChallengeApp
//
//  Created by Jeff Jeong on 2022/12/11.
//

import Foundation

class UserDefaultsManager {
    
    // 싱글턴 - 메모리 하나만 사용함
    static let shared: UserDefaultsManager = {
        return UserDefaultsManager()
    }()
    
    
    enum Key : String, CaseIterable {
        case challangeList
        case hobbyList
        case friendsList
    }
    
    //MARK: - 메모 관련
    
    /// 메모 목록 추가 및 저장하기
    /// - Parameter newValue: 저장할 값
    func setChallengeList(newList: [ChallengeData]){
        print("UserDefaultsManager - setChallengeList() called / newValue: \(newList.count)")
        do {
            // 모델 배열 -> json, Data
            // Encodable
            let data = try PropertyListEncoder().encode(newList)
            
            UserDefaults.standard.set(data, forKey: Key.challangeList.rawValue)
            UserDefaults.standard.synchronize()
            
            print("UserDefaultsManager - setChallengeList() 메모가 저장됨")
        } catch {
            print("에러발생 setChallengeList - error: \(error)")
        }
    } // 저장
    
    
    /// 저장된 메모 목록 가져오기
    /// - Returns: 저장된 값
    func getChallengeList() -> [ChallengeData]? {
        print("UserDefaultsManager - getChallengeList() called")
        if let data = UserDefaults.standard.object(forKey: Key.challangeList.rawValue) as? NSData {
            print("저장된 data: \(data.description)")
            do {
                // decodable
                let challengeDataList = try PropertyListDecoder().decode([ChallengeData].self, from: data as Data)
                return challengeDataList
            } catch {
                print("에러발생 getChallengeList - error: \(error)")
            }
        }
        return nil
    } // getChallengeList()
    
    
    func clearChallengeDataList(){
        print("UserDefaultsManager - clearChallengeDataList() called")
        UserDefaults.standard.removeObject(forKey: Key.challangeList.rawValue)
    }
    
    func clearAll(){
        print("UserDefaultsManager - clearAll() called")
        Key.allCases.forEach{
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
    
}
