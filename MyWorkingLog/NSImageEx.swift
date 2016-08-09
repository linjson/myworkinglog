//
//  NSImageEx.swift
//  MyWorkingLog
//
//  Created by linjson on 16/7/29.
//  Copyright © 2016年 linjson. All rights reserved.
//

import Cocoa

extension NSImage {

//	func imageTintedWithColor(tint: NSColor) -> NSImage? {

//		let colorGenerator = CIFilter.init(name: "CIConstantColorGenerator");
//
//		let color = CIColor.init(color: tint);
//		colorGenerator?.setValue(color, forKey: kCIInputColorKey) ;
//		let colorFilter = CIFilter.init(name: "CIColorControls");
//		colorFilter?.setValue(colorGenerator?.valueForKey(kCIOutputImageKey), forKey: kCIInputImageKey);
//		colorFilter?.setValue(3.0, forKey: kCIInputSaturationKey);
//		colorFilter?.setValue(0.35, forKey: kCIInputBrightnessKey);
//		colorFilter?.setValue(1.0, forKey: kCIInputContrastKey);
//		let monochromeFilter = CIFilter.init(name: "CIColorMonochrome");
//		let baseImage = CIImage.init(data: self.TIFFRepresentation!);
//		monochromeFilter?.setValue(baseImage, forKey: kCIInputImageKey);
//		monochromeFilter?.setValue(CIColor.init(red: 0.75, green: 0.75, blue: 0.75), forKey: kCIInputColorKey);
//		monochromeFilter?.setValue(1.0, forKey: kCIInputIntensityKey);
//
//		let compositingFilter = CIFilter.init(name: "CIMultiplyCompositing");
//		compositingFilter?.setValue(colorFilter?.valueForKey(kCIOutputImageKey), forKey: kCIInputImageKey);
//		compositingFilter?.setValue(monochromeFilter?.valueForKey(kCIOutputImageKey), forKey: kCIInputBackgroundImageKey);
//
//		let outputImage = compositingFilter?.valueForKey(kCIOutputImageKey) as! CIImage;
//		let extend = outputImage.extent;
//		let size = self.size;
//		let tintedImage = NSImage.init(size: size);
//
//		tintedImage.lockFocus();
//		let contextRef = NSGraphicsContext.currentContext()?.CGContext;
//		let dic: [String: AnyObject]? = [kCIContextUseSoftwareRenderer: NSNumber.init(bool: true)];
//		let ciContext = CIContext.init(CGContext: contextRef!, options: dic);
//		let rect = CGRectMake(0, 0, size.width, size.height);
//		ciContext.drawImage(outputImage, inRect: rect, fromRect: extend);
//		tintedImage.unlockFocus();
//		return tintedImage;

//        NSImage *image = [self copy];
//
//            [image lockFocus];
//            [color set];
//            NSRect rect = NSZeroRect;
//            rect.size = image.size;
//            NSRectFillUsingOperation(rect, NSCompositeSourceAtop);
//            [image unlockFocus];
//

//	}
}

