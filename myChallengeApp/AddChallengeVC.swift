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
import Combine
import SnapKit
import SwiftUI

class AddChallengeVC : UIViewController {
    
    
    var subscriptions = Set<AnyCancellable>()

    @IBOutlet weak var buttomConstraints: LayoutConstraint!
    
    @IBOutlet weak var saveBtn:UIButton!
    
    @IBOutlet weak var addTitle : UITextField!
    @IBOutlet weak var addImage : UIImageView!
    @IBOutlet weak var addText : UITextView!
    
    @IBOutlet weak var addImageBtn: UIButton!
    
    // 델리겟 - 리모콘
    
    var myAddDelegate: ChallengeDelegate?
    
    var currentSelectedAssetId : String? = nil
    
    //    클로져로 받는 방법
    //    var saveBtnClicked : ((Challenge?) -> Void)? = nil
    
    
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
    
    /// 이미지 피커
    var imagePickerController : UIImagePickerController = UIImagePickerController()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 저장 버튼 (네비게이션바)
        let saveNavBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))

        self.navigationItem.rightBarButtonItem = saveNavBtn

        imagePickerController.delegate = self

        addText.delegate = self
//        saveBtn.layer.cornerRadius = 15
        
        // 텍스트뷰 첫 화면(placeholder처럼 보이도록)
        addText.text = "내용을 입력해주세요."
        addText.textColor = UIColor.secondarySystemFill
        print("여긴 화면 추가 뷰디드로드임")
        
        // 들어갈 이미지
        self.addImage.image = UIImage(named: "사용팁")
        
        //타이틀 = 글 제목
        self.title = self.addTitle.text ?? "제목을 입력해주세요."
        print("\(self.addTitle.text)")
        print("타이틀입니다. \(title)")
        print("컨텐트 내용입니다. \(addText.text)")
        
        // 텍스트필드 변화 감지
        self.addTitle.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        // 사진 추가 버튼은 showImageAlert을 탄다
        self.addImageBtn.addTarget(self, action: #selector(self.showImageAlert(_:)), for: .touchUpInside)
        
        /// 키보드 입력 완료 버튼
        self.accessoryDoneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.donePressed))
        self.accessoryToolBar.items = [self.accessoryDoneButton]
        
        // 텍스트가 들어가는 부분에 추가함
        self.addTitle.inputAccessoryView = self.accessoryToolBar
        self.addText.inputAccessoryView = self.accessoryToolBar
        
        
    } // viewDidLoad
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }

    
    @objc func saveTapped() {
        print("save 버튼 눌림 -", #fileID, #function, #line)
        
        let newChallengeData = Challenge(title: self.addTitle.text ?? "제목을 입력해주세요.",
                                         content: self.addText.text,
                                         screenShotAssetId: currentSelectedAssetId,
                                         screenShot: self.addImage.image
        )
        
        self.challengeData = newChallengeData
        
        self.performSegue(withIdentifier: "goBackToMain", sender: self)
        
//        myAddDelegate?.addChallenge(added: newChallengeData)
//
//
//
//        self.navigationController?.popViewController(animated: true)

        
    }
    
    //MARK: - 뷰의 저장 버튼
    //    //저장 버튼 누르고 타는 부분
    
    //    @IBAction func onSaveBtnClicked(_ sender: UIButton) {
//        print("save 버튼 눌림 -", #fileID, #function, #line)
//
//        let newChallengeData = Challenge(title: self.addTitle.text ?? "챌린지 제목을 입력해주세요 :)",
//                                         content: self.addText.text,
//                                         screenShotAssetId: currentSelectedAssetId,
//                                         screenShot: self.addImage.image
//        )
//
//        myAddDelegate?.addChallenge(added: newChallengeData)
//
//
//
//        self.navigationController?.popViewController(animated: true)
//
//    }
    
    
    
    //        print("save 버튼 눌림 -", #fileID, #function, #line)
    //        print("데이터 받기 전 : \(self.challengeData)")
    //    //
    //        // 저장 버튼을 누르면 saveBtnClicked(클로저)에 데이터가 들어간다
    //                self.saveBtnClicked?(self.challengeData)
    //        //        print("saveBtn눌리고 데이터 받음 \(self.challengeData)")
    //
    //        // 뷰컨 팝
    //        self.navigationController?.popViewController(animated: true)
    //        print("뷰컨트롤러 팝")
    //    }
    //
    //
    // 텍스트필드의 입력 값 변경을 감지하고, 값을 가져옴
    @objc func textFieldDidChange(_ sender: UITextField) {
        
        self.addTitle?.text = sender.text
        
        //            self.challengeData?.title = self.addTitle?.text ?? self.addTitle.placeholder!
    }
    
    
    
    
    //MARK: - 앨범 관련
    // 이미지만 선택 가능, 1개까지 선택
//    lazy var photoPickerConfig : PHPickerConfiguration = {
//        var config = PHPickerConfiguration(photoLibrary: .shared())
//        authPhotoLibrary(self) {}
//        let sourceTypes: [PHPickerFilter] = [.images]
//        config.filter = .any(of: sourceTypes)
//        config.selectionLimit = 1
//        config.preferredAssetRepresentationMode = .current
//
//        if #available(iOS 15, *) {
//            config.selection = .ordered
//        }
//        return config
//    }()

    lazy var photoPickerConfig : PHPickerConfiguration = {
        var config = PHPickerConfiguration(photoLibrary: .shared())
            let sourceTypes: [PHPickerFilter] = [.images]
            config.filter = .any(of: sourceTypes)
            config.selectionLimit = 1
            config.preferredAssetRepresentationMode = .current
            
            if #available(iOS 15, *) {
                config.selection = .ordered
            }
        return config
    }()

    
    //MARK: - 사진 촬영 관련
    // 사진 촬영 및 편집 가능, 컨트롤러 보임
    
        
        lazy var photoPickerController = PHPickerViewController(configuration: photoPickerConfig)
        lazy var takePhotoController : UIImagePickerController = {
            authDeviceCamera(self) { }

            let picker = UIImagePickerController()
            
                picker.allowsEditing = true
                picker.sourceType = .camera
                picker.cameraCaptureMode = .photo
                picker.showsCameraControls = true
            
            return picker

        }()
            
    
    //MARK: - 키보드 입력 완료 부분
    /// Done버튼
    var accessoryDoneButton: UIBarButtonItem!
    let accessoryToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    
    /// 완료 버튼 클릭 - 키보드 내려감
    @objc func donePressed() {
        print("donePressed called -", #fileID, #function, #line)
        // 현재 뷰에 있는 키보드 내리기
        view.endEditing(true)
    }
    
    //MARK: - 이미지 추가 버튼
    @objc func showImageAlert(_ sender: UIButton) {
        print("이미지 버튼 클릭됨")
        // 이제 추가할 이미지를 불러와야지!
        // 아래에서 새 창이 올라옴, getPhotoSelectBottomSheet를 탄다
        self.present(self.getPhotoSelectBottomSheet(), animated: true, completion: nil)
        
    }
    
    
    // 텍스트뷰가 터치 되었는지 아닌지 확인
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        self.addText.resignFirstResponder()
    //        print("텍스트뷰 터치 됨")
    //
    //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    //
    //    }
    
    
}

//MARK: - 사진찍기 관련 델리겟
extension AddChallengeVC : UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // 매개변수의 자료형은 UIImagePickerController지만, 매개변수를 받지는 않을 거임
    // didFinishPickingMediaWithInfo : 사진을 pick하고 전달할 정보
    // [UIImagePickerController.InfoKey : Any] : 이미지 정보를 뜻하는 것 같다
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print(#fileID, #function, #line, "- comment")
        // 수정된 이미지의 정보를 뜻한다. 자료형은 UIImage로 지정
        let selectedEditedImg = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        // main과 데이터 연결
        DispatchQueue.main.async {
            self.addImage.image = selectedEditedImg
            //            self.challengeData?.screenShot = selectedEditedImg
        }
        // picker를 닫는 동작?
        self.takePhotoController.dismiss(animated: true, completion: nil)
    }
    
    
}

//MARK: - 앨범관련 델리겟
extension AddChallengeVC : PHPickerViewControllerDelegate {
    
    // 매개변수의 자료형은 PHPickerViewController, didFinishPicking results : 선택 결과
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print("result : \(results.count) -", #fileID, #function, #line)
        // 아마 새로운 선택을 했을 때 [PHPickerResult]의 배열을 바꾸기 위한 부분 같다
        var newSelection = [String: PHPickerResult]()
        
        // forEach를 통해 클로저(데이터)를 넘겨주는 반복문
        results.forEach { result in
            // 이미지를 선택했을 때 불러올 class?와 그 때 타게 될 로직을 클로저로 설정한...건가?
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                // image가 첫 번째로 들어오는 매개변수(이미지)를 받고, error가 두번째로 들어오는 매개변수를 받는데, nil값이다..? 아니면 리턴해라???
                guard let image = reading as? UIImage, error == nil else { return }
                
                print("selected image: \(image), result.assetId: \(result.assetIdentifier)")
                
                self.currentSelectedAssetId = result.assetIdentifier
                
                // 메인에 연결
                DispatchQueue.main.async {
                    self.addImage.image = image
                    //                    self.challengeData?.screenShot = image
                }
                // forTypeIdentifier: 파일 식별자 부분에는 String, 그 다음 타게 되는 로직은 클로저로 되어있다 ( 뭐가 들어있는지는 모르겠음.. 사진의 url?)
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.image") { [weak self] url, _ in
                }
            }
        }
        
        print(#fileID, #function, #line, "- newSelection: \(newSelection)")
        // 할 일 다 했으면 닫기
        self.photoPickerController.dismiss(animated: true)
        
    }
}



//MARK: - 이미지 관련
extension AddChallengeVC {
    
    /// actionSheet  부분
    fileprivate func getPhotoSelectBottomSheet() -> UIAlertController {
        print(#fileID, #function, #line, "- comment")
        // 기본 형태의 얼럿 컨트롤러
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 이미지 터치했을 때 하단 사진찍기 얼럿시트 설정
        let shootThePhotoAction = UIAlertAction(title: "사진찍기", style: .default, handler: { [weak self] action in
            // 옵셔널 언래핑
            guard let self = self else { return }
            print("사진찍기 클릭")
            // 델리겟 연결
            self.takePhotoController.delegate = self
            // 아래에서 위로 올라옴
            self.present(self.takePhotoController, animated: true, completion: nil)
            
        })
        
        // 이미지 터치했을 때 하단 앨범선택 얼럿시트 설정
        let showAlbumAction = UIAlertAction(title: "앨범에서 사진선택", style: .default, handler: { [weak self] (action) in
            guard let self = self else { return }
            print("앨범에서 사진선택 클릭")
            
            // 델리겟 연결
            self.photoPickerController.delegate = self
            // 아래에서 위로 올라옴
            self.present(self.photoPickerController, animated: true, completion: nil)
        })
        // 얼럿 컨트롤러에 사진 찍기 / 앨범 선택 시트 / 닫기 를 추가함
        alertController.addAction(showAlbumAction)
//        alertController.addAction(shootThePhotoAction)
        alertController.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: { (action) in
            print("닫기")
        }))
        
        return alertController
    }
    
    /// 이미지 피커 띄우기
    /// - Parameter sourceType: 미디어 소스 타입
    func showImagePicker(sourceType: UIImagePickerController.SourceType = .photoLibrary) {
        
        // 이미지 피커의 소스타입을 앨범 형태의 소스타입으로 맞춤
        imagePickerController.sourceType = sourceType
        // modalPresentationStyle : 화면 전환 기법
        imagePickerController.modalPresentationStyle =
        // 카메라 화면이면, 화면이 풀스크린으로 표현된다는 뜻
        (sourceType == UIImagePickerController.SourceType.camera) ?
        UIModalPresentationStyle.fullScreen : UIModalPresentationStyle.popover
        // popover: 화면 내에 일부 부분을 뷰로 띄움
        // permittedArrowDirections : popover 되는 방향
        let presentationController = imagePickerController.popoverPresentationController
        presentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        
        // 카메라 부분
        // showsCameraControls를 false로 해야 여러장 찍기 가능, true로 하면 찍을 때마다 취소하고 다시 켜야 함
        if sourceType == UIImagePickerController.SourceType.camera {
            imagePickerController.showsCameraControls = false
            
        }
        // 위 설정대로 imagePickerController를 띄움
        present(imagePickerController, animated: true, completion: {
        })
    }
    
}


/// 플레이스 홀더 설정
extension AddChallengeVC : UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if addText.text.isEmpty {
            addText.text =  "내용을 입력해주세요."
            addText.textColor = UIColor(named: "PlaceholderColor")
            
            print("플레이스홀더 -", #fileID, #function, #line)
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if addText.text == "내용을 입력해주세요." {
            addText.text = nil
            addText.textColor = UIColor(named: "textColor")
            
            print("플레이스홀더 -", #fileID, #function, #line)
            
        }
    }
    
    
}



