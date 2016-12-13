//
//  ViewSetModel.swift
//  myFirstSwift
//
//  Created by tiennguyen on 11/25/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Servers {
    let name: String
    let uuid: String
    let host: String
    let viewPort: Int
    let webPort: Int
    let user: String
    let plainPass: String
    let pass: String
    
    init(json: JSON) {
        name      = json["name"].stringValue
        uuid      = json["uuid"].stringValue
        host      = json["host"].stringValue
        viewPort  = json["viewPort"].intValue
        webPort   = json["webPort"].intValue
        user      = json["user"].stringValue
        plainPass = json["plainPass"].stringValue
        pass      = json["pass"].stringValue
    }
}

struct Row {
    let name: String
    init(json: JSON) {
        name = json["name"].stringValue
    }
}
struct Column {
    let name: String
    init(json: JSON) {
        name = json["name"].stringValue
    }
}
struct Camera {
    let col: Int
    let row: Int
    let enableName: Bool
    let name: String
    let uuid: String
    
    init(json: JSON) {
        col = json["col"].intValue
        row = json["row"].intValue
        enableName = json["enableName"].boolValue
        name = json["name"].stringValue
        uuid = json["uuid"].stringValue
    }
}

struct Page {
    let name: String
    let stretchMode: String
    let viewMode: String
    let colCount: Int
    let rowCount: Int
    let cameraCount: Int
    let rows: [Row]
    let cols: [Column]
    let cameras: [Camera]
    
    init(json: JSON) {
        name = json["name"].stringValue
        stretchMode = json[""].stringValue
        viewMode = json[""].stringValue
        colCount = json[""].intValue
        rowCount = json[""].intValue
        cameraCount = json[""].intValue
        rows = json["rows"].arrayValue.map {
            entry -> Row in return Row(json: entry)
        }
        cols = json["cols"].arrayValue.map {
            entry -> Column in return Column(json: entry)
        }
        cameras = json["cameras"].arrayValue.map {
            entry -> Camera in return Camera(json: entry)
        }
    }
}

struct ViewSetModel {
    let name: String
    let thumbInterval: Double
    let liveInterval: Double
    let servers: [Servers]
    let pages: [Page]
    
    init(json: JSON) {
        name = json["name"].stringValue
        thumbInterval = json["thumbInterval"].doubleValue
        liveInterval = json["liveInterval"].doubleValue
        servers = json["servers"].arrayValue.map {
            entry -> Servers in
            return Servers(json: entry)
        }
        pages = json["pages"].arrayValue.map {
            entry -> Page in
            return Page(json: entry)
        }
    }
}
