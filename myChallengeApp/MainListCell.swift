//
//  TableViewCell.swift
//  myChallengeApp
//
//  Created by 정민경 on 2022/11/16.
//

import UIKit

class MainListCell: UITableViewCell {

    @IBOutlet weak var tableViewLabel: UILabel!
    @IBOutlet weak var tableViewImgView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
                // Initialization code
    }

//    override func layoutSubviews() {
//        // 테이블 뷰 셀 사이의 간격
//        super.layoutSubviews()
//
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0))
//    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
