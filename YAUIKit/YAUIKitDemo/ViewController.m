//
//  ViewController.m
//  YAUIKitDemo
//
//  Created by liu yan on 4/9/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "ViewController.h"
#import "ViewControllerHeader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}


#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YAUIKitCell"];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YAUIKitCell"];
  }
  
  switch (indexPath.row) {
    case 0: {
      [cell.textLabel setText:@"YA PlaceHolder TextView"];
      break;
    }
      
    case 1: {
      [cell.textLabel setText:@"AlertView & ActionSheet"];
      break;
    }
      
    case 2: {
      [cell.textLabel setText:@"Picker View"];
      break;
    }
      
    case 3: {
      [cell.textLabel setText:@"Toggle View"];
      break;
    }
    case 4:{
      [cell.textLabel setText:@"Search"];
      break;
    }
    case 5: {
      [cell.textLabel setText:@"Pull Refresh"];
      break;
    }
      
    default:
      break;
  }
  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UIViewController *pushViewController = nil;

  switch (indexPath.row) {
    case 0: {
      pushViewController = [[PlaceHolderTextViewController alloc] initWithNibName:@"PlaceHolderTextViewController" bundle:nil];
      break;
    }
      
    case 1: {
      pushViewController = [[AlertAndASViewController alloc] initWithNibName:@"AlertAndASViewController" bundle:nil];
      break;
    }
    case 2: {
      pushViewController = [[PickerViewController alloc] initWithNibName:@"PickerViewController" bundle:nil];
      break;
    }
      
    case 3: {
      pushViewController = [[ToggleViewController alloc] initWithNibName:nil bundle:nil];
      break;
    }
    case 4: {
      pushViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
      break;
    }
    case 5:{
      pushViewController = [[PullRefreshViewController alloc] initWithNibName:@"PullRefreshViewController" bundle:nil];
      break;
    }
      
    default:
      break;
  }
  
  [self.navigationController pushViewControllerWithDemoAnimation:pushViewController];
}

@end
