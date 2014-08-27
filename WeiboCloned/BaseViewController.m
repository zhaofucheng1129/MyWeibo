//
//  BaseViewController.m
//  WeiboCloned
//
//  Created by 赵 福成 on 14-6-23.
//  Copyright (c) 2014年 ZhaoFucheng. All rights reserved.
//

#import "BaseViewController.h"
#import "UIFactory.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isBackButton = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && self.isBackButton) {
        UIButton *button = [UIFactory createButton:@"navigationbar_back@2x.png" highlight:@"navigationbar_back_highlighted@2x.png"];
        button.frame = CGRectMake(0, 0, 30, 30);
        [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = [backItem autorelease];
    }
}

- (void)backAction:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Override Method
- (void)setTitle:(NSString *)title
{
    UILabel *titleLabel = [UIFactory createLabel:kNavigationBarTitleColor];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:title];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

@end
