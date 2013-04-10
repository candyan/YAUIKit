//
//  PlaceHolderTextViewController.h
//  YAUIKit
//
//  Created by liu yan on 4/9/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceHolderTextViewController : UIViewController<UINavigationControllerDelegate>

@property (nonatomic, retain) IBOutlet UITextField *changeColorTextField;


- (IBAction)changePlaceHolderColor:(id)sender;

@end
