//
//  SkinLable.m
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-26.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "SkinLable.h"
#import "SkinsManager.h"

@implementation SkinLable

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skinNotification:) name:kSkinDidChangeNotification object:nil];
    }
    return self;
}

- (id)initWithLableName:(NSString *)labelName
{
    self = [self init];
    if (self) {
        self.labelName = labelName;
    }
    return self;
}

- (void)skinNotification:(NSNotification *)notification
{
    [self setColor];
}

- (void)setColor
{
    UIColor *color = [[SkinsManager shareInstance] getColorWithLabelName:self.labelName];
    self.textColor = color;
}

#pragma mark - Override Methods
- (void)setLabelName:(NSString *)labelName
{
    if (_labelName != labelName) {
        [_labelName release];
        _labelName = [labelName copy];
    }
    [self setColor];
}
     
- (void)dealloc
{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSkinDidChangeNotification object:nil];
}

@end
