//
//  ToDo.swift
//  coreDataSample
//
//  Created by 前田 晃良 on 2015/10/29.
//  Copyright (c) 2015年 A.M. All rights reserved.
//

import Foundation
import CoreData

class ToDo: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var date: NSDate

}
