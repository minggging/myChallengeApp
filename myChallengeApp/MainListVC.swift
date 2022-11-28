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
        Challenge(title: "Day 3", screenShot: UIImage(named: "1"), content: "컨텐츠 : Day 3"),
        Challenge(title: "Day 2", screenShot: UIImage(named: "2"), content: "컨텐츠 : Day 2"),
        Challenge(title: "Day 1", screenShot: UIImage(named: "3"), content: "컨텐츠 : Day 1")
        
        
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        
        
    }
    
    // + 버튼을 누르면 챌린지 추가 화면으로 이동함
    @IBAction func onAddChallengeClicked(_ sender: Any) {
        print(#fileID, #function, #line, "- ")
        
        self.navigateToAddChallengeVC()
        
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
        
        let currentTitle = cellData.title
        let currentImg = cellData.screenShot
        
        cell.missionBtnClicked = {[weak self] data in
            print("미션버튼 클릭됨 data:")
            self?.navigateToChallengeVC(title: currentTitle, image: currentImg)
        }
        
        return cell
    }
    
    
}

//MARK: - 화면이동 관련
extension MainListVC {
    
    // 수정 전
    /// 챌린지 뷰컨으로 이동하라
    fileprivate func navigateToChallengeVC(title: String, image: UIImage?){

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
        
        
        let challengeData = Challenge(title: title,
                                      screenShot: image,
                                      content: self.dataList[0].content)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            challengeBoardVC.challengeData = challengeData
        })
        
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
        
        
        addChallengeVC.saveBtnClicked = { challengeData in
            
            print("AddChallengeVC - saveBtnClicked 완료.")
            print("추가 전 dataList : \(self.dataList)")
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                
                // 옵셔널 언랩핑 및 데이터 추가
                if let data = challengeData{
                    self.dataList.insert(data, at: 0)
                }
                
                print("mainListVC에 데이터 추가 완료.")
                print("추가 후 dataList : \(self.dataList)")
                
                // 데이터 추가 후 리로드
                self.myTableView.reloadData()
                
                print("테이블뷰 데이터 리로드 완료")
            }
            )}
        
        
        let challengeData = Challenge(title: addChallengeVC.challengeData?.title ?? "",
                                      screenShot: addChallengeVC.challengeData?.screenShot ?? UIImage(systemName: "camera.badge.ellipsis"),
                                      content: addChallengeVC.challengeData?.content ?? "내용을 입력해주세요.")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            addChallengeVC.challengeData = challengeData
            
        })

        
                
        self.navigationController?.pushViewController(addChallengeVC, animated: true)
        
        
    }
    
}








//MARK: - 테이블뷰 델리겟 관련

extension MainListVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath - \(indexPath.row)", #fileID, #function, #line)
    }
    
    
}

