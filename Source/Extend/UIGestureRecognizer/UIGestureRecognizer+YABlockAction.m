//
//  UIGestureRecognizer+YABlockAction.m
//
//
//  Created by liuyan on 6/19/15.
//
//

#import "UIGestureRecognizer+YABlockAction.h"
#import <objc/runtime.h>

@implementation UIGestureRecognizer (YABlockAction)

- (void)addAction:(void (^)(UIGestureRecognizer *))actionBlock
{
    [self addTarget:self action:@selector(ya_gestureRecognizerActionHandler:)];
    objc_setAssociatedObject(self, @selector(addAction:), [actionBlock copy], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)ya_gestureRecognizerActionHandler:(UIGestureRecognizer *)gestureRecognizer
{
    YAGestureRecognizerActionBlock block = objc_getAssociatedObject(self, @selector(addAction:));
    if (block) {
        block(gestureRecognizer);
    }
}

@end
