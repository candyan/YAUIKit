//
//  YAPickerView.h
//  YAUIKit
//
//  Created by liu yan on 4/10/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YAPickerView : NSObject<UIPickerViewDataSource, UIPickerViewDelegate, UIPopoverControllerDelegate> {
  NSMutableArray *_componentArray;
}

@property (nonatomic, readonly) NSInteger component;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, copy) void(^didPickerSelected)(NSInteger row, NSInteger component, BOOL complete);
@property (nonatomic, assign) CGSize size;
@property (nonatomic, unsafe_unretained) id<UIPickerViewDelegate> pickerDelegate;

- (id) initWithTitleArray:(NSArray *)titleArray;

- (void) addComponentWithTitleArray:(NSArray *)titleArray;

- (void) selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;

- (void) showInView:(UIView *)inView;
- (void) showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;

@end
