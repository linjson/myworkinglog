//
//  PopAlert.swift
//  MyWorkingLog
//
//  Created by linjson on 16/8/3.
//  Copyright © 2016年 linjson. All rights reserved.
//

import Cocoa

class PopAlertWindow: NSWindow {

	override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, defer flag: Bool) {
		super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, defer: flag);
		self.styleMask = NSBorderlessWindowMask;
		self.opaque = false;
		self.backgroundColor = NSColor.clearColor();
	}

	override func layoutIfNeeded() {
//		self.contentView?.layer?.renderInContext((NSGraphicsContext.currentContext()?.CGContext)!);
		let view = self.contentView;
		view?.wantsLayer = true;
//		view?.layer?.backgroundColor = NSColor.init(red: 1, green: 1, blue: 1, alpha: 0.5).CGColor;
		view?.layer?.borderWidth = 1;
		view?.layer?.borderColor = NSColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00).CGColor;
		view?.layer?.cornerRadius = 10;
		view?.layer?.masksToBounds = true;

	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		log("window");
	}
}

enum PopAlertType: Int {
	case Info = 0
	case Success
	case Error
	case Copy
}

class PopAlert: NSWindowController, NSAnimationDelegate {

	@IBOutlet weak var backgroundView: NSImageView!
	@IBOutlet weak var iconView: NSImageView!
	var iconName: String!;
	static var pop: PopAlert!;
	var dismissTimer: NSTimer!;

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	required override init(window: NSWindow?) {
		super.init(window: window);
	}

	init() {
		self.init(windowNibName: "PopAlert");
	}

	override func windowDidLoad() {

	}

	static func create(window: NSWindow?, with type: PopAlertType = .Info) {
		if (pop == nil) {
			pop = PopAlert();
		}
		pop.setIconView(type);

		if (pop.window?.parentWindow == nil) {
			pop.window?.parentWindow?.removeChildWindow(pop.window!);
		}

		window?.addChildWindow(pop.window!, ordered: .Above);
		pop.showWindow(window);
	}

	func setIconView(type: PopAlertType) {
		var name = "";
		switch type {
		case .Success:
			name = "success";
		case .Error:
			name = "fail";
		case .Info:
			name = "info"
		case .Copy:
			name = "copy";
		}

		iconName = name;
//

	}

	func updateWindowPosition() {
		guard let parentWin = self.window?.parentWindow else {
			return;
		}

		guard let frame = self.window?.frame else {
			return;
		}

		let rect = parentWin.frame;
		self.window?.setFrameOrigin(NSMakePoint(NSMidX(rect) - NSWidth(frame) / 2, NSHeight(frame) - 20));

	}

	override func showWindow(sender: AnyObject?) {

		self.window?.alphaValue = 0;
		iconView.image = NSImage.init(named: iconName);

		super.showWindow(sender);
		setBackground();
		updateWindowPosition();

		self.window?.animator().alphaValue = 1;

		delayClose();
	}

	func delayClose() {

		if (dismissTimer != nil) {
			dismissTimer.invalidate();
		}
//        dismissTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(dismiss:) userInfo:nil repeats:NO];

		dismissTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(dismiss), userInfo: nil, repeats: false);

	}

	func dismiss(sender: AnyObject?) {
		self.window?.animator().alphaValue = 0;
	}

	func setBackground() {
//        let filter: CIFilter = CIFilter.init(name: "CIGaussianBlur")!;
//
//        filter.setValue(image, forKey: kCIInputImageKey);
//
//        filter.setValue(5.0, forKey: "inputRadius");
//
//        let result = filter.valueForKey(kCIOutputImageKey) as! CIImage

		let size = backgroundView.frame.size;

		let context = CIContext(options: nil);
		let image = CIImage.init(color: CIColor.init(red: 1, green: 1, blue: 1, alpha: 0.8));

		let newImage = context.createCGImage(image, fromRect: backgroundView.frame);

		backgroundView.image = NSImage.init(CGImage: newImage, size: size);
	}

}
