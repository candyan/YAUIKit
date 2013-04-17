//
//  YAPickerView.m
//  YAUIKit
//
//  Created by liu yan on 4/10/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "YAPickerView.h"
#import "YAToolKit.h"

@implementation YAPickerView {
  YAPickerView *_selfRetain;
}

@dynamic component;
@synthesize size = _size;
@synthesize pickerView = _pickerView;
@synthesize didPickerSelected = _didPickerSelected;
@synthesize pickerDelegate = _pickerDelegate;

#pragma mark - init
- (id)initWithTitleArray:(NSArray *)titleArray  {
  self = [super init];
  if (self) {
    _componentArray = [NSMutableArray array];
    if (titleArray &&
        [titleArray count] != 0) {
      [_componentArray addObject:titleArray];
    }
    _size = CGSizeMake([UIScreen mainScreen].bounds.size.width, 216);
  }
  return self;
}

- (void)dealloc {
  _pickerDelegate = nil;
  _pickerView.delegate = nil;
}

#pragma mark - Property
- (NSInteger)component {
  return [_componentArray count];
}

- (void)addComponentWithTitleArray:(NSArray *)titleArray {
  if (titleArray &&
      [titleArray count] != 0) {
    [_componentArray addObject:titleArray];
  }
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
  [_pickerView selectRow:row inComponent:component animated:animated];
}

#pragma mark - UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return [_componentArray count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  NSArray *titleArray = [_componentArray objectAtIndex:component];
  return [titleArray count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
  if ([_pickerDelegate respondsToSelector:@selector(pickerView:widthForComponent:)]) {
    return [_pickerDelegate pickerView:pickerView widthForComponent:component];
  } else {
    return (_pickerView.frame.size.width - 50) / [_componentArray count];
  }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
  if ([_pickerDelegate respondsToSelector:@selector(pickerView:rowHeightForComponent:)]) {
    return [_pickerDelegate pickerView:pickerView rowHeightForComponent:component];
  } else {
    return 44;
  }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  NSArray *titleArray = [_componentArray objectAtIndex:component];
  return [titleArray objectAtIndex:row];
}

#pragma mark - show
- (void)showInView:(UIView *)inView {
  _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake((inView.frame.size.width - _size.width) / 2,
                                                               inView.frame.size.height,
                                                               _size.width,
                                                               _size.height)];
  _pickerView.delegate = self;
  [_pickerView reloadAllComponents];
  _selfRetain = self;
  [inView addSubview:_pickerView];
  
  
  [_pickerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(finishPicker:)]];
  
  [UIView animateWithDuration:.2f animations:^{
    [_pickerView setFrameOriginY:(inView.frame.size.height - _pickerView.frame.size.height)];
  }];
}

#pragma mark - GR
- (void) finishPicker:(UITapGestureRecognizer *)gestureRecognizer {
  for (NSInteger index = 0; index < [_componentArray count]; index++) {
    if (_didPickerSelected) {
      BOOL complete = NO;
      if (index == [_componentArray count] - 1) {
        complete = YES;
      }
      _didPickerSelected([_pickerView selectedRowInComponent:index], index, complete);
    }
  }
  [UIView animateWithDuration:.2f animations:^{
    [_pickerView setFrameOriginY:_pickerView.superview.frame.size.height];
  } completion:^(BOOL finished) {
    [_pickerView removeFromSuperview];
    _selfRetain = nil;
  }];
}

@end
