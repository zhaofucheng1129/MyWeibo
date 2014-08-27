//
//  DetailViewController.m
//  WeiboCloned
//
//  Created by ZhaoFucheng on 14-8-14.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "Status.h"
#import "StatusView.h"
#import "UIUtils.h"
#import "RegexKitLite.h"
#import "CommentTableView.h"
#import "SinaDataService.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    self.tableView.eventDelegate = self;
    NSString *idstr = _statusData.idstr;
    [self loadCommentsDataWithId:idstr SinceId:@"0" MaxId:@"0"];
}

- (void)initView
{
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    
    [tableHeaderView addSubview:self.statusHeaderView];
    
    NSString *userImageUrl = self.statusData.user.profile_image_url;
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:userImageUrl]];
    
    self.screenNameLabel.text = self.statusData.user.screen_name;
    
    _sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _sourceLabel.backgroundColor = [UIColor clearColor];
    _sourceLabel.textColor = [UIColor grayColor];
    [self.statusHeaderView addSubview:_sourceLabel];
    
    _createLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _createLabel.backgroundColor = [UIColor clearColor];
    _createLabel.textColor = [UIColor grayColor];
    [self.statusHeaderView addSubview:_createLabel];
    
    
    //微博发布时间
    [_createLabel setFrame:CGRectMake(54, 28, 200, 20)];
    _createLabel.font = [UIFont systemFontOfSize:10.0f];
    NSString *createTime = self.statusData.created_at;
    if (createTime != nil) {
        _createLabel.hidden = NO;
        NSDate *createData = [UIUtils dateFromFomate:createTime formate:@"E M d HH:mm:ss Z yyyy"];
        CGFloat scronds = fabsf([createData timeIntervalSinceNow]);
        NSString *createString = nil;
        if (scronds<120) {
            createString = @"刚刚";
            _createLabel.textColor = [UIColor orangeColor];
        }
        else if(scronds < 3600)
        {
            createString = [NSString stringWithFormat:@"%d分钟前",(int)(scronds/60)];
            _createLabel.textColor = [UIColor orangeColor];
        }
        else
        {
            createString = [UIUtils stringFromFomate:createData formate:@"MM-dd HH-mm"];
            _createLabel.textColor = [UIColor grayColor];
        }
        
        _createLabel.text = createString;
        [_createLabel sizeToFit];
        
    }
    else
    {
        _createLabel.hidden = YES;
    }

    //微博来源
    NSString *source = self.statusData.source;
    source = [NSString stringWithFormat:@"来自:%@",[self parseSource:source] ];
    if (source != nil) {
        _sourceLabel.hidden = NO;
        [_sourceLabel setFrame:CGRectMake(_createLabel.right + 5, _createLabel.top, 200, 20)];
        _sourceLabel.font = _createLabel.font;
        _sourceLabel.text = source;
        [_sourceLabel sizeToFit];
    }
    else
    {
        _sourceLabel.hidden = YES;
    }
    
    [tableHeaderView addSubview:self.statusHeaderView];
    tableHeaderView.height += 60;
    
    //微博视图
    CGFloat h = [StatusView getStatusViewHeight:self.statusData isRetweet:NO isDetail:YES];
    _statusView = [[StatusView alloc] initWithFrame:CGRectMake(0, _statusHeaderView.bottom + 5, ScreenWidth - 20, h)];
    _statusView.isDetail = YES;
    _statusView.statusDate = self.statusData;
    [tableHeaderView addSubview:_statusView];
    tableHeaderView.height += h;
    
    
    self.tableView.tableHeaderView = tableHeaderView;
    [tableHeaderView release];
}

- (NSString *)parseSource:(NSString *)source
{
    NSString *regex = @">\\w+\\s*\\w+.*<";
    NSArray *array = [source componentsMatchedByRegex:regex];
    if (array.count > 0) {
        NSString *sourceString = [array lastObject];
        NSRange range;
        range.location = 1;
        range.length = sourceString.length - 2;
        sourceString = [sourceString substringWithRange:range];
        return sourceString;
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewEventDelegate Methods

- (void)pullDown:(BaseTableView *)tableView
{
    NSString *idstr = _statusData.idstr;
    [self loadCommentsDataWithId:idstr SinceId:@"0" MaxId:@"0"];
}

#pragma mark - NetWork
- (void)loadCommentsDataWithId:(NSString *)sid SinceId:(NSString *)sinceId MaxId:(NSString *)maxId
{
    [SinaDataService getCommentDataWithId:sid SinceId:sinceId MaxId:maxId Count:@"50" Page:@"1" FilterByAuthor:@"0" Success:^(BOOL isSuccess, NSMutableArray *array) {
        if (isSuccess) {
            self.tableView.data = array;
            self.tableView.statusData = self.statusData;
            [self.tableView reloadData];
            [self.tableView doneLoadingTableViewData];
        }
        else
        {
            NSLog(@"获取评论数据失败！");
        }
    }];
}


- (void)dealloc {
    [_tableView release];
    [_userImage release];
    [_screenNameLabel release];
    [_createLabel release];
    [_sourceLabel release];
    [_statusHeaderView release];
    [super dealloc];
}
@end
