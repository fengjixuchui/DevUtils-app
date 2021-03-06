//
//  HighlightedTextView.swift
//  DevUtils
//
//  Created by Tony Dinh on 10/11/20.
//  Copyright © 2020 Tony Dinh. All rights reserved.
//

import Foundation

import Cocoa
import Highlightr

class HighlightedTextView: CodeTextView {
  var highlightr: Highlightr! = Highlightr()
  var enableHighlight: Bool = true
  var language: String?
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setTheme()
    
    DistributedNotificationCenter.default.addObserver(
      self,
      selector: #selector(interfaceModeChanged(sender:)),
      name: NSNotification.Name(
        rawValue: "AppleInterfaceThemeChangedNotification"),
      object: nil)
  }
  
  func setLanguage(language: String) {
    self.language = language
  }
  
  func highlight() {
    if language == nil {
      return
    }
    
    if let attributedString = highlightr.highlight(self.string, as: language) {
      let mutableAttrString = NSMutableAttributedString.init(attributedString: attributedString)
      if let menlo = NSFont(name: AppState.TEXTVIEW_MONO_FONT, size: 12) {
        mutableAttrString.addAttributes([NSAttributedString.Key.font: menlo], range: .init(location: 0, length: mutableAttrString.length))
      }
      self.textStorage?.setAttributedString(mutableAttrString)
      refreshLineNumberView()
    }
  }
  
  private func setTheme() {
    if self.hasDarkAppearance {
      highlightr.setTheme(to: "paraiso-dark")
    } else {
      highlightr.setTheme(to: "paraiso-light")
    }
  }
  
  @objc
  func interfaceModeChanged(sender: NSNotification) {
    setTheme()
    highlight()
  }
  
  deinit {
    DistributedNotificationCenter.default().removeObserver(
      self,
      name: NSNotification.Name(
        rawValue: "AppleInterfaceThemeChangedNotification"),
      object: nil)
  }
}
