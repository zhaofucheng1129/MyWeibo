//
//  BaseNavigationController.m
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-23.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "BaseNavigationController.h"
#import "SkinsManager.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skinNotification:) name:kSkinDidChangeNotification object:nil];
    }
    return self;
}

- (void)skinNotification:(NSNotification *)notification
{
    [self loadImage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadImage];
}

- (void)loadImage
{
    if (CurrentVersion() >= 5.0 && CurrentVersion() < 7.0) {
        UIImage *image = [[SkinsManager shareInstance] getSkinImage:@"navigationbar_background@2x.png"];
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    else if(CurrentVersion() >= 7.0)
    {
        if ([SkinsManager shareInstance].skinName!=nil) {
            UIImage *image = [[SkinsManager shareInstance] getSkinImage:@"navigationbar_background_os7@2x.png"];
            [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        }
    }
    else
    {
        [self.navigationBar setNeedsDisplay];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSkinDidChangeNotification object:nil];
}
@end
