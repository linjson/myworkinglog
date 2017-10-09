//
//  StringEx.swift
//  MyWorkingLog
//
//  Created by linjson on 16/7/21.
//  Copyright © 2016年 linjson. All rights reserved.
//
import Cocoa
import Foundation

public protocol CalculateTextSize {
	func textSizeWithFont(_ font: NSFont, constrainedToSize size: CGSize) -> CGSize;
}

extension String: CalculateTextSize {
	public func textSizeWithFont(_ font: NSFont, constrainedToSize size: CGSize) -> CGSize {
		let temp: NSString = self as NSString;
		return temp.textSizeWithFont(font, constrainedToSize: size);
	}

	public func subString(_ len: Int) -> String {
		if (len >= self.characters.count || len < 0) {
			return self;
		}
        
        let range=self.index(self.startIndex,offsetBy:len);
        let id = self[...range];
        
        return String(id);

	}

	public func isNotNull() -> Bool {

		return self.characters.count != 0;

	}
}

extension NSString: CalculateTextSize {

	public func textSizeWithFont(_ font: NSFont, constrainedToSize size: CGSize) -> CGSize {

		let value = self;
		var textSize: CGSize!
		let attributes = [NSAttributedStringKey.font: font];
		if size.equalTo(CGSize.zero) {
			textSize = value.size(withAttributes: attributes)
		} else {
			let option = NSString.DrawingOptions.usesLineFragmentOrigin
			let attributes = [NSAttributedStringKey.font: font];
			let stringRect = value.boundingRect(with: size, options: option, attributes: attributes, context: nil)
			textSize = stringRect.size
		}
		return textSize
	}

}
