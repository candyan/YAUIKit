YAUIKit
=======

YAUIKit is a UIKit extension library, 

##Usage
###Install

Use [cocoapods-depend](https://github.com/candyan/cocoapods-depend) plugin:

	pod depend add YAUIKit

Or, add the dependency to your `Podfile`:

	pod 'YAUIKit'

Next, import the header file wherever your want to use it.

	#import <YAUIKit/YAUIKit.h>

##Feature

###UIColor Extension

color with hex number

	[UIColor colorWithHex:0x8031CCA]; // ARGB
	[UIColor colorWithHex:0x31CCAA];  // RGB

color mixing

	UIColor *redColor = [UIColor redColor];
	UIColor *maskColor = [UIColor colorWithHex:0x80000000];
	UIColor *mixingColor = [redColor colorByAddingColor:maskColor]; // red color with a 50% opacity black mask
	

	