//
//  ChallengeBoardVC.swift
//  myChallengeApp
//
//  Created by 정민경 on 2022/11/16.
//

import Foundation
import UIKit

//struct Challenge {
//    var uuid: UUID
//    var title: String
//    var screenShot: UIImage?
//    var content: String
//}

class ChallengeBoardVC: UIViewController {
    
    @IBOutlet weak var myTextView: CustomTextView!
    @IBOutlet weak var myChallengeView: UIView!
    @IBOutlet weak var myChallengeImg: CustomImgView!
    @IBOutlet weak var titleTextField: CustomTextField!
    
    var doneBtnClicked : ((Challenge?) -> Void)? = nil
    
    var challengeData : Challenge? = nil {
        didSet{
            DispatchQueue.main.async {
                self.titleTextField.text = self.challengeData?.title
                self.myChallengeImg.image = self.challengeData?.screenShot
                self.myTextView.text = self.challengeData?.content
            }
        }
    }
    
//    var selectedImg : UIImage? = nil{
//        didSet{
//            DispatchQueue.main.async {
//                self.myChallengeImg.image = self.selectedImg
//            }
//        }
//    }
//
//    var content : String = ""{
//        didSet{
//            DispatchQueue.main.async {
//                self.myTextView.text = self.content
//            }
//        }
//    }
    
    //MARK: - 텍스트뷰 설정
    // 텍스트뷰 placeholder 만들기
    func placeholderSetting() {
        myTextView.text = "오늘의 챌린지 후기를 적어주세요."
        myTextView.textColor = UIColor.lightGray
        print("미리보기 탐")
    }
    // 사용자의 입력이 시작됐을 때 설정
    func textViewDidBeginEditing(_ textView: CustomTextView) {
        // 텍스트 컬러 변경, placeholder 텍스트 nil로 변경
        if myTextView.textColor == UIColor.lightGray {
            myTextView.text = nil
            myTextView.textColor = UIColor.black
         print("입력 시작")
        }
    }
    // 사용자의 입력이 끝났을 때 설정
    func textViewDidEndEditing(_ textView: CustomTextView) {
        // 텍스트뷰의 텍스트가 비어있으면 다시 placeholder의 텍스트를 설정함, 글자색 설정
        if myTextView.text.isEmpty {
            myTextView.text = "오늘의 챌린지 후기를 적어주세요."
            myTextView.textColor = UIColor.lightGray
        print("입력 끝남")
        }
    }

    // 글 제목과 상단 제목 맞춤
    func titleName () {
        titleTextField.text = self.title
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 텍스트뷰 placeholder
        placeholderSetting()
        textViewDidBeginEditing(myTextView)
        textViewDidEndEditing(myTextView)
        
        titleName()
//        self.title = titleTextField.text

        
    }
    
    @IBAction func onDoneBtnClicked(_ sender: UIButton) {
        print(#fileID, #function, #line, "- ")
        
        self.navigationController?.popViewController(animated: true)
        
        self.doneBtnClicked?(self.challengeData)
        
//        self.dismiss(animated: true, completion: { [weak self] in
//
//        })
        
    }
    
    
}
