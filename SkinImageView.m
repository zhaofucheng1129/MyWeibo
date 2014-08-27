//
//  SkinImageView.m
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-25.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "SkinImageView.h"
#import "SkinsManager.h"
@implementation SkinImageView

- (id)initWithImageName:(NSString *)imageName
{
    self = [self init];
    if (self) {
        self.imageName = imageName;
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skinNotification:) name:kSkinDidChangeNotification object:nil];
    }
    return self;
}

- (void)skinNotification:(NSNotification *)notification
{
    [self loadImage];
}

- (void)loadImage
{
    if (self.imageName == nil) {
        return;
    }
    UIImage *image = [[SkinsManager shareInstance] getSkinImage:self.imageName];
    image = [image stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    self.image = image;    
}

- (void)setImageName:(NSString *)imageName
{
    if (_imageName != imageName) {
        [_imageName release];
        _imageName = [imageName copy];
    }
    [self loadImage];
}

- (void)dealloc
{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSkinDidChangeNotification object:nil];
}
@end
