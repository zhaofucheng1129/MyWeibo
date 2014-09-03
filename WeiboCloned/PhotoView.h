//
//  PhotoView.h
//  WeiboCloned
//
//  Created by ZhaoFucheng on 14-8-30.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoView : UIView

@property (nonatomic, retain) NSArray *urls;

+ (CGFloat)getHeight:(int)count;

@end
