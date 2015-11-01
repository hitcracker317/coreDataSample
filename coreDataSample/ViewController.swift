//
//  ViewController.swift
//  coreDataSample
//
//  Created by 前田 晃良 on 2015/10/29.
//  Copyright (c) 2015年 A.M. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var todoTableView: UITableView!
    
    var todoArray:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.read()
    }
    
    //すでに存在するデータの読み込み処理(保持しているデータを全件取得)。これは定型文なのでコピってしまえばよい
    //CRUDでいう「R」
    func read(){
        
        todoArray = [] //配列を初期化
        
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
                    println("取得したデータ => title: \(todo.title), saveDate: \(todo.date)") //EntityのAttributeの値はプロパティの要領で取得
                    todoArray.addObject(todo.title)
                }
            }
        }
        todoTableView.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(todoArray[indexPath.row])"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Todoを削除
        
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Entityの操作を制御するmanagedObjectContextをappDelegateから作成
        if let managedObjectContext = appdelegate.managedObjectContext{
            
            let entity = NSEntityDescription.entityForName("ToDo", inManagedObjectContext: managedObjectContext) //Entityを取得(エンティティ名を指定)
            
            let fetchRequerst = NSFetchRequest(entityName: "ToDo") //どのエンティティを取得するのかを指定
            fetchRequerst.entity = entity
            
            //文字列を指定することで削除する対象のデータを取得する
            var todoString:String = todoArray[indexPath.row] as! String
            let predicate = NSPredicate(format: "%K = %@","title",todoString)
            fetchRequerst.predicate = predicate
            
            var error:NSError? = nil //エラーが発生した際にキャッチするための変数
            
            //フェッチリクエスト(データの検索と取得処理)の実行
            if var results = managedObjectContext.executeFetchRequest(fetchRequerst, error: &error){
                
                for managedObject in results {
                    let todo = managedObject as! ToDo
                    println("削除するデータ => title;\(todo.title), saveDate:\(todo.date)")
                    managedObjectContext.deleteObject(managedObject as! NSManagedObject) //削除処理の本体
                    appdelegate.saveContext() //削除したことも保存しておかないと反映されないよ！
                    todoArray.removeObjectAtIndex(indexPath.row)
                }
                
                self.read() //削除した後のデータを再読み込みする
            }
        }
    }
}

