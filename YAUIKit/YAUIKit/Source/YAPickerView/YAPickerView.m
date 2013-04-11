//
//  YAPickerView.m
//  YAUIKit
//
//  Created by liu yan on 4/10/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "YAPickerView.h"
#import "YAToolKit.h"

@implementation YAPickerView

@dynamic component;
@synthesize pickerView = _pickerView;
@synthesize didPickerSelected = _didPickerSelected;

#pragma mark - init
- (id)initWithTitleArray:(NSArray *)titleArray  {
  self = [super init];
  if (self) {
    _componentArray = [NSMutableArray array];
    if (titleArray) {
      [_componentArray addObject:titleArray];
    }
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
    return (_pickerView.frame.size.width - 20) / [_componentArray count];
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
  _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, inView.frame.size.height, inView.frame.size.width, 216)];
  _pickerView.delegate = self;
  [_pickerView reloadAllComponents];
  [inView addSubview:_pickerView];
  [UIView animateWithDuration:.2f animations:^{
    [_pickerView setFrameOriginY:(inView.frame.size.height - _pickerView.frame.size.height)];
  }];
}

@end
