//
//  AddChallengeVC.swift
//  myChallengeApp
//
//  Created by 정민경 on 2022/11/22.
//

import Foundation
import UIKit
import PhotosUI
import Photos


class AddChallengeVC : UIViewController {
    
    
    @IBOutlet weak var addTitle : UITextField!
    @IBOutlet weak var addImage : UIImageView!
    @IBOutlet weak var addText : UITextView!
    
    @IBOutlet weak var addImageBtn: UIButton!
    
    
    // 클로저로 챌린지라는 데이터를 담음
    var saveBtnClicked : ((Challenge?) -> Void)? = nil
        
    // 챌린지데이터는 Challenge라는 자료형을 받고, 반환은 없다
    var challengeData : Challenge? = nil {
        didSet{
//            // 메인에 연결
//            DispatchQueue.main.async {
//                // AddChallengeVC와 챌린지데이터를 연결
//                self.addTitle.text = self.challengeData?.title
//                self.addImage.image = self.challengeData?.screenShot
//                self.addText.text = self.challengeData?.content
//                print("데이터 연결됨")
//            }
        }
    }
    
    /// 이미지 피커
    var imagePickerController = UIImagePickerController()

    lazy var photoPickerConfig : PHPickerConfiguration = {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        let sourceTypes: [PHPickerFilter] = [.images]
        
        config.filter = .any(of: sourceTypes)
        
        config.selectionLimit = 1
        
        config.preferredAssetRepresentationMode = .current

        if #available(iOS 15, *) {
            // 이미 선택된 이미지가 있을 경우 선택처리
            config.selection = .ordered
        }
        return config
    }()
    
    lazy var photoPickerController = PHPickerViewController(configuration: photoPickerConfig)
    
    lazy var takePhotoController : UIImagePickerController = {
        
        let picker = UIImagePickerController()
        
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.showsCameraControls = true
        
        return picker
    }()

    var accessoryDoneButton: UIBarButtonItem!
    let accessoryToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))

    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        addText.delegate = self
        
        // 텍스트뷰 첫 화면(placeholder처럼 보이도록)
        addText.text = "내용을 입력해주세요."
        addText.textColor = UIColor.lightGray
        print("여긴 화면 추가 뷰디드로드임")
        
        // 들어갈 이미지
        self.addImage.image = UIImage(systemName: "camera.badge.ellipsis")
                
        //타이틀 = 글 제목
        self.title = self.addTitle.text
        print("타이틀입니다. \(title)")
        print("컨텐트 내용입니다. \(addText.text)")
       
        // 텍스트필드 변화 감지
        self.addTitle.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        
        self.addImageBtn.addTarget(self, action: #selector(self.showImageAlert(_:)), for: .touchUpInside)
        
        let codeInput = UITextField()

        //Configured in viewDidLoad()
        self.accessoryDoneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.donePressed))
        self.accessoryToolBar.items = [self.accessoryDoneButton]
        
        self.addTitle.inputAccessoryView = self.accessoryToolBar
        self.addText.inputAccessoryView = self.accessoryToolBar
        
    

    } // viewDidLoad
    
    
    /// 완료 버튼 클릭 - 키보드 내려감
    @objc func donePressed() {
         print("donePressed called -", #fileID, #function, #line)
        // 현재 뷰에 있는 키보드 내리기
        view.endEditing(true)
    }

    //저장 버튼 누르고 타는 부분
    @IBAction func onSaveBtnClicked(_ sender: UIButton) {
        print("save 버튼 눌림 -", #fileID, #function, #line)
        print("데이터 받기 전 : \(self.challengeData)")
        
        // 저장 버튼을 누르면 saveBtnClicked(클로저)에 데이터가 들어간다
        self.saveBtnClicked?(self.challengeData)
        print("saveBtn눌리고 데이터 받음 \(self.challengeData)")
        
        // 뷰컨 팝
        self.navigationController?.popViewController(animated: true)
        print("뷰컨트롤러 팝")
    }
    
    
    // 텍스트필드의 입력 값 변경을 감지하고, 값을 가져옴
    @objc func textFieldDidChange(_ sender: Any?) {
        self.challengeData?.title = self.addTitle?.text ?? self.addTitle.placeholder!
    }
    
    @objc func showImageAlert(_ sender: UIButton) {
        print("이미지 버튼 클릭됨 - 이미지 alert 띄워야 함")
        
        self.present(self.getPhotoSelectBottomSheet(), animated: true, completion: nil)

    }

    
    // 텍스트뷰가 터치 되었는지 아닌지 확인
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.addText.resignFirstResponder()
        print("텍스트뷰 터치 됨")
    }

    
}

//MARK: - name
// 앨범 관련 델리겟
extension AddChallengeVC : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print(#fileID, #function, #line, "- comment")
        
        let selectedEditedImg = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
 
        DispatchQueue.main.async {
            self.addImage.image = selectedEditedImg
            self.challengeData?.screenShot = selectedEditedImg
        }
        self.takePhotoController.dismiss(animated: true, completion: nil)
    }

    
}

extension AddChallengeVC : PHPickerViewControllerDelegate {
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print("result : \(results.count) -", #fileID, #function, #line)
        
        var newSelection = [String: PHPickerResult]()
        
        results.forEach { result in
               result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
               guard let image = reading as? UIImage, error == nil else { return }
               DispatchQueue.main.async {
                   self.addImage.image = image
                   self.challengeData?.screenShot = image
               }
               result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.image") { [weak self] url, _ in
               }
          }
       }
        
        print(#fileID, #function, #line, "- newSelection: \(newSelection)")
                
        self.photoPickerController.dismiss(animated: true)

    }
}



//MARK: - 이미지 관련
extension AddChallengeVC {
    
    /// 공유 메서드
    fileprivate func getPhotoSelectBottomSheet() -> UIAlertController {
        print(#fileID, #function, #line, "- comment")
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 앱 내 '채팅으로 공유' 알럿 버튼
        let shootThePhotoAction = UIAlertAction(title: "사진찍기", style: .default, handler: { [weak self] action in
            guard let self = self else { return }
            print("사진찍기 클릭")
            self.takePhotoController.delegate = self
            self.present(self.takePhotoController, animated: true, completion: nil)
            
        })
        
        // '카카오톡으로 공유하기' 알럿 버튼
        let showAlbumAction = UIAlertAction(title: "앨범에서 사진선택", style: .default, handler: { [weak self] (action) in
            guard let self = self else { return }
            print("앨범에서 사진선택 클릭")
            
            self.photoPickerController.delegate = self
            self.present(self.photoPickerController, animated: true, completion: nil)
        })
        
        alertController.addAction(showAlbumAction)

        alertController.addAction(shootThePhotoAction)
        
        alertController.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: { (action) in
            print("닫기")
        }))
        
        return alertController
    }
    
    /// 이미지 피커 띄우기
    /// - Parameter sourceType: 미디어 소스 타입
    func showImagePicker(sourceType: UIImagePickerController.SourceType = .photoLibrary) {

        // 이미지 피커를 준비한다.
        imagePickerController.sourceType = sourceType
        imagePickerController.modalPresentationStyle =
            (sourceType == UIImagePickerController.SourceType.camera) ?
                UIModalPresentationStyle.fullScreen : UIModalPresentationStyle.popover
        
        let presentationController = imagePickerController.popoverPresentationController
        // Display a popover from the UIBarButtonItem as an anchor.
        presentationController?.permittedArrowDirections = UIPopoverArrowDirection.any

        // 카메라
        if sourceType == UIImagePickerController.SourceType.camera {
            imagePickerController.showsCameraControls = false

        }
        
        present(imagePickerController, animated: true, completion: {
        })
    }

}


/// 플레이스 홀더 설정
extension AddChallengeVC : UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if addText.text.isEmpty {
            addText.text =  "내용을 입력해주세요."
            addText.textColor = UIColor.lightGray
            
                    print("플레이스홀더 -", #fileID, #function, #line)
        }

    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if addText.textColor == UIColor.lightGray {
            addText.text = nil
            addText.textColor = UIColor.black
            
            print("플레이스홀더 -", #fileID, #function, #line)

        }
    }
}


