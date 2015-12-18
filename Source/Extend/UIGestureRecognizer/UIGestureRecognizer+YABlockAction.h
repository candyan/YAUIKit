//
//  UIGestureRecognizer+YABlockAction.h
//
//
//  Created by liuyan on 6/19/15.
//
//

#import <UIKit/UIKit.h>

typedef void (^YAGestureRecognizerActionBlock)(UIGestureRecognizer *gestureRecognizer);

@interface UIGestureRecognizer (YABlockAction)

- (void)addAction:(YAGestureRecognizerActionBlock)actionBlock;

@end
