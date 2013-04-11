//
//  YAPickerView.h
//  YAUIKit
//
//  Created by liu yan on 4/10/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidPickerSelected)(NSInteger row, NSInteger component, BOOL complete);

@interface YAPickerView : NSObject<UIPickerViewDataSource, UIPickerViewDelegate> {
  NSMutableArray *_componentArray;
  YAPickerView *_selfRetain;
}

@property (nonatomic, readonly) NSInteger component;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, copy) DidPickerSelected didPickerSelected;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, unsafe_unretained) id<UIPickerViewDelegate> pickerDelegate;

- (id) initWithTitleArray:(NSArray *)titleArray;

- (void) addComponentWithTitleArray:(NSArray *)titleArray;

- (void) selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;

- (void) showInView:(UIView *)inView;

@end
