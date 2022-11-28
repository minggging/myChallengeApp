//
//  ChallengeBoardVC.swift
//  myChallengeApp
//
//  Created by 정민경 on 2022/11/16.
//

import Foundation
import UIKit

class ChallengeBoardVC: UIViewController {
    @IBOutlet weak var myTitle: UITextField!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myText: UITextView!

    
    var doneBtnClicked : ((Challenge?) -> Void)? = nil
    
    var challengeData : Challenge? = nil {
        didSet{
            DispatchQueue.main.async {
                self.myTitle.text = self.challengeData?.title
                self.myImage.image = self.challengeData?.screenShot
                self.myText.text = self.challengeData?.content
            }
        }
    }
        
    // 글 제목과 상단 제목 맞춤
    func titleName () {
        myTitle.text = self.title
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myText.delegate = self
        
        // 텍스트뷰 첫 화면(placeholder처럼 보이도록)
        myText.text = "내용을 입력해주세요."
        myText.textColor = UIColor.lightGray
        print("여긴 화면 추가 뷰디드로드임")

        titleName()
        
    }
    
    // 텍스트뷰가 터치 되었는지 아닌지 확인
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.myText.resignFirstResponder()
        print("텍스트뷰 터치 됨")
    }

    
    
    
    
    
    
    
    
    @IBAction func onDoneBtnClicked(_ sender: UIButton) {
        print(#fileID, #function, #line, "- ")
        
        self.navigationController?.popViewController(animated: true)
        
        self.doneBtnClicked?(self.challengeData)
                
    }
    
    
}


/// 플레이스 홀더 설정
extension ChallengeBoardVC : UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if myText.text.isEmpty {
            myText.text =  "내용을 입력해주세요."
            myText.textColor = UIColor.lightGray
            
                    print("플레이스홀더 -", #fileID, #function, #line)
        }

    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if myText.textColor == UIColor.lightGray {
            myText.text = nil
            myText.textColor = UIColor.black
            
            print("플레이스홀더 -", #fileID, #function, #line)

        }
    }
}

