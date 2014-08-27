//
//  Utils.h
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-23.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ScreenHeight CGRectGetHeight([[UIScreen mainScreen] bounds])
#define ScreenWidth CGRectGetWidth([[UIScreen mainScreen] bounds])


#define UIColorMake(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

float CurrentVersion();

