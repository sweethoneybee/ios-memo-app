//
//  MemoFormVC.swift
//  MyMemory
//
//  Created by 정성훈 on 2021/01/06.
//

import UIKit

class MemoFormVC: UIViewController {
    var subject: String!
    
    var x = "wow"
    
    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var preview: UIImageView!

    override func viewDidLoad() {
        self.contents.delegate = self
    }
    
    // 저장 버튼을 클릭했을 때 호출되는 메소드
    @IBAction func save(_ sender: Any) {
        // 내용을 입력하지 않았을 경우 경고한다
        guard self.contents.text?.isEmpty == false else {
            let alert = UIAlertController(title: nil, message: "내용을 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // MemoData 객체를 생성하고 데이터를 담는다
        let data = MemoData()
        
        data.title = self.subject // 제목
        data.contents = self.contents.text // 내용
//        NSLog("제목의 길이: \(self.subject.count)")
//        NSLog("콘텐츠: \(self.contents.text as NSString)")
//        data.contents = (self.contents.text as NSString).substring(from: self.subject.count) // 내용
        data.image = self.preview.image // 이미지
        data.regdate = Date() // 작성 시각
        
        // 앱 델리게이트 객체를 읽어온 다음, memolist 배열에 MemoData 객체를 추가
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memolist.append(data)
        
        // 작성폼 화면을 종료하고 이전화면으로 되돌아가기
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // 카메라 버튼을 클릭했을 때 호출되는 메소드
    @IBAction func pick(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "이미지를 가져올 곳을 선택해주세요", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "카메라", style: .default){(_) in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.allowsEditing = true
            
            self.present(picker, animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "저장앨범", style: .default){(_) in
            let picker = UIImagePickerController()
            picker.sourceType = .savedPhotosAlbum
            picker.delegate = self
            picker.allowsEditing = true
            
            self.present(picker, animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "사진 라이브러리", style: .default){(_) in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            
            self.present(picker, animated: true, completion: nil)
        })
        self.present(alert, animated: true)
    }
}

// MARK:- 이미지 피커 델리게이트 구현
extension MemoFormVC: UIImagePickerControllerDelegate {
    // 사용자가 이미지를 선택하면 자동으로 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 선택된 이미지를 미리보기에 출력
        self.preview.image = info[.editedImage] as? UIImage
        
        // 이미지 피커 컨트롤러를 닫기
        picker.dismiss(animated: true, completion: nil)
    }
}

extension MemoFormVC: UINavigationControllerDelegate {
}

// MARK:- 텍스트 뷰 델리게이트 구현
extension MemoFormVC: UITextViewDelegate {
    // 사용자가 텍스트 뷰에 뭔가를 입력하면 자동으로 이 메소드가 호출됨
    func textViewDidChange(_ textView: UITextView) {
        // 내용의 최대 15자리까지 읽어 subject 변수에 저장한다
        
        let contents = textView.text as NSString
        let length = ((contents.length > 15) ? 15 : contents.length)
        self.subject = contents.substring(with: NSRange(location: 0, length: length))
        
        // 내비게이션 타이틀에 표시
        self.navigationItem.title = self.subject
    }
}
