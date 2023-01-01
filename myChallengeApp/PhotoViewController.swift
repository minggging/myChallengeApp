//
//  PhotoViewController.swift
//  myChallengeApp
//
//  Created by 정민경 on 2022/12/15.
//

import Foundation
import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    
    // 1) 이미지 피커 컨트롤러 추가
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 2) 이미지 피커에 딜리게이트 생성
        imagePickerController.delegate = self
    }
    
    @IBAction func btnActCamera(_ sender: UIButton) {

        // 5-1) 권한 관련 작업 후 콜백 함수 실행(카메라)
        authDeviceCamera(self) {

            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
    }

    @IBAction func btnActPhotoLibrary(_ sender: UIButton) {

        // 5-2) 권한 관련 작업 후 콜백 함수 실행(사진 라이브러리)
        authPhotoLibrary(self) {

            // .photoLibrary - Deprecated: Use PHPickerViewController instead. (iOS 14 버전 이상 지원)
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
    }

}

// 3) 이미지 피커 관련 프로토콜을 클래스 상속 목록에 추가
extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 4) 카메라 또는 사진 라이브러리에서 사진을 찍거나 선택했을 경우 실행할 내용 작성
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imgView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
