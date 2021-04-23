//
//  List.swift
//   Today's tasks
//
//  Created by Дарья on 27.12.2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import Foundation


//FIXME: - 'NSKeyedUnarchiveFromData' should not be used to for un-archiving and will be removed in a future release

public class List: NSObject, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    var title: String
    var color: String
    
    init(title: String, color: String) {
        self.title = title
        self.color = color
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(of: [NSString.self], forKey: "title") as! String
        self.color = aDecoder.decodeObject(of: [NSString.self], forKey: "color") as! String
        
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(color, forKey: "color")
    }
}

class ListsData {
    static var lists: [List] = [List(title: "All tasks", color: "lightBlue"), List(title: "Work", color: "brightPeach"), List(title: "Chores", color: "dirtyPink"), List(title: "Hobby and selfcare", color: "green")]
}
