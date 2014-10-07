//
//  YAActionSheet.m
//  YAUIKit
//
//  Created by liu yan on 4/10/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "YAActionSheet.h"

@interface YAActionSheet ()
@property (nonatomic, retain, readwrite) UIActionSheet *sheet;
@end

@implementation YAActionSheet {
  YAActionSheet *_selfRetain;
}

@synthesize sheet = _sheet;

+ (id)sheetWithTitle:(NSString *)title {
  return [[YAActionSheet alloc] initWithTitle:title];
}


- (id)initWithTitle:(NSString *)title {
  if ((self = [super init])) {
    // Create the action sheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    self.sheet = actionSheet;    
    // Create the blocks storage for handling all button actions
    _blocks = [NSMutableArray array];
    _selfRetain = self;
  }
  
  return self;
}

- (void) dealloc {
  self.sheet.delegate = nil;
}

- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)())block {
  assert([title length] > 0 && "sheet destructive button title must not be empty");
  
  [self addButtonWithTitle:title block:block];
  _sheet.destructiveButtonIndex = (_sheet.numberOfButtons - 1);
}

- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block {
  assert([title length] > 0 && "sheet cancel button title must not be empty");
  
  [self addButtonWithTitle:title block:block];
  _sheet.cancelButtonIndex = (_sheet.numberOfButtons - 1);
}

- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block {
  assert([title length] > 0 && "cannot add button with empty title");
  
  if (block) {
    [_blocks addObject:block];
  }
  else {
    [_blocks addObject:[NSNull null]];
  }
  
  [_sheet addButtonWithTitle:title];
}

- (void)showInView:(UIView *)view {
  [_sheet showInView:view];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated {
  [_sheet showFromBarButtonItem:item animated:animated];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated {
  [_sheet showFromRect:rect inView:view animated:animated];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  // Run the button's block
  if (buttonIndex >= 0 && buttonIndex < [_blocks count]) {
    id obj = [_blocks objectAtIndex:buttonIndex];
    if (![obj isEqual:[NSNull null]]) {
      ((void (^)())obj)();
    }
  }
  _selfRetain = nil;
}

- (NSUInteger)buttonCount {
  return [_blocks count];
}

@end
