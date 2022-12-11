//
//  MainLIstVC.swift
//  myChallengeApp
//
//  Created by 정민경 on 2022/11/16.
//
import UIKit

class MainListVC: UIViewController {
    
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    var addBtnClicked : ((Challenge?) -> Void)? = nil
        
    var dataList : [Challenge] = [
        Challenge(title: "Day 1 ! 오늘의 챌린지는?", screenShot: UIImage(named: "사용팁"), content: "오늘의 노력에 대해서 적어주세요 ! ")]
    
    var mainDelegate: ChallengeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
                
        
        let addChallegeStoryboard = UIStoryboard(name: "AddChallenge", bundle: Bundle.main)
        let addChallengeVC = addChallegeStoryboard.instantiateViewController(withIdentifier: "AddChallengeVC") as! AddChallengeVC
        
        addChallengeVC.myAddDelegate = self
        
    } // viewDidLoad.
    
    // + 버튼을 누르면 챌린지 추가 화면으로 이동함
    @IBAction func onAddChallengeClicked(_ sender: Any) {
        print(#fileID, #function, #line, "- ")
        
        self.navigateToAddChallengeVC()
        
    }
    /*    //MARK: - delete Btn

        @IBAction func onDeleteBtnClicked(_ sender: UIButton) {
            print(#fileID, #function, #line, "- ")

            if let id = challengeData?.id {
                myDelegate?.deleteChallenge(id: id)
            }

    //        guard let id = challengeData?.id else {
    //            print("id 없음")
    //            return
    //        }
    //        myDelegate?.deleteChallenge(id: id)

            self.navigationController?.popViewController(animated: true)


        } */


    
    //MARK: - deleteBtn 관련
    @IBAction func deleteBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message:"삭제 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "삭제", style: .destructive) { (action) in
                   #warning("TODO : - 삭제 구현")

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
        
        // 위 작업을 마치면 커스텀 클래스의 outlet을 사용할 수 있다.
        cell.titleLabel.text = cellData.title
        cell.titleImage.image = cellData.screenShot
                
        cell.editBtnClicked = {[weak self] data in
            print("수정버튼 클릭됨 data:")
            self?.navigateToChallengeVC(data: cellData)
            
    
        }
        
        return cell
    }
    
    
}

//MARK: - 화면이동 관련
extension MainListVC {
    
    // 수정 전
    /// 챌린지 뷰컨으로 이동하라
    fileprivate func navigateToChallengeVC(data: Challenge){
        
        print(#fileID, #function, #line, "- ")
        // 이름이 ChallengeBoard 라는 UIStoryboard 파일 찾기
        let storyboard = UIStoryboard(name: "ChallengeBoard", bundle: Bundle.main)
        
        // 찾은 스토리보드에서 스토리보드 아이디가 ChallengeBoardVC 인 뷰컨을 가져와라
        let challengeBoardVC = storyboard.instantiateViewController(withIdentifier: "ChallengeBoardVC") as! ChallengeBoardVC
        
        // 챌린지보드뷰컨에 있는 doneBtnClicked(클로저)는
        // 매개변수로 challengeData를 받는다
        challengeBoardVC.doneBtnClicked = { challengeData in
            
            print("MainListVC - doneBtnClicked 완료. : \(challengeData)")
            
            // 옵셔널 언랩핑 및 데이터 추가
            if let data = challengeData{
                self.dataList.append(data)
            }
            
            // 데이터 추가 후 리로드
            self.myTableView.reloadData()
        }
        
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            challengeBoardVC.challengeData = data
        })
        
        challengeBoardVC.myDelegate = self
        
        // 네비게이션 컨트롤러 푸시함
        self.navigationController?.pushViewController(challengeBoardVC, animated: true)
        
    }
    
    fileprivate func navigateToChallengeVCWithImg(selectedData: UIImage?){
        print(#fileID, #function, #line, "- ")
        // 이름이 ChallengeBoard 라는 UIStoryboard 파일 찾기
        let storyboard = UIStoryboard(name: "ChallengeBoard", bundle: Bundle.main)
        
        // 찾은 스토리보드에서 스토리보드 아이디가 ChallengeBoardVC 인 뷰컨을 가져와라
        let challengeBoardVC = storyboard.instantiateViewController(withIdentifier: "ChallengeBoardVC") as! ChallengeBoardVC
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
        })
        
        // 네비게이션 컨트롤러 푸시함
        self.navigationController?.pushViewController(challengeBoardVC, animated: true)
        
    }
    
    
    
    
    /// AddChallengeVC으로 이동하라
    fileprivate func navigateToAddChallengeVC(){
        print(#fileID, #function, #line, "- ")
        
        let addChallegeStoryboard = UIStoryboard(name: "AddChallenge", bundle: Bundle.main)
        let addChallengeVC = addChallegeStoryboard.instantiateViewController(withIdentifier: "AddChallengeVC") as! AddChallengeVC
        
//        self.dataSend()
        
        // 3. 받는 쪽 (MainListVC) --- 보내는 쪽, 즉 리모콘 (AddChallengeVC.myAddDelegate)
        // 서로 연결
        addChallengeVC.myAddDelegate = self
        
        self.navigationController?.pushViewController(addChallengeVC, animated: true)
    }
    
}








//MARK: - 테이블뷰 델리겟 관련

extension MainListVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath - \(indexPath.row)", #fileID, #function, #line)
    }
    
    
}

//MARK: - 데이터 전달 델리겟 관련

// 리모콘으로 들어온 이벤트를 처리할께
//2. 델리겟 이벤트를 받는다고 설정
extension MainListVC: ChallengeDelegate{
    func editChallenge(edited: Challenge) {
        // 1. 불러온 데이터의 위치를 파악한다.
        let editIndex = self.dataList.firstIndex { aData in
            aData.id == edited.id
        }
        guard let index = editIndex else { return }
       
        // 2. 수정된 데이터를 해당 위치에 교체한다.
        self.dataList[index] = edited
        
        // 3. 리로드
        self.myTableView.reloadData()
        
        
        print("\(edited)")
        
    }
    
//    func deleteChallenge(delete: Challenge) {
//
//       let deleteIndex = self.dataList.firstIndex { aData in
//           aData.id == delete.id
//        }
//
//        guard let index = deleteIndex else { return }
//
////        self.dataList = self.dataList.filter { aData in
////            return aData.id != id
////        }
////        self.dataList = filteredDataList
//
//        self.dataList = self.dataList.filter { $0.id != delete.id }
//
//        self.myTableView.reloadData()
//
//    }
    
    

        
    /// 추가된 챌린지 액션
    /// - Parameter added: 추가된 챌린지
    func addChallenge(added: Challenge) {
        print("added : \(added)", #fileID, #function, #line)
        self.dataList.insert(added, at: 0)
//        self.dataList.append(added)
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
