//
//  CustomColor.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/09.
//

import UIKit

enum CustomColor {
    static var CommitColorSet = CustomColor.GreenColorSet
    static let GreenColorSet = [UIColor(named: "BasicCommitGreen1"), UIColor(named: "BasicCommitGreen2"), UIColor(named: "BasicCommitGreen3")]
    static let SkyColorSet = [UIColor(named: "BasicCommitSky1"), UIColor(named: "BasicCommitSky2"), UIColor(named: "BasicCommitSky3")]
    static let RedColorSet = [UIColor(named: "BasicCommitRed1"), UIColor(named: "BasicCommitRed2"), UIColor(named: "BasicCommitRed3")]
    
    static func pickCustomColorSet(by key: String) -> [UIColor?] {
        switch key {
        case "GreenColorSet":
            return CustomColor.GreenColorSet
        case "SkyColorSet":
            return CustomColor.SkyColorSet
        case "RedColorSet":
            return CustomColor.RedColorSet
        default:
            return []
        }
    }
    
    static func getColorKey(by colorSet: [UIColor?]) -> String {
        switch colorSet {
        case CustomColor.GreenColorSet:
            return "GreenColorSet"
        case CustomColor.SkyColorSet:
            return "SkyColorSet"
        case CustomColor.RedColorSet:
            return "RedColorSet"
        default:
            return ""
        }
    }
}
