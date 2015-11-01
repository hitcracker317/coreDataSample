//
//  ViewController.swift
//  coreDataSample
//
//  Created by 前田 晃良 on 2015/10/29.
//  Copyright (c) 2015年 A.M. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.read()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //すでに存在するデータの読み込み処理(保持しているデータを全件取得)。これは定型文なのでコピってしまえばよい
    //CRUDでいう「R」
    func read(){
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをappDelegateから作成
        if let managedObjectContext = appdelegate.managedObjectContext{
            
            let entity = NSEntityDescription.entityForName("ToDo", inManagedObjectContext: managedObjectContext) //Entityを取得(エンティティ名を指定)
            
            let fetchRequerst = NSFetchRequest(entityName: "ToDo") //エンティティ名を指定
            fetchRequerst.entity = entity
            
            var error:NSError? = nil //エラーが発生した際にキャッチするための変数
            
            //フェッチリクエスト(データの検索と取得処理)の実行
            if var results = managedObjectContext.executeFetchRequest(fetchRequerst, error: &error){
                
                for managedObject in results {
                    let todo = managedObject as! ToDo
                    println("title:\(todo.title), saveDate:\(todo.date)")
                }
            }
        }
    }
    
    @IBAction func saveContent(sender: AnyObject) {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //ENTITYの操作を制御するmanagedObjectContextをappDelegateから作成
        if let managedObjectContext = appdelegate.managedObjectContext{
            
            //新しくデータを作成するためのEntityを作成
            let managedObject:AnyObject = NSEntityDescription.insertNewObjectForEntityForName("ToDo", inManagedObjectContext: managedObjectContext)
            
            //TODO EntityからObjectを生成し、Atrrtibutesに接続した値を代入
            let todo = managedObject as! ToDo
            todo.title = "bbbbbb"
            todo.date = NSDate()
            
            
            //***** データの保存 ****//
            //CoreDataは少し特殊で上記でAttributedにデータを追加するだけでははすぐに保存処理はされない
            //一定期間において保存されるか、アプリを終了時にAppDelegateに定義してある
            //applicationWillTerminate()内のsaveContext()が発動した際に保存処理が実行される
            
            appdelegate.saveContext() //データの保存処理(これ忘れないでね！)
        }
    }
    
    @IBAction func deleteContent(sender: AnyObject) {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをappDelegateから作成
        if let managedObjectContext = appdelegate.managedObjectContext{
            
            let entity = NSEntityDescription.entityForName("ToDo", inManagedObjectContext: managedObjectContext) //Entityを取得(エンティティ名を指定)
            
            let fetchRequerst = NSFetchRequest(entityName: "ToDo") //エンティティ名を指定
            fetchRequerst.entity = entity
            
            //データを1件取得する
            let predicate = NSPredicate(format: "%K = %@","title","bbbbbb")
            fetchRequerst.predicate = predicate
            
            var error:NSError? = nil //エラーが発生した際にキャッチするための変数
            
            //フェッチリクエスト(データの検索と取得処理)の実行
            if var results = managedObjectContext.executeFetchRequest(fetchRequerst, error: &error){
                
                for managedObject in results {
                    let todo = managedObject as! ToDo
                    println("削除するデータ => title;\(todo.title), saveDate:\(todo.date)")
                    
                    //削除処理の本体
                    managedObjectContext.deleteObject(managedObject as! NSManagedObject)
                    
                    //削除したことも保存しておかないと反映されないよ！
                    appdelegate.saveContext()
                }
            }
        }
    }


}

