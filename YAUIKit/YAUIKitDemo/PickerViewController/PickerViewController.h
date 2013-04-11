//
//  PickerViewController.h
//  YAUIKit
//
//  Created by liu yan on 4/11/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *componentTextField;

- (IBAction)showPickerView:(id)sender;

@end
