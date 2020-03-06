//
//  Constants.swift
//  quotidian
//
//  Created by Jake Correnti on 1/25/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

enum Colors {
    static var qBG            = #colorLiteral(red: 0.9582723699, green: 0.9582723699, blue: 0.9582723699, alpha: 1)
    static var qWhite         = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static var qDarkGrey      = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
    static var qPurple        = #colorLiteral(red: 0.6274509804, green: 0.6588235294, blue: 0.9529411765, alpha: 1)
    static var qCompleteGreen = #colorLiteral(red: 0.6431372549, green: 0.8705882353, blue: 0.7215686275, alpha: 1)
    static var qDeleteRed     = #colorLiteral(red: 0.8705882353, green: 0.6431372549, blue: 0.6431372549, alpha: 1)
    static var qLightPurple   = #colorLiteral(red: 0.8941176471, green: 0.9019607843, blue: 0.9882352941, alpha: 1)
    static var qLightGray     = UIColor(red: 239, green: 239, blue: 244, alpha: 1)
    static var qDeactivated   = #colorLiteral(red: 0.8196078431, green: 0.8196078431, blue: 0.8196078431, alpha: 1)
    
    static var qListRed       = #colorLiteral(red: 0.9529411765, green: 0.6274509804, blue: 0.6274509804, alpha: 1)
    static var qListOrange    = #colorLiteral(red: 0.9529411765, green: 0.7921568627, blue: 0.6274509804, alpha: 1)
    static var qListBlue      = #colorLiteral(red: 0.6274509804, green: 0.8666666667, blue: 0.9529411765, alpha: 1)
    static var qListPurple    = #colorLiteral(red: 0.6274509804, green: 0.6588235294, blue: 0.9529411765, alpha: 1)
    static var qListGreen     = #colorLiteral(red: 0.6274509804, green: 0.9529411765, blue: 0.6274509804, alpha: 1)
    static var qListGray      = #colorLiteral(red: 0.8274509804, green: 0.8274509804, blue: 0.8274509804, alpha: 1)
}

enum Images {
    static var checkMark       = "list.bullet.indent"
    static var plus            = "plus.circle.fill"
    static var circle          = "circle"
    static var completedCircle = "largecircle.fill.circle"
    static var bell            = "bell.circle.fill"
    static var list            = "line.horizontal.3.decrease.circle.fill"
    static var repeatRing      = "arrow.2.circlepath.circle.fill"
    static var timelapse       = "timelapse"
    static var xMark           = "xmark.circle.fill"
    static var trashcan        = "trash"
}

enum Cells {
    static var defaultCell        = "defaultCellID"
    static var textFieldCell      = "textFieldCellID"
    static var textViewCell       = "textViewCellID"
    static var timePickerCell     = "timePickerCellID"
    static var taskCell           = "taskCellID"
    static var completionCell     = "completionCellID"
    static var habitCell          = "habitCellID"
    static var textFieldImageCell = "textFieldWithImageCellID"
    static var listCell           = "listCellID"
    static var listInProgressCell = "listInProgressCellID"
}

 
