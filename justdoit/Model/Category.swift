//
//  Category.swift
//  justdoit
//
//  Created by surafel getachew on 12/01/2022.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted (primaryKey: true) var _id:ObjectId
    @Persisted var name:String = "";
    @Persisted var todos:List<Todo>;
}
