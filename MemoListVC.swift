//
//  MemoListVC.swift
//  MyMemory
//
//  Created by 정성훈 on 2021/01/06.
//

import UIKit

// 옵셔널 처리해야할 곳. 처리를 어떻게 해야할지 고민 중
// 1. AppDelegate 객체 다운캐스팅
// 2. 재사용 큐에서 꺼낸 셀 다운 캐스팅
// 3. 셀 데이터 소스의 row.regdate 포스 언랩핑하는 부분
class MemoListVC: UITableViewController {
    // 앱 델리게이트 객체의 참조 정보 읽어오기
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.appDelegate.memolist.count
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // memolist 배열 데이터에서 주어진 행에 맞는 데이터를 꺼낸다
        let row = self.appDelegate.memolist[indexPath.row]
        
        // 이미지 속성이 비어있을 경우 'memoCell", 아니면 "memoCellWithImage"
        let cellId = row.image == nil ? "memoCell" : "memoCellWithImage"
        
        // 재사용 큐로부터 프로토타입 셀의 인스턴스를 전달받는다
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MemoCell
        
        // memoCell의 내용을 구성한다.
        cell.subject?.text = row.title
        cell.contents?.text = row.contents
        cell.img?.image = row.image
        
        // Date 타입의 날짜를 yyyy-MM-dd HH:mm:ss 포맷에 맞게 변경한다
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.regdate?.text = formatter.string(from: row.regdate!)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // memolist 배열에서 선택한 행에 맞는 데이터를 꺼낸다
        let row = self.appDelegate.memolist[indexPath.row]

        // 상세 화면의 인스턴스 생성
        guard let vc = self.storyboard?.instantiateViewController(identifier: "MemoRead") as? MemoReadVC else {
            return
        }
        
        // 값 전달 후 상세 화면으로 이동
        vc.param = row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 테이블 데이터를 다시 읽어들인다. 이에 따라 행을 구성하는 로직이 다시 실행됨
        self.tableView.reloadData()
    }
}
