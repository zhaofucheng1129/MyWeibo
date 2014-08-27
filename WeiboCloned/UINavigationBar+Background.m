//
//  UINavigationBar+Background.m
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-25.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "UINavigationBar+Background.h"
#import "SkinsManager.h"
@implementation UINavigationBar (Background)
//5.o一下系统设置导航栏背景
- (void)drawRect:(CGRect)rect {
    UIImage *image = [[SkinsManager shareInstance] getSkinImage:@"navigationbar_background@2x.png"];
    [image drawInRect:rect];
}

@end
