//
//  ToDoViewController.swift
//  coreDataSample
//
//  Created by 前田 晃良 on 2015/11/01.
//  Copyright (c) 2015年 A.M. All rights reserved.
//

import UIKit

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
        
        
        todoTextView.resignFirstResponder();
        self.dismissViewControllerAnimated(true, completion: nil)
        return true;
    }
    
}
