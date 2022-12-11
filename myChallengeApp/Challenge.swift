//
//  dummyData.swift
//  myChallengeApp
//
//  Created by 정민경 on 2022/11/22.
//

import Foundation
import UIKit

struct Challenge: Encodable{
    enum CodingKeys {
    case id, title, screenShot, content
    }
    
    let id: UUID = UUID()
    var title : String
    var screenShot : UIImage?
    var content : String
    
    func encode(to encoder: Encoder) throws {
    }

    
}
