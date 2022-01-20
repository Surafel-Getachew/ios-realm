//
//  Todo.swift
//  justdoit
//
//  Created by surafel getachew on 13/01/2022.
//

import Foundation
import RealmSwift

class Todo:Object {
    @Persisted var name:String = "";
    @Persisted var done:Bool = false;
    @Persisted(originProperty: "todos") var category: LinkingObjects<Category>
}

