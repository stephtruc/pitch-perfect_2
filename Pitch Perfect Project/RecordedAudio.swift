//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Stephanie Truchan on 3/24/15.
//  Copyright (c) 2015 Stephanie Truchan. All rights reserved.
//

import Foundation

class RecordedAudio : NSObject {
    
    var filePathUrl: NSURL!
    var title: String!

    // Initialize variables
    init(filePathUrl: NSURL, title: String){
      self.filePathUrl = filePathUrl
      self.title = title
    
    }

    
}