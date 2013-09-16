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

- (void) setFrameOriginPoint:(CGPoint)originPoint;
- (void) setFrameSize:(CGSize)size;

///-------------------------------------
/// Set UIView Each Bounds Property
///-------------------------------------
- (void) setBoundsOriginX:(CGFloat)originX;
- (void) setBoundsOriginY:(CGFloat)originY;

- (void) setBoundsWidth:(CGFloat)width;
- (void) setBoundsHeight:(CGFloat)height;

- (void) setBoundsOriginPoint:(CGPoint)originPoint;
- (void) setBoundsSize:(CGSize)size;

///-------------------------------------
/// UIView SubView 
///-------------------------------------
- (void) removeAllSubViews;

- (NSArray *) subviewsForClassName:(Class)className;

- (NSArray *) subviewsForClassName:(Class)className tag:(NSInteger)tag;

///-------------------------------------
/// Debugging
///-------------------------------------
- (void)logViewHierarchy;

@end
