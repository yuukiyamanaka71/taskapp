//
//  Task.swift
//  taskapp
//
//  Created by 山中祐樹 on 2018/11/10.
//  Copyright © 2018 山中祐樹. All rights reserved.
//

import RealmSwift

class Task: Object {
    //管理用ID。プライマリーキー
    @objc dynamic var id = 0
    
    //タイトル
    @objc dynamic var title = ""
    
    //内容
    @objc dynamic var contents = ""
    
    //日時
    @objc dynamic var date = Date()
    
    //カテゴリ
    @objc dynamic var category = ""  //カテゴリ用に追加
    
    /**idをプライマリーキーとして設定*/
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
