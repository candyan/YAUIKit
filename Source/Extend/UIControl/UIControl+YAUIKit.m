//
//  UIControl+YAUIKit.m
//  YAUIKit
//
//  Created by liu yan on 9/17/13.
//  Copyright (c) 2013 Douban Inc. All rights reserved.
//

#import "UIControl+YAUIKit.h"
#import <objc/runtime.h>

static char actionBlockDictKey;

#define YA_IN_MASK(a,b) ((a & b) == b)

@implementation UIControl (YAUIKit)

- (void)addActionBlock:(YAActionBlock)block forControlEvents:(UIControlEvents)controlEvents
{
    for (NSNumber *controlEventNumber in [self _controlsEventArray]) {
        if (YA_IN_MASK(controlEvents, controlEventNumber.intValue)) {
            [[self _actionBlockDictionary] setObject:block forKey:controlEventNumber];
        }
    }
    
    if (YA_IN_MASK(controlEvents, UIControlEventAllEditingEvents)) {
        [self addTarget:self action:@selector(_touchedAllEditingEvents:forEvent:) forControlEvents:controlEvents];
    } else if (YA_IN_MASK(controlEvents, UIControlEventAllTouchEvents)) {
        [self addTarget:self action:@selector(_touchedAllTouchEvents:forEvent:) forControlEvents:controlEvents];
    } else if (YA_IN_MASK(controlEvents, UIControlEventEditingChanged)) {
        [self addTarget:self action:@selector(_touchedEditingChanged:forEvent:) forControlEvents:controlEvents];
    } else if (YA_IN_MASK(controlEvents, UIControlEventEditingDidBegin)) {
        [self addTarget:self action:@selector(_touchedEditingDidBegin:forEvent:) forControlEvents:controlEvents];
    } else if (YA_IN_MASK(controlEvents, UIControlEventEditingDidEnd)) {
        [self addTarget:self action:@selector(_touchedEditingDidEnd:forEvent:) forControlEvents:controlEvents];
    } else if (YA_IN_MASK(controlEvents, UIControlEventEditingDidEndOnExit)) {
        [self addTarget:self action:@selector(_touchedEditingDidEndOnExit:forEvent:) forControlEvents:controlEvents];
    } else if (YA_IN_MASK(controlEvents, UIControlEventTouchCancel)) {
        [self addTarget:self action:@selector(_touchedCancel:forEvent:) forControlEvents:controlEvents];
    } else if (YA_IN_MASK(controlEvents, UIControlEventTouchDown)) {
        [self addTarget:self action:@selector(_touchedDown:forEvent:) forControlEvents:controlEvents];
    } else if (YA_IN_MASK(controlEvents, UIControlEventTouchDownRepeat)) {
        [self addTarget:self action:@selector(_touchedDownRepeat:forEvent:) forControlEvents:controlEvents];
    } else if (YA_IN_MASK(controlEvents, UIControlEventTouchDragEnter)) {
        [self addTarget:self action:@selector(_touchedDragEnter:forEvent:) forControlEvents:controlEvents];
    } else if (YA_IN_MASK(controlEvents, UIControlEventTouchDragExit)) {
        [self addTarget:self action:@selector(_touchedDragExit:forEvent:) forControlEvents:controlEvents];
    } else if (YA_IN_MASK(controlEvents, UIControlEventTouchDragInside)) {
        [self addTarget:self action:@selector(_touchedDragInside:forEvent:) forControlEvents:controlEvents];
    } else if (YA_IN_MASK(controlEvents, UIControlEventTouchDragOutside)) {
        [self addTarget:self action:@selector(_touchedDragOutside:forEvent:) forControlEvents:controlEvents];
    } else if (YA_IN_MASK(controlEvents, UIControlEventTouchUpInside)) {
        [self addTarget:self action:@selector(_touchedUpInside:forEvent:) forControlEvents:controlEvents];
    } else if (YA_IN_MASK(controlEvents, UIControlEventTouchUpOutside)) {
        [self addTarget:self action:@selector(_touchedDragOutside:forEvent:) forControlEvents:controlEvents];
    } else if (YA_IN_MASK(controlEvents, UIControlEventValueChanged)) {
        [self addTarget:self action:@selector(_touchedValueChanged:forEvent:) forControlEvents:controlEvents];
    }
}

- (void)removeActionBlockForControlEvents:(UIControlEvents)controlEvents
{
    for (NSNumber *controlEventNumber in [self _controlsEventArray]) {
        if (YA_IN_MASK(controlEvents, controlEventNumber.intValue)) {
            [[self _actionBlockDictionary] removeObjectForKey:controlEventNumber];
        }
    }
}

#pragma mark - Private Methods

- (void)_touchedDown:(id)sender forEvent:(UIEvent *)event
{
    [self _callBlocksForControlEvent:UIControlEventTouchDown sender:sender event:event];
}

- (void)_touchedDownRepeat:(id)sender forEvent:(UIEvent *)event
{
    [self _callBlocksForControlEvent:UIControlEventTouchDownRepeat sender:sender event:event];
}

- (void)_touchedDragInside:(id)sender forEvent:(UIEvent *)event
{
    [self _callBlocksForControlEvent:UIControlEventTouchDragInside sender:sender event:event];
}

- (void)_touchedDragOutside:(id)sender forEvent:(UIEvent *)event
{
    [self _callBlocksForControlEvent:UIControlEventTouchDragOutside sender:sender event:event];
}

- (void)_touchedDragEnter:(id)sender forEvent:(UIEvent *)event
{
    [self _callBlocksForControlEvent:UIControlEventTouchDragEnter sender:sender event:event];
}

- (void)_touchedDragExit:(id)sender forEvent:(UIEvent *)event
{
    [self _callBlocksForControlEvent:UIControlEventTouchDragExit sender:sender event:event];
}

- (void)_touchedUpInside:(id)sender forEvent:(UIEvent *)event
{
    [self _callBlocksForControlEvent:UIControlEventTouchUpInside sender:sender event:event];
}

- (void)_touchedUpOutside:(id)sender forEvent:(UIEvent *)event
{
    [self _callBlocksForControlEvent:UIControlEventTouchUpOutside sender:sender event:event];
}

- (void)_touchedCancel:(id)sender forEvent:(UIEvent *)event
{
    [self _callBlocksForControlEvent:UIControlEventTouchCancel sender:sender event:event];
}

- (void)_touchedValueChanged:(id)sender forEvent:(UIEvent *)event
{
    [self _callBlocksForControlEvent:UIControlEventValueChanged sender:sender event:event];
}

- (void)_touchedEditingDidBegin:(id)sender forEvent:(UIEvent *)event
{
    [self _callBlocksForControlEvent:UIControlEventEditingDidBegin sender:sender event:event];
}

- (void)_touchedEditingChanged:(id)sender forEvent:(UIEvent *)event
{
    [self _callBlocksForControlEvent:UIControlEventEditingChanged sender:sender event:event];
}

- (void)_touchedEditingDidEnd:(id)sender forEvent:(UIEvent *)event
{
    [self _callBlocksForControlEvent:UIControlEventEditingDidEnd sender:sender event:event];
}

- (void)_touchedEditingDidEndOnExit:(id)sender forEvent:(UIEvent *)event
{
    [self _callBlocksForControlEvent:UIControlEventEditingDidEndOnExit sender:sender event:event];
}

- (void)_touchedAllTouchEvents:(id)sender forEvent:(UIEvent *)event
{
    [self _callBlocksForControlEvent:UIControlEventAllTouchEvents sender:sender event:event];
}

- (void)_touchedAllEditingEvents:(id)sender forEvent:(UIEvent *)event
{
    [self _callBlocksForControlEvent:UIControlEventAllEditingEvents sender:sender event:event];
}

- (void)_callBlocksForControlEvent:(UIControlEvents)controlEvent
                            sender:(id)sender
                             event:(UIEvent *)event
{
    YAActionBlock block = [[self _actionBlockDictionary] objectForKey:@(controlEvent)];
    if (block) {
        block(event);
    }
}

#pragma mark - Util
- (void)_setActionBlockDictionary:(NSMutableDictionary *)blocks
{
    objc_setAssociatedObject(self,
                             &actionBlockDictKey,
                             blocks,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)_actionBlockDictionary
{
    NSMutableDictionary *dictionary = objc_getAssociatedObject(self, &actionBlockDictKey);
    if (!dictionary) {
        dictionary = [NSMutableDictionary dictionary];
        [self _setActionBlockDictionary:dictionary];
    }
    return dictionary;
}

- (NSArray *)_controlsEventArray
{
    return @[@(UIControlEventValueChanged),
             @(UIControlEventTouchUpOutside),
             @(UIControlEventTouchUpInside),
             @(UIControlEventTouchDragOutside),
             @(UIControlEventTouchDragInside),
             @(UIControlEventTouchDragExit),
             @(UIControlEventTouchDragEnter),
             @(UIControlEventTouchDownRepeat),
             @(UIControlEventTouchDown),
             @(UIControlEventTouchCancel),
             @(UIControlEventSystemReserved),
             @(UIControlEventEditingDidEndOnExit),
             @(UIControlEventEditingDidEnd),
             @(UIControlEventEditingDidBegin),
             @(UIControlEventEditingChanged),
             @(UIControlEventApplicationReserved),
             @(UIControlEventAllTouchEvents),
             @(UIControlEventAllEvents),
             @(UIControlEventAllEditingEvents)];
}

@end
