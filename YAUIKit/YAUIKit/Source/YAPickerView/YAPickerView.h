//
//  YAPickerView.h
//  YAUIKit
//
//  Created by liu yan on 4/10/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidPickerSelected)(NSInteger row, NSInteger component);

@interface YAPickerView : NSObject<UIPickerViewDataSource, UIPickerViewDelegate> {
  NSMutableArray *_componentArray;
}

@property (nonatomic, readonly) NSInteger component;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, copy) DidPickerSelected didPickerSelected;
@property (nonatomic, unsafe_unretained) id<UIPickerViewDelegate> pickerDelegate;

- (id) initWithTitleArray:(NSArray *)titleArray;

- (void) addComponentWithTitleArray:(NSArray *)titleArray;

- (void) showInView:(UIView *)inView;

@end
