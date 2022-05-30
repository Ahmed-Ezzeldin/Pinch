//
//  PageModel.swift
//  Pinch
//
//  Created by Cloud Secrets on 30/05/2022.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
