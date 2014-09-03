//
//  MessageViewController.h
//  WeiboCloned
//  消息控制器
//  Created by 赵 福成 on 14-6-23.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageTableView.h"

@interface MessageViewController : BaseViewController
{
    CGFloat _height;
}

@property (nonatomic, retain) MessageTableView *tableView;

@end
