//
//  Entity.swift
//  LearnRxSwift
//
//  Created by Thân Văn Thanh on 01/07/2021.
//

import Foundation
import RxSwift

struct DataGit : Codable {
    var total : Int?
    var items : [Items]?
    
    private enum Codingkeys : String , CodingKey{
        case total
        case result
    }
}

struct Items : Codable {
    var id : Int
    var login : String
    var avatar_url : String
    var html_url : String?
    
    private enum Codingkeys : String , CodingKey{
        case id
        case login
        case avatar_url
        case html_url
    }
    
}

