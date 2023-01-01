//
//  dummyData.swift
//  myChallengeApp
//
//  Created by 정민경 on 2022/11/22.
//

import Foundation
import UIKit
import Photos

// 별칭
//typealias MinggingType = Int & String


// codable : json

// make + json : class, struct -> json
// Encodable

// 분해 + json : json -> class, struct
// Decodable

struct MyData: Encodable {
    
    var title : String? = nil
    
}

struct Challenge{
    
    var id: UUID = UUID()
    var title : String
    var screenShotAssetId : String?
    var content : String
    var screenShot : UIImage? // photo key
    
    init(
        title: String,
         content: String,
         screenShotAssetId: String?,
         screenShot: UIImage?
    
    ){
//        if let assetId : String = screenShotAssetId {
//          self.screenShotAssetId = assetId
//        }

        self.title = title
        self.content = content
        self.screenShot = screenShot
        self.screenShotAssetId = screenShotAssetId ?? ""

    }
    
    init(storedData: ChallengeData){
        self.id = storedData.uuid
        self.title = storedData.title
        self.content = storedData.content
        self.screenShotAssetId = storedData.screenShotAssetId
        self.screenShot = nil
    }
    
    static func getData(storedData : ChallengeData, fetchData: @escaping (Challenge) -> Void) {
     
        var challenge = Challenge(storedData: storedData)
        
        let options = PHFetchOptions()
        let results = PHAsset.fetchAssets(withLocalIdentifiers: [storedData.screenShotAssetId], options: options)
        let manager = PHImageManager.default()
        results.enumerateObjects {(thisAsset, _, _) in
            manager.requestImage(for: thisAsset, targetSize: CGSize(width: 600.0, height: 600.0), contentMode: .aspectFill, options: nil, resultHandler: {(thisImage, _) in
                print(#fileID, #function, #line, "\(thisImage)")
                challenge.screenShot = thisImage
                fetchData(challenge)
            })
        }
    }
    
    static func getDataList(storedDataList : [ChallengeData], fetchData: @escaping ([ChallengeData]) -> Void) {
     
//        var challenge = Challenge(storedData: storedData)

        var fetchedChallengeList : [Challenge] = storedDataList.map{ Challenge(storedData: $0) }
        print("패치 : \(storedDataList)")
        print("Challenge - fetch photo - fetchedChallengeList.count : \(fetchedChallengeList.count)")

        var photos : [String : UIImage] = [:]

        let assetIds = storedDataList.map { $0.screenShotAssetId }

        
        let options = PHFetchOptions()
        let results = PHAsset.fetchAssets(withLocalIdentifiers: assetIds, options: options)
        let manager = PHImageManager.default()
        results.enumerateObjects {(thisAsset, index, _) in
            manager.requestImage(for: thisAsset, targetSize: CGSize(width: 600.0, height: 600.0), contentMode: .aspectFill, options: nil, resultHandler: {(thisImage, _) in
                
                fetchedChallengeList[index].screenShot = thisImage
                print("Challenge - fetch photo - index: \(index)")
                print("패치 : \(storedDataList)")
            })
        }
        print("fetch photo - end:")
    }
}

class ChallengeData: NSObject, NSCoding, NSSecureCoding, Codable {
    
    static var supportsSecureCoding: Bool = true
    
    // 고유 아이디
    var uuid: UUID = UUID()
    private (set) var title: String
    private (set) var screenShotAssetId: String
    private (set) var content: String
    
    init(title: String,
         screenShotAssetId: String,
         content: String
    ) {
        self.title = title
        self.screenShotAssetId = screenShotAssetId
        self.content = content
    }
    
    init(data: Challenge){
        self.uuid = data.id
        self.title = data.title
        self.content = data.content
        #warning("TODO : - 나중에 봐야함")
        self.screenShotAssetId = data.screenShotAssetId!
    }

    // NSCoding 을 사용할때 필요한 것들
    // class -> json
    func encode(with coder: NSCoder) {
        coder.encode(self.title, forKey: "title")
        coder.encode(self.screenShotAssetId, forKey: "screenShotAssetId")
        coder.encode(self.content, forKey: "content")
    }
    
    // json -> class
    required convenience init?(coder decoder: NSCoder) {
        guard let content = decoder.decodeObject(forKey: "content") as? String,
              let screenShotAssetId = decoder.decodeObject(forKey: "screenShotAssetId") as? String,
              let title = decoder.decodeObject(forKey: "title") as? String
              else { return nil }
        self.init(title: title, screenShotAssetId: screenShotAssetId, content: content)
    }
    
    func to() -> Challenge {
        return Challenge(title: self.title, content: self.content, screenShotAssetId: self.screenShotAssetId, screenShot: nil)
    }
}

