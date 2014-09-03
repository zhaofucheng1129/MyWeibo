//
//  SkinButton.m
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-25.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "SkinButton.h"
#import "SkinsManager.h"

@implementation SkinButton

- (id)initWithImageName:(NSString *)imageName highlight:(NSString *)highlightImageName
{
    self = [self init];
    if (self) {
        self.imageName = imageName;
        self.highlightImageName = highlightImageName;
    }
    return self;
}

- (id)initWithBackground:(NSString *)backgroundImageName highlightBackground:(NSString *)backgroundHighlightImageName
{
    self = [self init];
    if (self) {
        self.backgroundImageName = backgroundImageName;
        self.backgroundHighlightImageName = backgroundHighlightImageName;
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

#pragma mark - Private Methods

- (void)loadImage
{
    SkinsManager *skinsManager = [SkinsManager shareInstance];
    UIImage *image = [skinsManager getSkinImage:self.imageName];
    UIImage *highlightImage = [skinsManager getSkinImage:self.highlightImageName];
    
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:highlightImage forState:UIControlStateHighlighted];
    
    UIImage *backgroundImage = [skinsManager getSkinImage:self.backgroundImageName];
    UIImage *backgroundHighlightImage = [skinsManager getSkinImage:self.backgroundHighlightImageName];
    
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [self setBackgroundImage:backgroundHighlightImage forState:UIControlStateHighlighted];
}

#pragma mark - Setter
- (void)setImageName:(NSString *)imageName
{
    if (_imageName != imageName) {
        [_imageName release];
        _imageName = [imageName copy];
    }
    [self loadImage];
}

- (void)setHighlightImageName:(NSString *)highlightImageName
{
    if (_highlightImageName != highlightImageName) {
        [_highlightImageName release];
        _highlightImageName = [highlightImageName copy];
    }
    [self loadImage];
}

- (void)setBackgroundImageName:(NSString *)backgroundImageName
{
    if (_backgroundImageName != backgroundImageName) {
        [_backgroundImageName release];
        _backgroundImageName = [backgroundImageName copy];
    }
    [self loadImage];
}

- (void)setBackgroundHighlightImageName:(NSString *)backgroundHighlightImageName
{
    if (_backgroundHighlightImageName != backgroundHighlightImageName) {
        [_backgroundHighlightImageName release];
        _backgroundHighlightImageName = [backgroundHighlightImageName copy];
    }
    [self loadImage];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
