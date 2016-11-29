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
		return self.substring(to: self.characters.index(self.startIndex, offsetBy: len));
	}

	public func isNotNull() -> Bool {

		return self.characters.count != 0;

	}
}

extension NSString: CalculateTextSize {

	public func textSizeWithFont(_ font: NSFont, constrainedToSize size: CGSize) -> CGSize {

		let value = self;
		var textSize: CGSize!
		let attributes = [NSFontAttributeName: font];
		if size.equalTo(CGSize.zero) {
			textSize = value.size(withAttributes: attributes)
		} else {
			let option = NSStringDrawingOptions.usesLineFragmentOrigin
			let attributes = [NSFontAttributeName: font];
			let stringRect = value.boundingRect(with: size, options: option, attributes: attributes, context: nil)
			textSize = stringRect.size
		}
		return textSize
	}

}
