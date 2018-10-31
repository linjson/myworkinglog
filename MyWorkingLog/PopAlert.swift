//
//  PopAlert.swift
//  MyWorkingLog
//
//  Created by linjson on 16/8/3.
//  Copyright © 2016年 linjson. All rights reserved.
//

import Cocoa

class PopAlertWindow: NSWindow {

	override init(contentRect: NSRect, styleMask aStyle: NSWindow.StyleMask, backing bufferingType: NSWindow.BackingStoreType, defer flag: Bool) {
		super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, defer: flag);
//        self.styleMask = NSWindow.StyleMask.borderless;
		self.isOpaque = false;
		self.backgroundColor = NSColor.clear;
	}

	override func layoutIfNeeded() {
//		self.contentView?.layer?.renderInContext((NSGraphicsContext.currentContext()?.CGContext)!);
		let view = self.contentView;
		view?.wantsLayer = true;
//		view?.layer?.backgroundColor = NSColor.init(red: 1, green: 1, blue: 1, alpha: 0.5).CGColor;
		view?.layer?.borderWidth = 1;
		view?.layer?.borderColor = NSColor.init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00).cgColor;
		view?.layer?.cornerRadius = 10;
		view?.layer?.masksToBounds = true;

	}

//	required init?(coder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
//
//	override func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//		log("window");
//	}
}

enum PopAlertType: Int {
	case info = 0
	case success
	case error
	case copy
}

class PopAlert: NSWindowController, NSAnimationDelegate {

	@IBOutlet weak var backgroundView: NSImageView!
	@IBOutlet weak var iconView: NSImageView!
	var iconName: String!;
	static var pop: PopAlert!;
	var dismissTimer: Timer!;

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	required override init(window: NSWindow?) {
		super.init(window: window);
	}

	convenience init() {
		self.init(windowNibName: NSNib.Name("PopAlert"));
	}

	override func windowDidLoad() {

	}

	static func create(_ window: NSWindow?, with type: PopAlertType = .info) {
		if (pop == nil) {
			pop = PopAlert();
		}
		pop.setIconView(type);

		if (pop.window?.parent == nil) {
			pop.window?.parent?.removeChildWindow(pop.window!);
		}

		window?.addChildWindow(pop.window!, ordered: .above);
		pop.showWindow(window);
	}

	func setIconView(_ type: PopAlertType) {
		var name = "";
		switch type {
		case .success:
			name = "success";
		case .error:
			name = "fail";
		case .info:
			name = "info"
		case .copy:
			name = "copy";
		}

		iconName = name;
//

	}

	func updateWindowPosition() {
		guard let parentWin = self.window?.parent else {
			return;
		}

		guard let frame = self.window?.frame else {
			return;
		}

		let rect = parentWin.frame;
		self.window?.setFrameOrigin(NSMakePoint(NSMidX(rect) - NSWidth(frame) / 2, NSHeight(frame) - 20));

	}

	override func showWindow(_ sender: Any?) {

		self.window?.alphaValue = 0;
        iconView.image = NSImage.init(named: NSImage.Name( iconName!));

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

		dismissTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(dismiss), userInfo: nil, repeats: false);

	}

	@objc func dismiss(_ sender: AnyObject?) {
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

		let newImage = context.createCGImage(image, from: backgroundView.frame);

		backgroundView.image = NSImage.init(cgImage: newImage!, size: size);
	}

}
