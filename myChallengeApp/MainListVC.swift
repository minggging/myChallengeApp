//
//  MainLIstVC.swift
//  myChallengeApp
//
//  Created by 정민경 on 2022/11/16.
//
import UIKit
import Photos
import Combine


class MainListVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
        
    @IBOutlet weak var myTableView: UITableView!
    
    var addBtnClicked : ((Challenge?) -> Void)? = nil
        
    var dataList : [Challenge] = [
        Challenge(title: "Day 1 ! 오늘의 챌린지는? :)"
                  , content: "오늘의 노력에 대해서 적어주세요 ! ", screenShotAssetId: "defaultImage", screenShot: UIImage(named: "사용tip"))]
    
    var mainDelegate: ChallengeDelegate?
    
    // 상세 챌린지 화면에 넘길 데이터
    var selectedChallengeForChallengeBoardVC : Challenge? = nil
    
    let imagePickerController = UIImagePickerController()
    
    //MARK: - Notification으로 데이터 받기 관련 (Add)
    @objc func getAddedData(_ noti: Notification) {
                print("addedData 받음 -", #fileID, #function, #line)
        
        guard let newData = noti.userInfo?["addedData"] as? Any else { return print("노티에서 받은 데이터 없음")}
                
        addChallenge(added: newData as! Challenge)
    }
    //MARK: - Notification으로 데이터 받기 관련 (Edit)

    @objc func getEditedData(_ noti: Notification) {
                print("editedData 받음 -", #fileID, #function, #line)
        
        guard let editedData = noti.userInfo?["editedData"] as? Any else { return print("노티에서 받은 데이터 없음")}
        
        editChallenge(edited: editedData as! Challenge)
    }

    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
                print("comment -", #fileID, #function, #line)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(getAddedData(_:)), name: Notification.Name("sendAddData"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getEditedData(_:)), name: Notification.Name("sendEditData"), object: nil)

        
        imagePickerController.delegate = self

        authPhotoLibrary(self, completion: {
            print("허용 완료")
        })
            
        myTableView.dataSource = self
        myTableView.delegate = self
        
        
        
        let addChallegeStoryboard = UIStoryboard(name: "AddChallenge", bundle: Bundle.main)
        let addChallengeVC = addChallegeStoryboard.instantiateViewController(withIdentifier: "AddChallengeVC") as! AddChallengeVC
        

        if let storedDataList : [ChallengeData] = UserDefaultsManager.shared.getChallengeList() {
            self.dataList = storedDataList.map{ Challenge(storedData: $0) }
            print("dataList: \(dataList)")
            print("MainListVC - fetch photo - self.dataList.count : \(self.dataList.count)")
            
            fetchImages(data: dataList)
        }
        
        
    } // viewDidLoad.
    
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: .sendAddData, object: nil)
        NotificationCenter.default.removeObserver(self, name: .sendEditData, object: nil)
        
        
    }
    
    
    
    
    func fetchImages(data: [Challenge]){
        
        var photos : [String : UIImage] = [:]
        
        let assetIds = data.compactMap { $0.screenShotAssetId }
        
        let options = PHFetchOptions()
        let results = PHAsset.fetchAssets(withLocalIdentifiers: assetIds, options: options)
        let manager = PHImageManager.default()
        
        let imgSize = CGSize(width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height * 2)
        
        results.enumerateObjects {(thisAsset, index, _) in
            manager.requestImage(for: thisAsset, targetSize: imgSize, contentMode: .default, options: nil, resultHandler: {(thisImage, _) in
                let assetId = thisAsset.localIdentifier
                photos[assetId] = thisImage
                print("assetId: \(assetId)")
                guard let index = self.dataList.firstIndex(where: { $0.screenShotAssetId == assetId }) else {
                    return
                }
                self.dataList[index].screenShot = thisImage
                self.myTableView.reloadData()
            })
        }
    }
    
    // + 버튼을 누르면 챌린지 추가 화면으로 이동함
    @IBAction func onAddChallengeClicked(_ sender: Any) {
        print(#fileID, #function, #line, "- ")
        
        self.navigateToAddChallengeVC()
        
    }


    
    //MARK: - deleteBtn 관련
    @IBAction func deleteBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message:"삭제 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "삭제", style: .destructive) { (action) in
                    // 해당 셀을 삭제하는 방법
                    // 1. 현재의 셀의 위치를 파악한다. indexPath.row -> tableViewCell의 데이터소스에서 확인
                    // 2. 그 위치에 있는 셀을 삭제한다.
                    // 3. 리로드
                    
                    
                    // 데이터를 삭제하는 방법
                    // 1. 해당 셀에 들어오는 데이터를 파악한다. <- 여기서부터 막힘
                    // 2. 데이터의 id를 파악한다.
                    // 3-1. 해당 id를 가진 데이터를 제외하고 필터링해서 새로운 리스트 짜기
                    // 3-2. 해당 id를 지우기
                    // 4. 리로드
                }
                let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
                alert.addAction(okAction)
                alert.addAction(cancleAction)

        self.present(alert, animated: true)
        
    }
    
    //MARK: - segueway 방식
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let challengeBoardVC = segue.destination as? ChallengeBoardVC {
            print("도착지가 챌린지 보드 입니다 ")
            challengeBoardVC.challengeData = self.selectedChallengeForChallengeBoardVC
            challengeBoardVC.myDelegate = self
        }
        
    }
    
}



//MARK: - 데이터 소스 관련

// tableview의 datasource와 delegate 등록
extension MainListVC: UITableViewDataSource {
    
    // table row 갯수 (menu 배열의 갯수만큼)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return labels.count
        return dataList.count
    }
        
    // 각 row 마다 데이터 세팅.
    // 데이터 <-> UI 연동
    // 데이터 <-> 이벤트 연동
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 첫 번째 인자로 등록한 identifier, cell은 as 키워드로 앞서 만든 custom cell class화 해준다.
        let cell = myTableView.dequeueReusableCell(withIdentifier: "MainListCell", for: indexPath) as! MainListCell
        
        let cellData = dataList[indexPath.row]
        
//        cell.delegate = self
        
        // 쎌에 데이터 주기
        cell.bind(data: cellData, delegate: self)
                
        cell.editBtnClicked = navToChallenge(_:)
        
        return cell
    }
    
        fileprivate func navToChallenge(_ cellData:Challenge?) {
                print("<#comment#> -", #fileID, #function, #line)
        
        self.selectedChallengeForChallengeBoardVC = cellData
        
        self.performSegue(withIdentifier: "navToChallengeBoard", sender: self)

    }
    
}

//MARK: - 화면이동 관련
extension MainListVC {
        
    /// AddChallengeVC으로 이동하라
    fileprivate func navigateToAddChallengeVC(){
        print(#fileID, #function, #line, "- ")
        
        let addChallegeStoryboard = UIStoryboard(name: "AddChallenge", bundle: Bundle.main)
        let addChallengeVC = addChallegeStoryboard.instantiateViewController(withIdentifier: "AddChallengeVC") as! AddChallengeVC
        
        
        self.navigationController?.pushViewController(addChallengeVC, animated: true)
    }
    
}

//MARK: - segue way 관련
extension MainListVC {
    
    // 받는 처리
    @IBAction func unwindToMain(unwindSegue: UIStoryboardSegue){
        print("unwindToMain : unwindSegue: \(unwindSegue.source.title)")

        if let challengeBoardVC = unwindSegue.source as? ChallengeBoardVC {
            print("from 챌린지 보드 입니다 ")

        }

        if let addChallengeVC = unwindSegue.source as? AddChallengeVC {


            print("addChallengeVC에서 넘어옴")

        }

    }

}



//MARK: - 테이블뷰 델리겟 관련

extension MainListVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath - \(indexPath.row)", #fileID, #function, #line)
    }
    
    
}

//MARK: - List 관련
extension MainListVC {
    
    
    /// 해당 아이템 삭제 -> 데이터 갱신 + UI 변경
    /// - Parameter id: 삭제할 아이디
    fileprivate func deleteAChallenge(id: UUID) {
        print(#fileID, #function, #line, "- ")
        // TODO: 해당 아이디로 찾아서 그녀석 지우기
        self.dataList = self.dataList.filter { $0.id != id }

        let dataListToBeStored = dataList.map{ ChallengeData(data: $0) }
        
        UserDefaultsManager.shared.setChallengeList(newList: dataListToBeStored)
        
        self.myTableView.reloadData()
    }
    
    enum AlertAction {
        case cancel
        case delete
    }
    
    /// 삭제 얼럿 띄우기
    /// - Parameter id: 삭제할 아이디
    ///
    fileprivate func showDeleteAlert(btnClicked : @escaping (AlertAction) -> Void){
        
        print(#fileID, #function, #line, "")
        
        let alert = UIAlertController(title: nil, message:"삭제 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
                // [1]
                let okAction = UIAlertAction(title: "삭제", style: .destructive) { (action) in
                    // 해당 셀을 삭제하는 방법
                    // 1. 현재의 셀의 위치를 파악한다. indexPath.row -> tableViewCell의 데이터소스에서 확인
                    // 2. 그 위치에 있는 셀을 삭제한다.
                    // 3. 리로드
                    
                    
                    // 데이터를 삭제하는 방법
                    // 1. 해당 셀에 들어오는 데이터를 파악한다. <- 여기서부터 막힘
                    // 2. 데이터의 id를 파악한다.
                    // 3-1. 해당 id를 가진 데이터를 제외하고 필터링해서 새로운 리스트 짜기
                    // 3-2. 해당 id를 지우기
                    // 4. 리로드
                    
                    // [2]
                    btnClicked(AlertAction.delete)
                }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: { _ in
            btnClicked(AlertAction.cancel)
        })
        
                alert.addAction(okAction)
                alert.addAction(cancelAction)

        self.present(alert, animated: true)
    }
}

//MARK: - 데이터 전달 델리겟 관련

// 리모콘으로 들어온 이벤트를 처리할께
//2. 델리겟 이벤트를 받는다고 설정
extension MainListVC: ChallengeDelegate{
    
    
    ///
    /// - Parameter id:
    func deleteChallenge(id: UUID) {
        print(#fileID, #function, #line, "- id: \(id)")
        showDeleteAlert(btnClicked: { (alertAction : AlertAction) in
            switch alertAction {
            case .delete: self.deleteAChallenge(id: id)
            case .cancel: print("취소됨")
            }
        })
    }
    
    func editChallenge(edited: Challenge) {
        print(#fileID, #function, #line, "- editChallenge edited:\(edited.screenShotAssetId)")
        
        // 1. 불러온 데이터의 위치를 파악한다.
        let editIndex = self.dataList.firstIndex { aData in
            aData.id == edited.id
        }
        guard let index = editIndex else { return }
       
        // 2. 수정된 데이터를 해당 위치에 교체한다.
        self.dataList[index] = edited
        
        
        let dataListToBeStored = dataList.map{ ChallengeData(data: $0) }
        
        UserDefaultsManager.shared.setChallengeList(newList: dataListToBeStored)
        
        // 3. 리로드
        self.myTableView.reloadData()
        
        
        print("\(edited)")
        
    }
        
    

        
    /// 추가된 챌린지 액션
    /// - Parameter added: 추가된 챌린지
    func addChallenge(added: Challenge) {
        print("added : \(added)", #fileID, #function, #line)
        
        print("added.screenShotAssetId : \(added.screenShotAssetId)", #fileID, #function, #line)
        
        self.dataList.insert(added, at: 0)
        
        let dataListToBeStored = dataList.map{ ChallengeData(data: $0) }
        
        UserDefaultsManager.shared.setChallengeList(newList: dataListToBeStored)
        
        self.myTableView.reloadData()
    }
    
    
    func dataSend() {
        print("MainVC - saveButtonClicked() called", #fileID, #function, #line)
        let addChallegeStoryboard = UIStoryboard(name: "AddChallenge", bundle: Bundle.main)
        let addChallengeVC = addChallegeStoryboard.instantiateViewController(withIdentifier: "AddChallengeVC") as! AddChallengeVC
        
        self.myTableView.reloadData()
        
        self.navigationController?.pushViewController(addChallengeVC, animated: true)
        
    }
}

