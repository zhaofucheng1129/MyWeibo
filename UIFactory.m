//
//  UIFactory.m
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-25.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "UIFactory.h"

@implementation UIFactory

+ (SkinButton *)createButton:(NSString *)imageName highlight:(NSString *)highlightImageName
{
    SkinButton *button = [[SkinButton alloc] initWithImageName:imageName highlight:highlightImageName];
    return [button autorelease];
}

+ (SkinButton *)createButtonWithBackground:(NSString *)backgroundImageName backgroundHighlight:(NSString *)backgroundHighlightImageName
{
    SkinButton *button = [[SkinButton alloc] initWithBackground:backgroundImageName highlightBackground:backgroundHighlightImageName];
    return [button autorelease];
}

+ (SkinImageView *)createImageView:(NSString *)imageName
{
    SkinImageView *image = [[SkinImageView alloc] initWithImageName:imageName];
    return [image autorelease];
}

+ (SkinLable *)createLabel:(NSString *)labelName
{
    SkinLable *label = [[SkinLable alloc] initWithLableName:labelName];
    return [label autorelease];
}
@end
