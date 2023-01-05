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
        
    
    var editBtnClicked : ((Challenge?) -> Void)? = nil
    
    var delegate : ChallengeDelegate? = nil
    
    var challenge : Challenge? = nil
    
    var deleteBtnClicked : ((UUID) -> Void)? = nil
    
    
    // 뷰디드로드 같은 녀석
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print(#fileID, #function, #line, "- <#comment#>")
                
        editBtn.addTarget(self, action: #selector(onEditBtnClicked(_:)), for: .touchUpInside)
        
    }
        
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    // 외부 (MainListVC -> Cell) 현재 row의 데이터 주기
    func bind(data: Challenge, delegate: ChallengeDelegate) {
        print(#fileID, #function, #line, "- data.id: \(data.id)")
        
        self.delegate = delegate
        
        challenge = data
        
        // 위 작업을 마치면 커스텀 클래스의 outlet을 사용할 수 있다.
        self.titleLabel.text = data.title
        
//        if let screenShot = data.screenShot {
//            self.titleImage.image = screenShot
//        } else {
//            self.titleImage.image = UIImage(named: "사용팁")
//        }
        
        self.titleImage.image = data.screenShot ?? UIImage(named: "사용팁")
    }
    
    // 이미지를 보냄
    @objc fileprivate func onEditBtnClicked(_ button:UIButton){
        print(#fileID, #function, #line, "- button:\(button)")
        
        // 데이터 == 테이블뷰에 있는 이미지
        let data : UIImage? = self.titleImage.image
        // 이미지를 담음
        editBtnClicked?(challenge)
    }
    
    @IBAction func onDeleteClicked(_ sender: UIButton) {
        print(#fileID, #function, #line, "- ")
        
        
        if let challengeId = challenge?.id {
            // MainListVC한테 알리기
            // 델리겟 방식
            delegate?.deleteChallenge(id: challengeId)
            
            // 클로져 방식
//            deleteBtnClicked?(challengeId)
        }
           
    }
}
