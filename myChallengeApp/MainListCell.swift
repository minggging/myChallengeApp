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
    
    @IBOutlet weak var customView: CustomView!
    @IBOutlet weak var editBtn: UIButton!
        
    
    @objc var editBtnClicked : ((UIImage?) -> Void)? = nil
    
    
    
    
    
    // 뷰디드로드 같은 녀석
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print(#fileID, #function, #line, "- <#comment#>")
                
        editBtn.addTarget(self, action: #selector(onEditBtnClicked), for: .touchUpInside)
        
        
        
    }
        
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    // 이미지를 보냄
    @objc fileprivate func onEditBtnClicked(){
        print(#fileID, #function, #line, "- ")
        
        // 데이터 == 테이블뷰에 있는 이미지
        let data : UIImage? = self.titleImage.image
        // 이미지를 담음
        editBtnClicked?(data)
    }
    
}
