//
//  UIView+YAUIKit.h
//  YAUIKit
//
//  Created by liu yan on 4/7/13.
//
//

#import <UIKit/UIKit.h>

@interface UIView (YAUIKit)

///-------------------------------------
/// Set UIView Each Frame Property
///-------------------------------------
- (void) setFrameOriginX:(CGFloat)originX;
- (void) setFrameOriginY:(CGFloat)originY;

- (void) setFrameWidth:(CGFloat)width;
- (void) setFrameHeight:(CGFloat)height;

///-------------------------------------
/// Set UIView Each Bounds Property
///-------------------------------------
- (void) setBoundsOriginX:(CGFloat)originX;
- (void) setBoundsOriginY:(CGFloat)originY;

- (void) setBoundsWidth:(CGFloat)width;
- (void) setBoundsHeight:(CGFloat)height;

///-------------------------------------
/// UIView SubView 
///-------------------------------------
- (void) removeAllSubViews;

- (NSArray *) subviewsWithClassName:(Class)className;

@end
