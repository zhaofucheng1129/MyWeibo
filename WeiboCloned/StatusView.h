//
//  StatusView.h
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-30.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "Status.h"
#import "PhotoView.h"

@interface StatusView : UIView <RTLabelDelegate>
{
    @private
    RTLabel *_textLabel;
    UIImageView *_image; //微博图片
    PhotoView *_photoView;
    UIImageView *_backgroundImage;
    StatusView *_retweetView;
    
    NSMutableString *_parsedText;
}
//微博数据
@property(nonatomic,retain)Status *statusDate;

//是否有转发
@property(nonatomic,assign)BOOL isRetweet;

@property(nonatomic,assign)BOOL isDetail;

+ (CGFloat)getFontSize:(BOOL)isDetail isRetweet:(BOOL)isRetweet;

+ (CGFloat)getStatusViewHeight:(Status *)status isRetweet:(BOOL)isRetweet isDetail:(BOOL)isDetail;

@end
