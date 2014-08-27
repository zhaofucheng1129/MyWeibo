//
//  DetailViewController.h
//  WeiboCloned
//
//  Created by ZhaoFucheng on 14-8-14.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "BaseViewController.h"
#import "StatusTableView.h"

@class Status;
@class StatusView;
@class CommentTableView;

@interface DetailViewController : BaseViewController<UITableViewEventDelegate>
{
    StatusView *_statusView;
}

@property (nonatomic, retain) Status *statusData;

@property (retain, nonatomic) IBOutlet CommentTableView *tableView;
@property (retain, nonatomic) IBOutlet UIImageView *userImage;
@property (retain, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (retain, nonatomic) UILabel *createLabel;
@property (retain, nonatomic) UILabel *sourceLabel;
@property (retain, nonatomic) IBOutlet UIView *statusHeaderView;
@end
