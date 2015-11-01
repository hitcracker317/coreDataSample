//
//  ToDoViewController.swift
//  coreDataSample
//
//  Created by 前田 晃良 on 2015/11/01.
//  Copyright (c) 2015年 A.M. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var todoTextView: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        todoTextView.delegate = self
        todoTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //saveして保存
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //ENTITYの操作を制御するmanagedObjectContextをappDelegateから作成
        if let managedObjectContext = appdelegate.managedObjectContext{
            
            //新しくデータを作成するためのEntityを作成
            let managedObject:AnyObject = NSEntityDescription.insertNewObjectForEntityForName("ToDo", inManagedObjectContext: managedObjectContext)
            
            //TODO EntityからObjectを生成し、Atrrtibutesに接続した値を代入
            let todo = managedObject as! ToDo
            todo.title = todoTextView.text
            todo.date = NSDate()
            
            //CoreDataはapplicationWillTerminate()内のsaveContext()が発動した際に保存処理が実行される
            appdelegate.saveContext() //データの保存処理(これ忘れないでね！)
            
            println("saved")
        }

        todoTextView.resignFirstResponder();
        self.dismissViewControllerAnimated(true, completion: nil)
        return true;
    }
    
}
