//
//  HomeViewController.h
//  WeiboCloned
//  首页控制器
//  Created by 赵 福成 on 14-6-23.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "BaseViewController.h"
#import "StatusTableView.h"
#import "ZBarSDK.h"

@interface HomeViewController : BaseViewController <UITableViewEventDelegate,ZBarReaderDelegate>
{
    CGFloat _height;
}
@property (retain, nonatomic) StatusTableView *tableView;
@property (nonatomic, retain) UIImageView *newStatusCountView;

@property (nonatomic, copy) NSString *SinceId;
@property (nonatomic, copy) NSString *MaxId;

- (void)refreshLoading;

@end
