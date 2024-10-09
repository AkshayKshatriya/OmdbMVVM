//
//  String+URLEncoding.swift
//  OmdbMVVM
//
//  Created by Akshay  on 08/10/24.
//

import Foundation

extension String {
    var urlEncoded: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
