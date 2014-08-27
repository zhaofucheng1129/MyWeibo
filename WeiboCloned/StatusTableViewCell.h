//
//  StatusTableViewCell.h
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-30.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"
#import "StatusView.h"

@interface StatusTableViewCell : UITableViewCell
{
    @private
    UIImageView *_userImage;    //用户头像师徒
    UILabel *_screenNameLabel;  //昵称
    UILabel *_repostCountLabel; //转发数
    UILabel *_commentLabel;     //回复数
    UILabel *_sourceLabel;      //发布来源
    UILabel *_createLabel;      //发布时间
}

@property(nonatomic,retain)Status *statusData;

@property(nonatomic,retain)StatusView *statusView;
@end
