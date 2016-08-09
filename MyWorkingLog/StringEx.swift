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
	func textSizeWithFont(font: NSFont, constrainedToSize size: CGSize) -> CGSize;
}

extension String: CalculateTextSize {
	public func textSizeWithFont(font: NSFont, constrainedToSize size: CGSize) -> CGSize {
		let temp: NSString = self;
		return temp.textSizeWithFont(font, constrainedToSize: size);
	}

	public func subString(len: Int) -> String {
		if (len >= self.characters.count || len < 0) {
			return self;
		}
		return self.substringToIndex(self.startIndex.advancedBy(len));
	}

	public func isNotNull() -> Bool {

		return self.characters.count != 0;

	}
}

extension NSString: CalculateTextSize {

	public func textSizeWithFont(font: NSFont, constrainedToSize size: CGSize) -> CGSize {

		let value = self;
		var textSize: CGSize!
		let attributes = [NSFontAttributeName: font];
		if CGSizeEqualToSize(size, CGSizeZero) {
			textSize = value.sizeWithAttributes(attributes)
		} else {
			let option = NSStringDrawingOptions.UsesLineFragmentOrigin
			let attributes = [NSFontAttributeName: font];
			let stringRect = value.boundingRectWithSize(size, options: option, attributes: attributes, context: nil)
			textSize = stringRect.size
		}
		return textSize
	}

}