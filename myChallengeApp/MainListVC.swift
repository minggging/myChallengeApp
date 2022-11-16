//
//  MainLIstVC.swift
//  myChallengeApp
//
//  Created by 정민경 on 2022/11/16.
//

import UIKit

class MainListVC: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    let labels = [" Day 1 ", " Day 2 ", " Day 3 "]
    let imgs = ["1","2","3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.dataSource = self
        myTableView.delegate = self
    }
    
    

    
}

//MARK: - 데이터 소스 관련

// tableview의 datasource와 delegate 등록
extension MainListVC: UITableViewDataSource {

// table row 갯수 (menu 배열의 갯수만큼)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
  
// 각 row 마다 데이터 세팅.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 첫 번째 인자로 등록한 identifier, cell은 as 키워드로 앞서 만든 custom cell class화 해준다.
        let cell = myTableView.dequeueReusableCell(withIdentifier: "MainListCell", for: indexPath) as! MainListCell
        
        // 위 작업을 마치면 커스텀 클래스의 outlet을 사용할 수 있다.
        cell.tableViewLabel.text = labels[indexPath.row]
        cell.tableViewImgView.image = UIImage(named: imgs[indexPath.row])

        
        return cell
    }
}
//MARK: - 테이블뷰 델리겟 관련

extension MainListVC: UITableViewDelegate{
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("indexPath - \(indexPath.row)", #fileID, #function, #line)
        }
    
    }

