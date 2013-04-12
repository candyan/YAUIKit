//
//  YAAlertView.m
//  YAUIKit
//
//  Created by liu yan on 4/10/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "YAAlertView.h"

@implementation YAAlertView {
  YAAlertView *_selfRetain;
}

@synthesize alertView = _alertView;

#pragma mark - Static

+ (YAAlertView *)alertWithTitle:(NSString *)title; {
  return [[YAAlertView alloc] initWithTitle:title message:nil];
}

+ (YAAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message; {
  return [[YAAlertView alloc] initWithTitle:title message:message];
}

#pragma mark - NSObject

- (id)initWithTitle:(NSString *)title message:(NSString *)message {
  self = [super init];
  if (self) {
    _alertView = [[UIAlertView alloc] initWithTitle:title
                                       message:message
                                      delegate:self
                             cancelButtonTitle:nil
                             otherButtonTitles:nil];
    _block = [NSMutableArray array];
    _selfRetain = self;
  }
  
  return self;
}

- (void)dealloc {
  _alertView.delegate = nil;
}

#pragma mark - Public

- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block {
  assert([title length] > 0 && "cannot set empty button title");
  
  [self addButtonWithTitle:title block:block];
  _alertView.cancelButtonIndex = (_alertView.numberOfButtons - 1);
}

- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block {
  assert([title length] > 0 && "cannot add button with empty title");
  
  if (block) {
    [_block addObject:[block copy]];
  }
  else {
    [_block addObject:[NSNull null]];
  }
  
  [_alertView addButtonWithTitle:title];
}

- (void)show {
  [_alertView show];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
  [_alertView dismissWithClickedButtonIndex:buttonIndex animated:animated];
  [self alertView:_alertView clickedButtonAtIndex:buttonIndex];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  /* Run the button's block */
  if (buttonIndex >= 0 && buttonIndex < [_block count]) {
    id obj = [_block objectAtIndex: buttonIndex];
    if (![obj isEqual:[NSNull null]]) {
      ((void (^)())obj)();
    }
  }
  _selfRetain = nil;
}

@end
