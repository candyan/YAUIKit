//
//  YAActionSheet.h
//  YAUIKit
//
//  Created by liu yan on 4/10/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//
//  Thinks for PSActionSheet

#import <UIKit/UIKit.h>

@interface YAActionSheet : NSObject <UIActionSheetDelegate> {
@private
  UIActionSheet *_sheet;
  NSMutableArray *_blocks;
}

@property (nonatomic, retain, readonly) UIActionSheet *sheet;

+ (id)sheetWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title;

- (void)setCancelButtonWithTitle:(NSString *) title block:(void (^)()) block;
- (void)setDestructiveButtonWithTitle:(NSString *) title block:(void (^)()) block;
- (void)addButtonWithTitle:(NSString *) title block:(void (^)()) block;

- (void)showInView:(UIView *)view;
- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;

- (NSUInteger)buttonCount;

@end
