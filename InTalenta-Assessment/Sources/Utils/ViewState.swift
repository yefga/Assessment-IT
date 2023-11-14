//
//  ViewState.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 10/11/23.
//

import Foundation

enum ViewState: Equatable {
    case loading, success(empty: Bool), failure, none, refresh, more
}
