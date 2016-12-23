//
//  NaihoChatMessengerModel.swift
//  myFirstSwift
//
//  Created by tiennguyen on 12/16/16.
//  Copyright © 2016 tiennguyen. All rights reserved.
//

import Foundation
import Firebase

struct NaihoChatMessengerModel {
    let id: String
    var user: NaihoUserModel?
    var messages: [NaihoMessageModel]?
    
    init(snapshot: FIRDataSnapshot) {
        self.id = snapshot.key
    }
}
