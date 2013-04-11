//
//  PickerViewController.m
//  YAUIKit
//
//  Created by liu yan on 4/11/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "PickerViewController.h"

#import "YAPickerView.h"
#import "YAAlertView.h"

@interface PickerViewController () {
  NSArray *_titleArray;
  NSString *_alertContent;
}

@end

@implementation PickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      _titleArray = [NSArray arrayWithObjects:@"星期日", @"星期一", @"星期二" ,@"星期三" ,@"星期四" ,@"星期五" , @"星期六",  nil];
      _alertContent = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPickerView:(id)sender {
  [_componentTextField resignFirstResponder];
  YAPickerView *pickerView = [[YAPickerView alloc] initWithTitleArray:_titleArray];
  if ([_componentTextField.text integerValue] > 1) {
    for (NSInteger index = 1; index < [_componentTextField.text integerValue]; index++) {
      [pickerView addComponentWithTitleArray:_titleArray];
    }
  }
  [pickerView showInView:self.view];
  [pickerView setDidPickerSelected:^(NSInteger row, NSInteger component, BOOL complete){
    if (component == 0) {
      _alertContent = [_titleArray objectAtIndex:row];
    } else {
      _alertContent = [_alertContent stringByAppendingFormat:@" / %@", [_titleArray objectAtIndex:row]];
    }
    if (complete) {
      YAAlertView *alert = [YAAlertView alertWithTitle:@"" message:_alertContent];
      [alert setCancelButtonWithTitle:@"取消" block:nil];
      [alert show];
    }
  }];
}
- (void)viewDidUnload {
  [self setComponentTextField:nil];
  [super viewDidUnload];
}
@end
