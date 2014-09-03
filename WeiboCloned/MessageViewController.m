//
//  MessageViewController.m
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-23.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "MessageViewController.h"


@interface MessageViewController ()

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"消息"];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (CurrentVersion() < 7.0) {
        _height = 0;
    }
    else{
        _height = 65;
    }
    
    self.tableView = [[MessageTableView alloc] initWithFrame:CGRectMake(0, _height, ScreenWidth, ScreenHeight - 44 - 20 - 45) style:UITableViewStyleGrouped];
    self.tableView.textArray = @[@"@我的",@"评论",@"赞"];
    self.tableView.imageArray = @[@"messagescenter_at@2x.png",@"messagescenter_comments@2x.png",@"messagescenter_good@2x.png"];
    self.tableView.refreshHeader = NO;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
}
@end
