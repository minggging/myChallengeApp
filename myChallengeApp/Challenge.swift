//
//  dummyData.swift
//  myChallengeApp
//
//  Created by 정민경 on 2022/11/22.
//

import Foundation
import UIKit

struct Challenge {
    let id: UUID = UUID()
    var title : String
    var screenShot : UIImage?
    var content : String
}
