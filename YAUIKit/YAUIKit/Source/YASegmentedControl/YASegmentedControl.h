//
//  YASegmentedControl.h
//  YAUIKit
//
//  Created by liu yan on 6/11/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger
{
  kYASegmentedControlModeSticky = 1 << 0,
  kYASegmentedControlModeButton = 1 << 1,
  kYASegmentedControlModeMultipleSelectionable = 1 << 2,
} YASegmentedControlMode;

@interface YASegmentedControl : UIControl

@property (nonatomic, strong) NSArray *buttonsArray;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIImage *separatorImage;
@property (nonatomic, strong) NSIndexSet *selectedIndexes;
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
@property (nonatomic, assign) YASegmentedControlMode segmentedControlMode;

- (void)setSelectedIndex:(NSUInteger)index;
- (void)setSelectedIndexes:(NSIndexSet *)indexSet byExpandingSelection:(BOOL)expandSelection;

@end
