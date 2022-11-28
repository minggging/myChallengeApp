//
//  TableViewCell.swift
//  myChallengeApp
//
//  Created by 정민경 on 2022/11/16.
//

import UIKit


class MainListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var missionBtn: UIButton!
    
    var editBtnClicked : ((String) -> Void)? = nil
    var missionBtnClicked : ((UIImage?) -> Void)? = nil
    
    // 뷰디드로드 같은 녀석
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print(#fileID, #function, #line, "- <#comment#>")
        // 수정 버튼 -> editClicked을 호출
        editBtn.addTarget(self, action: #selector(editClicked), for: .touchUpInside)
        
        // 미션버튼 -> missionClicked을 호출
        missionBtn.addTarget(self, action: #selector(missionClicked), for: .touchUpInside)
        
        
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // 테이블뷰의 라벨 제목을 데이터로 담음
    @objc fileprivate func editClicked(){
        print(#fileID, #function, #line, "- ")
        
        let data : String = self.titleLabel.text ?? "값이 없음"

        editBtnClicked?(data)
        
    }
    
    // 이미지를 보냄
    @objc fileprivate func missionClicked(){
        print(#fileID, #function, #line, "- ")
        
        // 데이터 == 테이블뷰에 있는 이미지
        let data : UIImage? = self.titleImage.image
        // 이미지를 담음
        missionBtnClicked?(data)
    }
    
}
