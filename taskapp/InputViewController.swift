//
//  InputViewController.swift
//  taskapp
//
//  Created by 山中祐樹 on 2018/11/10.
//  Copyright © 2018 山中祐樹. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {
    
    @IBOutlet weak var tittleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryTextField: UITextField!  //カテゴリ用に追加
    
    var task: Task!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //背景をタップしたらdismissKeyboardメソッドを呼ぶ設定
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        tittleTextField.text = task.title
        contentsTextView.text = task.contents
        categoryTextField.text = task.category  //カテゴリ用に追加
        datePicker.date = task.date
    }
    
    @objc func dismissKeyboard(){
        //背景をタップするとキーボードを閉じる
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ViewController:ViewController = segue.destination as! ViewController
        // カテゴリ欄に入力されているデータをサーチバーで検索できるように引き渡しているつもりです
        ViewController.SearchBar.text = task.category
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //viewWillDisapper(_:)メソッドは遷移する際に画面が非表示になる時呼ばれるメソッド
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.tittleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.category = self.categoryTextField.text!  //カテゴリ用に追加
            self.task.date = self.datePicker.date
            self.realm.add(self.task, update: true)
        }
        setNotification(task: task)
        super.viewWillDisappear(animated)
    }
    
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        //タイトルと内容を設定（中身がない場合メッセージなしで音だけの通知になるので「（xxなし）」を表示する）
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default()
        
        //ローカル通知が発動するtrigger(日付マッチ)を作成
        let calender = Calendar.current
        let dateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        //identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content,trigger: trigger)
        
        //ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        //error が　nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
        center.add(request) { (error) in print(error ?? "ローカル通知登録　OK")
            
        }
        
        //未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/----------")
                print(request)
                print("/----------")
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
