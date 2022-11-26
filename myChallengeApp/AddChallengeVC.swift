//
//  AddChallengeVC.swift
//  myChallengeApp
//
//  Created by 정민경 on 2022/11/22.
//

import Foundation
import UIKit


class AddChallengeVC : UIViewController {
    
    @IBOutlet weak var addTitle : UITextField!
    @IBOutlet weak var addImage : UIImageView!
    @IBOutlet weak var addText : UITextView!
    
    
    // 클로저로 챌린지라는 데이터를 담음
    var saveBtnClicked : ((Challenge?) -> Void)? = nil
        
    // 챌린지데이터는 Challenge라는 자료형을 받고, 반환은 없다
    var challengeData : Challenge? = nil {
        didSet{
            // 메인에 연결
            DispatchQueue.main.async {
                // AddChallengeVC와 챌린지데이터를 연결
                self.addTitle.text = self.challengeData?.title
                self.addImage.image = self.challengeData?.screenShot
                self.addText.text = self.challengeData?.content
                print("데이터 연결됨")
            }
        }
    }
    
    
    
        
    override func viewDidLoad() {
        placeholderSetting(text: "내용을 입력해 주세요")
        textViewDidBeginEditing(addText)
        textViewDidEndEditing(addText)
        
        self.addImage.image = UIImage(systemName: "camera.badge.ellipsis")
        self.addText.text = self.placeholderSetting(text: "내용을 입력해 주세요")
        
        
        self.challengeData?.title = addTitle.text ?? addTitle.placeholder!
        self.challengeData?.screenShot = addImage.image ?? UIImage(systemName: "camera.badge.ellipsis")
        self.challengeData?.content = addText.text
        
        self.title = self.addTitle.text
        print("타이틀입니다. \(title)")
        print("컨텐트 내용입니다. \(addText.text)")
        
        self.addTitle.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        

        

        
    }

    
    
    
    @IBAction func onSaveBtnClicked(_ sender: UIButton) {
        print("save 버튼 눌림 -", #fileID, #function, #line)
        print("데이터 받기 전 : \(self.challengeData)")
        
        self.saveBtnClicked?(self.challengeData)
        print("saveBtn눌리고 데이터 받음 \(self.challengeData)")
        
        self.navigationController?.popViewController(animated: true)
        print("뷰컨트롤러 팝")
    }
    
    
    // 텍스트필드의 입력 값 변경을 감지하고, 값을 가져옴
    @objc func textFieldDidChange(_ sender: Any?) {
        self.challengeData?.title = self.addTitle?.text ?? self.addTitle.placeholder!
    }
    
    

    
    
    
    
    //MARK: - 텍스트뷰 설정
//    func textviewPalceholder() {
//        placeholderSetting()
//        textViewDidBeginEditing(addText)
//        textViewDidEndEditing(addText)
//    }
    
    // 텍스트뷰 placeholder 만들기
    func placeholderSetting (text : String) -> String {
        addText?.text = text
        addText?.textColor = UIColor.lightGray
        print("텍스트뷰 placeholder 탐")
        return text
    }
    // 사용자의 입력이 시작됐을 때 설정
    func textViewDidBeginEditing(_ textView: UITextView) {
        // 텍스트 컬러 변경, placeholder 텍스트 nil로 변경
        if addText.textColor == UIColor.lightGray {
            addText.text = nil
            addText.textColor = UIColor.black
            print("텍스트뷰 입력 시작")
            
        }
    }
    // 사용자의 입력이 끝났을 때 설정
    func textViewDidEndEditing(_ textView: UITextView) {
        // 텍스트뷰의 텍스트가 비어있으면 다시 placeholder의 텍스트를 설정함, 글자색 설정
        if addText.text.isEmpty {
            addText.text = "오늘의 챌린지 후기를 적어주세요."
            addText.textColor = UIColor.lightGray
            print("텍스트뷰 입력 끝남")
        }
    }

    
}


