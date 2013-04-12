//
//  YAAlertView.h
//  YAUIKit
//
//  Created by liu yan on 4/10/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//
//  Thinks for PSAlertView.

#import <UIKit/UIKit.h>

@interface YAAlertView : NSObject<UIAlertViewDelegate> {
@private
  UIAlertView *_alertView;
  NSMutableArray *_block;
  
}

+ (YAAlertView *)alertWithTitle:(NSString *)title;
+ (YAAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message;

- (id)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block;
- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block;

- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@property (nonatomic, strong) UIAlertView *alertView;

@end
