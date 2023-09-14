//
//  GITODOWidgetBundle.swift
//  GITODOWidget
//
//  Created by 강민수 on 2023/09/11.
//

import WidgetKit
import SwiftUI

@main
struct GITODOWidgetBundle: WidgetBundle {
    var body: some Widget {
        GITODOWidget()
        GITODOWidgetLiveActivity()
    }
}
