//
//  PullRefreshViewController.m
//  YAUIKit
//
//  Created by liu yan on 4/16/13.
//  Copyright (c) 2013 liu yan. All rights reserved.
//

#import "PullRefreshViewController.h"

@interface PullRefreshViewController ()<UITableViewDataSource, UITableViewDelegate, YAPullRefreshDelegate> {
  YAPullRefreshController *_yprc;
  UILabel *_refreshHeaderView;
  UILabel *_refreshFooterView;
  
  NSMutableArray *_numberArray;
}

@end

@implementation PullRefreshViewController

#pragma mark -  init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  [_tableView setContentSize:self.view.bounds.size];
  [self setupPullRefreshController];
  [_tableView setDelegate:self];
  [_tableView setDataSource:self];
  _numberArray = [NSMutableArray array];
  
  [_yprc startRefreshWithDirection:kYARefreshDirectionTop animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  setup
- (void) setupPullRefreshController {
  _yprc = [[YAPullRefreshController alloc] initWithScrollView:_tableView refreshableDirection:(kYARefreshableDirectionTop | kYARefreshableDirectionButtom)];
  
  _refreshHeaderView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
  [_refreshHeaderView setBackgroundColor:[UIColor lightGrayColor]];
  [_refreshHeaderView setText:@"下拉刷新"];
  [_refreshHeaderView setFont:[UIFont systemFontOfSize:15.0]];
  [_refreshHeaderView setTextAlignment:UITextAlignmentCenter];
  [_yprc setPullRefreshHeaderView:_refreshHeaderView];
  
  _refreshFooterView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
  [_refreshFooterView setBackgroundColor:[UIColor lightGrayColor]];
  [_refreshFooterView setText:@"上拉加载更多"];
  [_refreshFooterView setFont:[UIFont systemFontOfSize:15.0]];
  [_refreshFooterView setTextAlignment:UITextAlignmentCenter];
  [_yprc setPullRefreshFooterView:_refreshFooterView];
  _yprc.delegate = self;
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_numberArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *cellIdentify = @"NumberCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
  }
  
  [cell.textLabel setText:[NSString stringWithFormat:@"%@", [_numberArray objectAtIndex:indexPath.row]]];
  return cell;
}

#pragma mark - refresh Method
- (void) refreshNumber {
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [_numberArray removeAllObjects];
    [_numberArray addObject:[NSNumber numberWithInteger:0]];
    sleep(2);
    dispatch_async(dispatch_get_main_queue(), ^{
      [_tableView reloadData];
      [_refreshHeaderView setText:@"下拉刷新"];
      [_yprc finishRefreshWithDirection:kYARefreshDirectionTop animated:YES complate:nil];
    });
  });
}

- (void) loadMoreNumber {
  dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [_numberArray addObject:[NSNumber numberWithInteger:[_numberArray count]]];
    sleep(2);
    dispatch_async(dispatch_get_main_queue(), ^{
      [_tableView reloadData];
      [_refreshFooterView setText:@"上拉加载更多"];
      [_yprc finishRefreshWithDirection:kYARefreshDirectionButtom animated:YES complate:nil];
    });
  });
}

#pragma mark - Pull Refresh Delegate
- (void)pullRefreshController:(YAPullRefreshController *)pullRefreshController canEngageRefreshDirection:(YARefreshDirection)direction {
  if (direction == kYARefreshableDirectionTop) {
    [_refreshHeaderView setText:@"放开即可刷新"];
  } else if (direction == kYARefreshableDirectionButtom) {
    [_refreshFooterView setText:@"放开即可加载更多"];
  }
}

- (void)pullRefreshController:(YAPullRefreshController *)pullRefreshController didDisengageRefreshDirection:(YARefreshDirection)direction {
  if (direction == kYARefreshableDirectionTop) {
    [_refreshHeaderView setText:@"下拉刷新"];
  } else if (direction == kYARefreshableDirectionButtom) {
    [_refreshFooterView setText:@"上拉加载更多"];
  }
}

- (void)pullRefreshController:(YAPullRefreshController *)pullRefreshController didEngageRefreshDirection:(YARefreshDirection)direction {
  if (direction == kYARefreshableDirectionTop) {
    [_refreshHeaderView setText:@"正在刷新..."];
    [self refreshNumber];
  } else if (direction == kYARefreshableDirectionButtom) {
    [_refreshFooterView setText:@"正在加载更多..."];
    [self loadMoreNumber];
  }
}

@end
